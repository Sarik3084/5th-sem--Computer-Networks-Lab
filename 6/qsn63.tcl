set ns [new Simulator]

set topo [new Topography]
$topo load_flatgrid 300 300

set namfile [open nm.nam w]
$ns namtrace-all-wireless $namfile 300 300

set tracefile [open trc.tr w]
$ns trace-all $tracefile

create-god 6

$ns node-config -adhocRouting AODV \
-llType LL \
-macType Mac/802_11 \
-ifqType Queue/DropTail/PriQueue \
-ifqLen 50 \
-antType Antenna/OmniAntenna \
-propType Propagation/TwoRayGround \
-phyType Phy/WirelessPhy \
-channelType Channel/WirelessChannel \
-topoInstance $topo \
-agentTrace ON \
-routerTrace ON \
-macTrace OFF \
-movementTrace ON

set node1 [$ns node]
$node1 color black
$node1 set X_ [expr rand()*250]
$node1 set Y_ [expr rand()*250]
$node1 set Z_ 0
set node2 [$ns node]
$node2 color black
$node2 set X_ [expr rand()*250]
$node2 set Y_ [expr rand()*250]
$node2 set Z_ 0
set tcp [new Agent/TCP]
$ns attach-agent $node1 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $node2 $sink
$ns connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns initial_node_pos $node1 10
$ns initial_node_pos $node2 10



set node3 [$ns node]
$node3 color black
$node3 set X_ [expr rand()*250]
$node3 set Y_ [expr rand()*250]
$node3 set Z_ 0
set node4 [$ns node]
$node4 color black
$node4 set X_ [expr rand()*250]
$node4 set Y_ [expr rand()*250]
$node4 set Z_ 0
set tcp1 [new Agent/TCP]
$ns attach-agent $node3 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $node4 $sink1
$ns connect $tcp1 $sink1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns initial_node_pos $node3 10
$ns initial_node_pos $node4 10


set node5 [$ns node]
$node5 color black
$node5 set X_ [expr rand()*250]
$node5 set Y_ [expr rand()*250]
$node5 set Z_ 0
set node6 [$ns node]
$node6 color black
$node6 set X_ [expr rand()*250]
$node6 set Y_ [expr rand()*250]
$node6 set Z_ 0
set tcp2 [new Agent/TCP]
$ns attach-agent $node5 $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $node6 $sink2
$ns connect $tcp2 $sink2
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ns initial_node_pos $node5 10
$ns initial_node_pos $node6 10


$ns at 10.0 "$ns nam-end-wireless 10.0"
$ns at 10.0 "stop"
proc plot {tcpsource filename} {
	global ns	
	set cwd [$tcpsource set cwnd_]
	set now [$ns now]
	puts $filename "$now $cwd"
	$ns at  [expr $now+0.1] "plot $tcpsource $filename"
	} 
proc stop { } {
	global namfile tracefile ns
	$ns flush-trace
	close $namfile
	close $tracefile
	exec xgraph congestion.x congestion1.x congestion2.x &
	exec nam nm.nam &
	exit 0;
}

set outfile [open "congestion.x" w]
set outfile1 [open "congestion1.x" w]
set outfile2 [open "congestion2.x" w]
$ns at 0 "plot $tcp $outfile"
$ns at 0 "plot $tcp1 $outfile1"
$ns at 0 "plot $tcp2 $outfile2"

$ns at 0.0 "$ftp start"
$ns at 10.0 "$ftp stop"
$ns at 0.0 "$ftp1 start"
$ns at 10.0 "$ftp1 stop"
$ns at 0.0 "$ftp2 start"
$ns at 10.0 "$ftp2 stop"
$ns run

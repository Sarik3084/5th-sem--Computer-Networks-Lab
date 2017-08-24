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

set x1 [$node1 set X_]
set y1 [$node1 set Y_]
set x2 [$node2 set X_]
set y2 [$node2 set Y_]
set dx [expr $x1-$x2]
set dy [expr $y1-$y2]
set dis [expr pow(($dx*$dx + $dy*$dy),0.5)]
set rss [expr .281838/$dis]
puts "$dis\n"
puts "$rss\n"

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

set x1 [$node3 set X_]
set y1 [$node3 set Y_]
set x2 [$node4 set X_]
set y2 [$node4 set Y_]
set dx [expr $x1-$x2]
set dy [expr $y1-$y2]
set dis [expr pow(($dx*$dx + $dy*$dy),0.5)]
set rss [expr .281838/$dis]
puts "$dis\n"
puts "$rss\n"

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

set x1 [$node5 set X_]
set y1 [$node5 set Y_]
set x2 [$node6 set X_]
set y2 [$node6 set Y_]
set dx [expr $x1-$x2]
set dy [expr $y1-$y2]
set dis [expr pow(($dx*$dx + $dy*$dy),0.5)]
set rss [expr .281838/$dis]
puts "$dis\n"
puts "$rss\n"

$ns at 10.0 "$ns nam-end-wireless 10.0"
$ns at 10.0 "stop"

proc stop { } {
	global namfile tracefile ns
	$ns flush-trace
	close $namfile
	close $tracefile
	exec nam nm.nam &
	exit 0;
}
$ns at 0.0 "$ftp start"
$ns at 10.0 "$ftp stop"
$ns at 0.0 "$ftp1 start"
$ns at 10.0 "$ftp1 stop"
$ns at 0.0 "$ftp2 start"
$ns at 10.0 "$ftp2 stop"
$ns run

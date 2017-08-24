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

Phy/WirelessPhy set freq_ 2.4e+9
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
set udp [new Agent/UDP]
$ns attach-agent $node1 $udp
set sink [new Agent/LossMonitor]
$ns attach-agent $node2 $sink
$ns connect $udp $sink
set ftp [new Application/Traffic/CBR]
$ftp attach-agent $udp
$ns initial_node_pos $node1 10
$ns initial_node_pos $node2 10

Phy/WirelessPhy set freq_ 2.3e+9
Phy/WirelessPhy set CSThresh_ 6.0908e-10 
#220m 
Phy/WirelessPhy set RXThresh_ 3.03646e-09 
#100m
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
set udp1 [new Agent/UDP]
$ns attach-agent $node3 $udp1
set sink1 [new Agent/LossMonitor]
$ns attach-agent $node4 $sink1
$ns connect $udp1 $sink1
set ftp1 [new Application/Traffic/CBR]
$ftp1 attach-agent $udp1
$ns initial_node_pos $node3 10
$ns initial_node_pos $node4 10

Phy/WirelessPhy set freq_ 2.2e+9
Phy/WirelessPhy set CSThresh_ 9.50808e-11 
#350m 
Phy/WirelessPhy set RXThresh_ 1.14836e-09
#170m
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
set udp2 [new Agent/UDP]
$ns attach-agent $node5 $udp2
set sink2 [new Agent/LossMonitor]
$ns attach-agent $node6 $sink2
$ns connect $udp2 $sink2
set ftp2 [new Application/Traffic/CBR]
$ftp2 attach-agent $udp2
$ns initial_node_pos $node5 10
$ns initial_node_pos $node6 10


$ns at 10.0 "$ns nam-end-wireless 10.0"
$ns at 10.0 "stop"

set outfile [open "loss.x" w]
set outfile1 [open "loss1.x" w]
set outfile2 [open "loss2.x" w]
proc plot { } {
	global ns sink sink1 sink2 outfile outfile1 outfile2
	set times 0.1
	set b [$sink set bytes_]
	set b1 [$sink1 set bytes_]
	set b2 [$sink2 set bytes_]
	set now [$ns now]
	puts $outfile "$now [expr $b/$times*8/1000]"
	puts $outfile1 "$now [expr $b1/$times*8/1000]"
	puts $outfile2 "$now [expr $b2/$times*8/1000]"
	$sink set bytes_ 0
	$sink1 set bytes_ 0
	$sink2 set bytes_ 0
	$ns at [expr $now+$times] "plot"

} 
proc stop { } {
	global namfile tracefile ns
	$ns flush-trace
	close $namfile
	close $tracefile
	exec nam nm.nam &
	exec xgraph loss.x loss1.x loss2.x &
	exit 0;
}

set x [expr {int(1+rand()*300)}]
set y [expr {int(1+rand()*300)}]
$ns at 1.0 "$node2 setdest $x $y 100.0"
set x [expr {int(1+rand()*300)}]
set y [expr {int(1+rand()*300)}]
$ns at 1.5 "$node4 setdest $x $y 100.0"
set x [expr {int(1+rand()*300)}]
set y [expr {int(1+rand()*300)}]
$ns at 2.0 "$node6 setdest $x $y 100.0"

set x [expr {int(1+rand()*300)}]
set y [expr {int(1+rand()*300)}]
$ns at 5.0 "$node1 setdest $x $y 100.0"
set x [expr {int(1+rand()*300)}]
set y [expr {int(1+rand()*300)}]
$ns at 5.5 "$node3 setdest $x $y 100.0"
set x [expr {int(1+rand()*300)}]
set y [expr {int(1+rand()*300)}]
$ns at 6.0 "$node5 setdest $x $y 100.0"

$ns at 0.0 "plot"
$ns at 0.0 "$ftp start"
$ns at 10.0 "$ftp stop"
$ns at 0.0 "$ftp1 start"
$ns at 10.0 "$ftp1 stop"
$ns at 0.0 "$ftp2 start"
$ns at 10.0 "$ftp2 stop"
$ns run

set ns [new Simulator]

set topo [new Topography]
$topo load_flatgrid 1000 800

set namfile [open nm.nam w]
$ns namtrace-all-wireless $namfile 1000 800

set tracefile [open trc.tr w]
$ns trace-all $tracefile

create-god 8

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

$node1 set X_ 100
$node1 set Y_ 100
$node1 set Z_ 0

set node2 [$ns node]
$node2 color black

$node2 set X_ 300
$node2 set Y_ 100
$node2 set Z_ 0

set node3 [$ns node]
$node3 color black

$node3 set X_ 100
$node3 set Y_ 300
$node3 set Z_ 0

set node4 [$ns node]
$node4 color black

$node4 set X_ 300
$node4 set Y_ 300
$node4 set Z_ 0

set node5 [$ns node]
$node5 color black

$node5 set X_ 100
$node5 set Y_ 500
$node5 set Z_ 0

set node6 [$ns node]
$node6 color black

$node6 set X_ 300
$node6 set Y_ 500
$node6 set Z_ 0

set node7 [$ns node]
$node7 color black

$node7 set X_ 100
$node7 set Y_ 700
$node7 set Z_ 0

set node8 [$ns node]
$node8 color black

$node8 set X_ 300
$node8 set Y_ 700
$node8 set Z_ 0

set udp1 [new Agent/UDP]
$ns attach-agent $node1 $udp1
set sink1 [new Agent/Null]
$ns attach-agent $node2 $sink1
$ns connect $udp1 $sink1

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1


set udp2 [new Agent/UDP]
$ns attach-agent $node3 $udp2
set sink2 [new Agent/Null]
$ns attach-agent $node4 $sink2
$ns connect $udp2 $sink2

set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp2


set udp3 [new Agent/UDP]
$ns attach-agent $node5 $udp3
set sink3 [new Agent/Null]
$ns attach-agent $node6 $sink3
$ns connect $udp3 $sink3

set cbr3 [new Application/Traffic/CBR]
$cbr3 attach-agent $udp3


set udp4 [new Agent/UDP]
$ns attach-agent $node7 $udp4
set sink4 [new Agent/Null]
$ns attach-agent $node8 $sink4
$ns connect $udp4 $sink4

set cbr4 [new Application/Traffic/CBR]
$cbr4 attach-agent $udp4


$ns initial_node_pos $node1 50
$ns initial_node_pos $node2 50
$ns initial_node_pos $node3 50
$ns initial_node_pos $node4 50
$ns initial_node_pos $node5 50
$ns initial_node_pos $node6 50
$ns initial_node_pos $node7 50
$ns initial_node_pos $node8 50

$ns at 10.0 "$ns nam-end-wireless 10.0"
$ns at 10.0 "stop"

proc stop { } {
	global namfile tracefile ns
	$ns flush-trace
	close $namfile
	close $tracefile

	exec rm -f out.x
	exec touch out.x
	exec awk -f th.awk trc.tr &
	
	exec nam nm.nam &
	exec xgraph out.x &
	exit 0;
}
$ns at 0.0 "$cbr1 start"
$ns at 0.0 "$cbr2 start"
$ns at 0.0 "$cbr3 start"
$ns at 0.0 "$cbr4 start"
set x [expr {int(1+rand()*500)}]
set y [expr {int(1+rand()*700)}]
$ns at 1.0 "$node2 setdest $x $y 100.0"
set x [expr {int(1+rand()*500)}]
set y [expr {int(1+rand()*700)}]
$ns at 1.5 "$node4 setdest $x $y 100.0"
set x [expr {int(1+rand()*500)}]
set y [expr {int(1+rand()*700)}]
$ns at 2.0 "$node6 setdest $x $y 100.0"
set x [expr {int(1+rand()*500)}]
set y [expr {int(1+rand()*700)}]
$ns at 2.5 "$node8 setdest $x $y 100.0"
set x [expr {int(1+rand()*500)}]
set y [expr {int(1+rand()*700)}]
$ns at 5.0 "$node1 setdest $x $y 100.0"
set x [expr {int(1+rand()*500)}]
set y [expr {int(1+rand()*700)}]
$ns at 5.5 "$node3 setdest $x $y 100.0"
set x [expr {int(1+rand()*500)}]
set y [expr {int(1+rand()*700)}]
$ns at 6.0 "$node5 setdest $x $y 100.0"
set x [expr {int(1+rand()*500)}]
set y [expr {int(1+rand()*700)}]
$ns at 6.5 "$node7 setdest $x $y 100.0"
$ns at 10.0 "$cbr1 stop"
$ns at 10.0 "$cbr2 stop"
$ns at 10.0 "$cbr3 stop"
$ns at 10.0 "$cbr4 stop"
$ns run

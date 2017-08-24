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

Phy/WirelessPhy set freq_ 914e+6
Phy/WirelessPhy set CSThresh_ 2.28289e-11
#500m  
Phy/WirelessPhy set RXThresh_ 3.35262e-10 
#250m  
set node1 [$ns node]

$node1 set X_ 100
$node1 set Y_ 100
$node1 set Z_ 0

set node2 [$ns node]

$node2 set X_ 300
$node2 set Y_ 100
$node2 set Z_ 0

set node3 [$ns node]

$node3 set X_ 100
$node3 set Y_ 300
$node3 set Z_ 0

set node4 [$ns node]

$node4 set X_ 300
$node4 set Y_ 300
$node4 set Z_ 0

set node5 [$ns node]

$node5 set X_ 100
$node5 set Y_ 500
$node5 set Z_ 0

set node6 [$ns node]

$node6 set X_ 300
$node6 set Y_ 500
$node6 set Z_ 0


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




$ns initial_node_pos $node1 50
$ns initial_node_pos $node2 50
$ns initial_node_pos $node3 50
$ns initial_node_pos $node4 50
$ns initial_node_pos $node5 50
$ns initial_node_pos $node6 50


$ns at 10.0 "$ns nam-end-wireless 10.0"
$ns at 10.0 "stop"

proc stop { } {
	global namfile tracefile ns
	$ns flush-trace
	close $namfile
	close $tracefile

	exec rm -f out.x
	exec touch out.x
	exec awk -f thlab7.awk trc.tr 
	exec awk -f through7.awk trc.tr &
	
	exec nam nm.nam &
	exec xgraph out.x &
	exit 0;
}
$ns at 0.0 "$cbr1 start"
$ns at 0.0 "$cbr2 start"
$ns at 0.0 "$cbr3 start"


$ns at 10.0 "$cbr1 stop"
$ns at 10.0 "$cbr2 stop"
$ns at 10.0 "$cbr3 stop"
$ns run

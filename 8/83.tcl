set ns [new Simulator]

set topo [new Topography]
$topo load_flatgrid 500 400

set namfile [open nm.nam w]
$ns namtrace-all-wireless $namfile 500 400

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
set node3 [$ns node]
$node3 color black
set node4 [$ns node]
$node4 color black
set node5 [$ns node]
$node5 color black
set node6 [$ns node]
$node6 color black
set node7 [$ns node]
$node7 color black
set node8 [$ns node]
$node8 color black


set node9 [$ns node]
$node2 color black
set node10 [$ns node]
$node3 color black
set node11 [$ns node]
$node4 color black
set node12 [$ns node]
$node5 color black
set node13 [$ns node]
$node6 color black
set node14 [$ns node]
$node7 color black
set node15 [$ns node]
$node8 color black
set node16 [$ns node]
$node8 color black

$node2 set X_ 100
$node2 set Y_ 200
$node2 set Z_ 0
$node3 set X_ 100
$node3 set Y_ 300
$node3 set Z_ 0
$node4 set X_ 100
$node4 set Y_ 400
$node4 set Z_ 0
$node5 set X_ 300
$node5 set Y_ 100
$node5 set Z_ 0
$node6 set X_ 300
$node6 set Y_ 200
$node6 set Z_ 0
$node7 set X_ 300
$node7 set Y_ 300
$node7 set Z_ 0
$node8 set X_ 300
$node8 set Y_ 400
$node8 set Z_ 0


set tcp [new Agent/UDP]
$ns attach-agent $node1 $tcp
set sink [new Agent/LossMonitor]
$ns attach-agent $node5 $sink
$ns connect $tcp $sink

set tcp2 [new Agent/UDP]
$ns attach-agent $node2 $tcp2
set sink2 [new Agent/LossMonitor]
$ns attach-agent $node6 $sink2
$ns connect $tcp2 $sink2

set tcp3 [new Agent/UDP]
$ns attach-agent $node3 $tcp3
set sink3 [new Agent/LossMonitor]
$ns attach-agent $node7 $sink3
$ns connect $tcp3 $sink3

set tcp4 [new Agent/UDP]
$ns attach-agent $node4 $tcp4
set sink4 [new Agent/LossMonitor]
$ns attach-agent $node8 $sink4
$ns connect $tcp4 $sink4

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $tcp
set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $tcp2
set cbr3 [new Application/Traffic/CBR]
$cbr3 attach-agent $tcp3
set cbr4 [new Application/Traffic/CBR]
$cbr4 attach-agent $tcp4

$ns initial_node_pos $node1 30
$ns initial_node_pos $node2 30
$ns initial_node_pos $node3 30
$ns initial_node_pos $node4 30
$ns initial_node_pos $node5 30
$ns initial_node_pos $node6 30
$ns initial_node_pos $node7 30
$ns initial_node_pos $node8 30


$ns at 10.0 "$ns nam-end-wireless 10.0"
$ns at 10.0 "stop"

proc stop { } {
	global namfile tracefile ns
	$ns flush-trace
	close $namfile
	close $tracefile
	exec rm -f out1.tr
	exec gawk -f as.awk trc.tr &
	exec nam nm.nam &
	exit 0;
}
$ns at 0.0 "$cbr start"
$ns at 0.0 "$cbr2 start"
$ns at 0.0 "$cbr3 start"
$ns at 0.0 "$cbr4 start"

$ns run

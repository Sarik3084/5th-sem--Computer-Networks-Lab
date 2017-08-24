set ns [new Simulator]

# Define options
set val(chan) Channel/WirelessChannel ;# channel type
set val(prop) Propagation/TwoRayGround ;# radio-propagation model
set val(netif) Phy/WirelessPhy ;# network interface type
set val(mac) Mac/802_11 ;# MAC type
set val(ifq) Queue/DropTail/PriQueue ;# interface queue type
set val(ll) LL ;# link layer type
set val(ant) Antenna/OmniAntenna ;# antenna model
set val(ifqlen) 50 ;# max packet in ifq
set val(nn) 16 ;# number of mobilenodes
set val(rp) AODV ;# routing protocol
set val(x) 500 ;# X dimension of topography
set val(y) 500 ;# Y dimension of topography
set val(stop) 10.0 ;# time of simulation end

set namfile [open 2a.nam w]
$ns namtrace-all-wireless $namfile $val(x) $val(y)


set tracefile [open 2a.tr w]
$ns trace-all $tracefile

# set up topography object
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)


proc finish {} {
global ns tracefile namfile
$ns flush-trace
close $tracefile
close $namfile
exec nam 2a.nam &
exec awk -f Throughput.awk 2a.tr > Throughput.txt &
exec xgraph -geometry 500X500 -x time(s) -y throughput(Mbits/s) Throughput.txt &
exec xgraph -bb -tk -x time -y queue data.txt &
exit 0
}


# general operational descriptor- storing the hop details in the network
create-god $val(nn)

# configure the nodes
$ns node-config -adhocRouting $val(rp) \
-llType $val(ll) \
-macType $val(mac) \
-ifqType $val(ifq) \
-ifqLen $val(ifqlen) \
-antType $val(ant) \
-propType $val(prop) \
-phyType $val(netif) \
-channelType $val(chan) \
-topoInstance $topo \
-agentTrace ON \
-routerTrace ON \
-macTrace OFF \
-movementTrace ON


# Node Creation

for {set i 0} {$i < $val(nn)} {incr i} {

set node_($i) [$ns node]
$node_($i) color black

}

#Location fixing for a single node  **** One node is fixed and remaining 3 are moving ****

$node_(0) set X_ 250
$node_(0) set Y_ 250
$node_(0) set Z_ 0

for {set i 1} {$i < $val(nn)} {incr i} {

$node_($i) set X_ [expr rand()*$val(x)]
$node_($i) set Y_ [expr rand()*$val(y)]
$node_($i) set Z_ 0

}
# Label and coloring

for {set i 0} {$i < $val(nn)} {incr i} {

$ns at 0.1 "$node_($i) color red"
$ns at 0.1 "$node_($i) label Node$i"

}

#Size of the node

for {set i 0} {$i < $val(nn)} {incr i} {

$ns initial_node_pos $node_($i) 30

}

set null [new Agent/Null]
$ns attach-agent $node_(0) $null

for {set i 1} {$i < $val(nn)} {incr i} {
set udp($i) [new Agent/UDP]
$ns attach-agent $node_($i) $udp($i)
$ns connect $udp($i) $null

set cbr($i) [new Application/Traffic/CBR]
$cbr($i) attach-agent $udp($i)
$cbr($i) set packetSize_ 512
$cbr($i) set interval_ 0.1
$ns at 1.0 "$cbr($i) start"
}

# ending nam and the simulation
#$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"

#Stopping the scheduler
$ns at 10.01 "puts \"end simulation\" ; $ns halt"
$ns at 10.01 "$ns halt"


$ns run

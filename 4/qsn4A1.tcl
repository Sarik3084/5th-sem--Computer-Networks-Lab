#Lan simulation
set ns [new Simulator]

#define color for data flows
$ns color 1 Blue
$ns color 2 Red

 #open tracefiles
set tracefile1 [open out.tr w]
$ns trace-all $tracefile1

#open nam file
set namfile [open out.nam w]
$ns namtrace-all $namfile

#define the finish procedure
proc finish {} {
global ns tracefile1 namfile
$ns flush-trace
close $tracefile1
close $namfile
exec nam out.nam &
exit 0
}

 #create six nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]
set n9 [$ns node]
set n10 [$ns node]
$n1 color Red
$n1 shape box

$ns duplex-link  $n0 $n10 2Mb 1ms DropTail


$ns duplex-link-op $n0 $n10 orient left
#create links between the nodes
set lan [$ns newLan "$n0 $n1 $n2 $n3 $n4 $n5 $n6 $n7 $n8 $n9" 0.5Mb 40ms LL Queue/DropTail MAC/Csma/Cd Channel]



#setup a UDP connection
set udp [new Agent/UDP]
$ns attach-agent $n0 $udp
set null [new Agent/Null]
$ns attach-agent $n6 $null
$ns connect $udp $null
$udp set fid_ 2

#setup a CBR over UDP connection
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 1000
$cbr set rate_ 0.1Mb
$cbr set random_ falsea

#scheduling the events
$ns at 0.1 "$cbr start"
$ns at 1.0 "$cbr stop"

$ns at 1.0 "finish"
$ns run

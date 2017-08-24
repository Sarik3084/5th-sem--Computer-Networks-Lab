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

$n1 color Red
$n1 shape box


$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n0 $n1 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 20ms RED 

Queue/RED set linterm_ 5

$ns duplex-link-op $n0 $n2  orient right
$ns duplex-link-op $n1 $n2  orient right-up
$ns duplex-link-op $n0 $n1  orient right-down 
$ns duplex-link-op $n2 $n3  orient right
 


#create links between the nodes
set lan [$ns newLan "$n3 $n4 $n5 $n6 " 0.5Mb 40ms LL Queue/DropTail MAC/Csma/Cd Channel]

set tcp [new Agent/TCP/Newreno]
$ns attach-agent $n1 $tcp
set sink [new Agent/TCPSink/DelAck]
$ns attach-agent $n5 $sink
$ns connect $tcp $sink
$tcp set fid_ 1
$tcp set packet_size_ 552

#set ftp over tcp connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp





#scheduling the events
$ns at 0.1 "$ftp start"
$ns at 25.0 "$ftp stop"

$ns at 25.0 "finish"
$ns run


#Event Scheduler Object creation.

set ns [new Simulator]

#Creating trace objects and nam objects.

set traceFile [open traceOutput.tr w]
set namFile [open namOutput.nam w]
$ns trace-all $traceFile
$ns namtrace-all $namFile

#Finish procedure
proc finish {}   {
    global ns traceFile namFile
    $ns flush-trace
    close $traceFile
    close $namFile
    exec nam namOutput.nam &
    exit 0
}

#Create the network
set node0 [$ns node]
set node1 [$ns node]
set node2 [$ns node]
set node3 [$ns node]
set node4 [$ns node]


#Creating Duplex-Link
$ns duplex-link $node1 $node0 1Mb 10ms DropTail
$ns duplex-link $node2 $node0 1Mb 10ms DropTail
$ns duplex-link $node3 $node0 1Mb 10ms DropTail
$ns duplex-link $node4 $node0 1Mb 70ms DropTail

Agent/Ping instproc recv {from rtt} {
        $self instvar node_
        puts "node [$node_ id] received ping answer from \
              $from with round-trip-time $rtt ms."
}

set pingAgent1 [new Agent/Ping]
set pingAgent2 [new Agent/Ping]
set pingAgent3 [new Agent/Ping]
set pingAgent4 [new Agent/Ping]


$ns attach-agent $node1 $pingAgent1
$ns attach-agent $node2 $pingAgent2
$ns attach-agent $node3 $pingAgent3
$ns attach-agent $node4 $pingAgent4

$ns connect $pingAgent1 $pingAgent4
$ns connect $pingAgent2 $pingAgent3

$ns at 0.1 "$pingAgent1 send"
$ns at 0.3 "$pingAgent2 send"
$ns at 0.5 "$pingAgent3 send"
$ns at 1.0 "$pingAgent4 send"
$ns at 2.0 "finish"

$ns run



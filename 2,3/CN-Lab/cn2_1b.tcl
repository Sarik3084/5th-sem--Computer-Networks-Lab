#assign 2 q1 multiple flow traffic
#Create a simulator object
set ns [new Simulator]

#Define different colors for data flows (for NAM)
$ns color 1 Blue
$ns color 2 Red
$ns color 3 Yellow
$ns color 4 Green
$ns color 5 Magenta

#Open the NAM trace file
set nf [open out.nam w]
$ns namtrace-all $nf

#Define a 'finish' procedure
proc finish {} {
        global ns nf
        $ns flush-trace
        #Close the NAM trace file
        close $nf
        #Execute NAM on the trace file
        exec nam out.nam &
        exit 0
}

#Create four nodes
set n0 [$ns node]
set n1 [$ns node]


#Create links between the nodes
$ns duplex-link $n0 $n1 1.5Mb 10ms DropTail


#Set Queue Size of link (n2-n3) to 10
$ns queue-limit $n0 $n1 10


$ns duplex-link-op $n0 $n1 orient right




#Setup a TCP connection
set tcp0 [new Agent/TCP]
$tcp0 set class_ 2
$ns attach-agent $n0 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n1 $sink0
$ns connect $tcp0 $sink0
$tcp0 set fid_ 1

set tcp1 [new Agent/TCP]
$tcp1 set class_ 2
$ns attach-agent $n0 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n1 $sink1
$ns connect $tcp1 $sink1
$tcp1 set fid_ 2

set tcp2 [new Agent/TCP]
$tcp2 set class_ 2
$ns attach-agent $n0 $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $n1 $sink2
$ns connect $tcp2 $sink2
$tcp2 set fid_ 3

set tcp3 [new Agent/TCP]
$tcp3 set class_ 2
$ns attach-agent $n0 $tcp3
set sink3 [new Agent/TCPSink]
$ns attach-agent $n1 $sink3
$ns connect $tcp3 $sink3
$tcp3 set fid_ 4

set tcp4 [new Agent/TCP]
$tcp4 set class_ 2
$ns attach-agent $n0 $tcp4
set sink4 [new Agent/TCPSink]
$ns attach-agent $n1 $sink4
$ns connect $tcp4 $sink4
$tcp4 set fid_ 5


#Setup a FTP over TCP connection
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ftp0 set type_ FTP

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ftp2 set type_ FTP

set ftp3 [new Application/FTP]
$ftp3 attach-agent $tcp3
$ftp3 set type_ FTP

set ftp4 [new Application/FTP]
$ftp4 attach-agent $tcp4
$ftp4 set type_ FTP




$ns at 0.0 "$ftp0 start"
$ns at 0.0 "$ftp1 start"
$ns at 0.0 "$ftp2 start"
$ns at 0.0 "$ftp3 start"
$ns at 0.0 "$ftp4 start"
$ns at 4.0 "$ftp0 stop"
$ns at 4.1 "$ftp1 stop"
$ns at 4.2 "$ftp2 stop"
$ns at 4.3 "$ftp3 stop"
$ns at 4.4 "$ftp4 stop"

#Detach tcp and sink agents (not really necessary)
#$ns at 4.5 "$ns detach-agent $n0 $tcp ; $ns detach-agent $n1 $sink"

#Call the finish procedure after 5 seconds of simulation time
$ns at 5.0 "finish"



#Run the simulation
$ns run


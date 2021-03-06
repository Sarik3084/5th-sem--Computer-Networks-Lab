#assign 2 q1 single flow traffic
#Create a simulator object
set ns [new Simulator]

#Define different colors for data flows (for NAM)
$ns color 1 Blue


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
set tcp [new Agent/TCP]
$tcp set class_ 2
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n1 $sink
$ns connect $tcp $sink
$tcp set fid_ 1

#Setup a FTP over TCP connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP







$ns at 0.0 "$ftp start"
$ns at 4.0 "$ftp stop"

#Detach tcp and sink agents (not really necessary)
$ns at 4.5 "$ns detach-agent $n0 $tcp ; $ns detach-agent $n1 $sink"

#Call the finish procedure after 5 seconds of simulation time
$ns at 5.0 "finish"



#Run the simulation
$ns run


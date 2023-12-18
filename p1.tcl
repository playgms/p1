# create a network simulator object
set ns [new Simulator]

# create a trace file for the simulation
set tracefile [open out.tr w]
$ns trace-all $tracefile

# create a nam trace file for visualization
set namfile [open out.nam w]
$ns namtrace-all $namfile

# create four nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

# create links
$ns duplex-link $n0 $n2 5Mb 2ms DropTail
$ns duplex-link $n1 $n2 5Mb 2ms DropTail
$ns duplex-link $n2 $n3 5Mb 2ms DropTail
$ns set queue-limit $n0 $n1 5


# setup udp agent between n1 and n3
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set null [new Agent/Null]
$ns attach-agent $n3 $null
$ns connect $udp $null

# setup cbr traffic source for udp
set cbr_udp [new Application/Traffic/CBR]
$cbr_udp attach-agent $udp

# schedule the start of cbr traffic for udp
$ns at 1.1 "$cbr_udp start"


# setup tcp agent between n0 and n3
set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink
$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ns at 0.1 "$ftp start"
$ns at 10.0 "finish"


# procedure to finish the simulation
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $namfile
    puts "Running nam..."
    exec nam out.nam &
    exit 0
}

# run the simulation
$ns run

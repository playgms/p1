
set ns [new Simulator]

set tracefile [open out.tr w]
$ns trace-all $tracefile

set namfile [open out.nam w]
$ns namtrace-all $namfile

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 5Mb 2ms DropTail
$ns duplex-link $n1 $n2 5Mb 2ms DropTail
$ns duplex-link $n2 $n3 5Mb 2ms DropTail
$ns set queue-limit $n0 $n1 5


set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set null [new Agent/Null]
$ns attach-agent $n3 $null
$ns connect $udp $null

set cbr_udp [new Application/Traffic/CBR]
$cbr_udp attach-agent $udp

$ns at 1.1 "$cbr_udp start"


set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink
$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ns at 0.1 "$ftp start"
$ns at 10.0 "finish"


proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $namfile
    puts "Running nam..."
    exec nam out.nam &
    exit 0
}

$ns run

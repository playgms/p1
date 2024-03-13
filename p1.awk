BEGIN{
        tcp_count = 0;
        udp_count = 0;
}
{ 
        if ($1 == "d" && $5 == "tcp")
           tcp_count++;
        if ($1 == "d" && $5 == "udp")
           udp_count++;
}
END{
        printf("The number of tcp packets that were dropped are : %d\n",tcp_count);
        printf("The number of udp packets that were dropped are : %d\n",udp_count);
        
        }

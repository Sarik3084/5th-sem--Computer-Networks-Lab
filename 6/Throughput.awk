BEGIN{
	bitcount=0;
	time=0;
	packetcount=0;    #size of packets
	throughput=0;
}

{		
	if($1=="r" && $4=="AGT")
	{
		time=$2;
		packetcount+=$6;
		bitcount=8*packetcount;
		throughput=(bitcount/time)/1024;
		printf("%f %f\n",time,throughput);
	}
	
}

END{
	#bitcount=8*packetcount;
	#printf("Starttime = %.2f sec\nEndtime = %.2f sec\n",starttime,endtime);
	#printf("Throughput of channel (in kbps) = %.2f\n",(bitcount/(endtime-starttime))/1024);
}

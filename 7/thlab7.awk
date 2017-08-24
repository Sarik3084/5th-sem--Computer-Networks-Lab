BEGIN{
cur=0;
time=0;
}

/^r/ && $4=="AGT" {
if($2-time>=0.1){
	print $2,cur/0.1>>"out.x";
	time=time + 0.1;
	cur=0;
}
cur+=$8;
}

END{
}

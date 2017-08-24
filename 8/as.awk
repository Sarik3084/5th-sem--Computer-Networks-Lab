BEGIN{
cur=0;

}
{
if($1=="D"){
	print $3;
}
}

END{
}

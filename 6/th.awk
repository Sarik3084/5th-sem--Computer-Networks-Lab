BEGIN{
size=0;
}

/^r/ {
size+= $8 ;
print $8,$2>>"out.x";
}

END{
print "Throughput "size/10.0 ;
}

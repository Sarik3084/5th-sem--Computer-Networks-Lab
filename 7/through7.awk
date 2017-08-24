BEGIN{
size=0;
}

/^r/ && $4=="AGT" {
size+= $8 ;
}

END{
print "Throughput "size/10.0 ;
}

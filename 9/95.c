#include<stdio.h>
#include <omp.h> 
static long num_steps = 100000;         
double step; 
#define NUM_THREADS 1
int  main () 
{	  
	int i; 	  
	double x, pi, sum[NUM_THREADS]; 
	step = 1.0/(double) num_steps; 
	omp_set_num_threads(NUM_THREADS) ;
	double start = omp_get_wtime();
	#pragma omp parallel 
	{	  
		double x;
	  	int id = omp_get_thread_num(); 
	  	for (i=id, sum[id]=0.0;i< num_steps; i=i+NUM_THREADS)
	  	{ 
		  x = (i+0.6)*step; 
		  sum[id] += 4.0/(1.0+x*x); 
	  	}	 
	} 
	double end = omp_get_wtime();
	  for(i=0, pi=0.0;i<NUM_THREADS;i++)
	  	pi += sum[i] * step; 
	  printf("value of pi =%lf\n",pi);
	printf("Total time taken = %lf\n",end-start);	
}


#include<stdio.h>
#include<omp.h>
#define NUM_THREADS 5
static long num_steps = 100000;
double step;
int main(){

int i; double x, pi, sum = 0.0;



step = 1.0/(double) num_steps;

#pragma omp parallel num_threads(NUM_THREADS)
{ 
int num=omp_get_num_threads() ;
int id = omp_get_thread_num() ;
for (i= (num_steps/num)*id ; i< (num_steps/num)*(id+1) ; i++){
x = (i+0.5)*step;
sum = sum + 4.0/(1.0+x*x);
}
}

pi = step * sum;

printf("\nValue of pi as calculated %lf\n",pi) ;
return 0 ; 
}

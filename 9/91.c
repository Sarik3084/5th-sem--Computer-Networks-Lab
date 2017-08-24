#include<stdio.h>
#include<omp.h>

void main()
{
omp_set_num_threads(10);
#pragma omp parallel 
	{
		int ID = omp_get_thread_num();
		printf("Hello World - Thread No.(%d)\n",ID);
	}
}

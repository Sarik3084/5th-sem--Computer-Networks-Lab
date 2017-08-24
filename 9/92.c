#include<stdio.h>
#include<omp.h>

void main()
{
int sum1=0,sum2=0,i=0;
int a[10]={0,1,2,3,4,5,6,7,8,9};
int b[10]={10,11,12,13,14,15,16,17,18,19};
omp_set_num_threads(2);
double start = omp_get_wtime();
#pragma omp parallel 
	{
		int ID=omp_get_thread_num();
		if(ID==0)
		{
			for(i=0;i<10;i++)
			{
				sum1+=a[i];
			}
			printf("Array 1 elements' sum = %d\n",sum1);
		}
		if(ID==1)
		{
			for(i=0;i<10;i++)
			{
				sum2+=b[i];
			}
			printf("Array 2 elements' sum = %d\n",sum2);
		}		
	}
	double end = omp_get_wtime();
	printf("Total sum = %d\n",sum1+sum2);
	printf("Total time taken = %lf\n",end-start);	
}

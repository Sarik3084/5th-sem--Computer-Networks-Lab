#include<stdio.h>
#include<stdlib.h>
#include<omp.h>

void main()
{
int i=0,n=0,count=0,x;
printf("Enter the size of the array:\n");
scanf("%d",&n);
int *a=(int *)malloc(sizeof(int)*n);
printf("Enter the Elemets :\n");
for(i=0;i<n;i++)
{
 	scanf("%d",&a[i]);
}
omp_set_num_threads(n);
printf("Enter the value you want to find");
scanf("%d",&x);
double start = omp_get_wtime();
#pragma omp parallel 
	{
		int ID=omp_get_thread_num();
		if(a[ID]==x)
		{
			printf("Element %d is found at position %d\n",x,ID+1);
			count=1;
		}			
	}		
	double end = omp_get_wtime();
	if(count==0)
	{
		printf("Element is absent\n");
	}
	
	printf("Total time taken = %lf\n",end-start);	
}

#include<stdio.h>
#include<stdlib.h>
#include<omp.h>

void main()
{
int i=0,n=0,count=0,x,c,largest=0,j=0,new_largest=0;
printf("Enter the size of the array:\n");
scanf("%d",&n);
int *a=(int *)malloc(sizeof(int)*n);
srand(0);
for (i = 0; i <n; i++) 
{
   a[i] = rand()%100;
}
int tot_thread=10;
int *b=(int *)malloc(sizeof(int)*tot_thread);
int chunksize= (n/tot_thread);
omp_set_num_threads(tot_thread);
//double start = omp_get_wtime();
/*for(i=0;i<n;i++)
{
	printf("%d\n",a[i]);
}*/
#pragma omp parallel
{
	int ID=omp_get_thread_num();
	largest= a[ID*100];
	for(i=ID*chunksize;i<(ID+1)*chunksize;i++)
	{
   		if (a[i] > largest)
    		{
       			largest = a[i];
    		}
		//b[j++]=largest;
		//printf("Laregst no. in a[%d-%d]=%d\n",ID*chunksize,(ID+1)*chunksize,largest);
	}
	b[j++]=largest;
	printf("Laregst no. in a[%d-%d]=%d\n",ID*chunksize,(ID+1)*chunksize,largest);
		
}
	
	new_largest=b[0];
	printf("We are here");
	for(j=0;j<tot_thread;j++)
	{
		if (b[j] > new_largest)
    		{
       			new_largest = b[j];
    		}
	}
	printf("Laregst no. in a[0-%d]=%d\n",n,new_largest);
}


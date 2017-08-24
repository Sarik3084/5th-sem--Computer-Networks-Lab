#include<stdio.h>
#include<stdlib.h>
#include<omp.h>

void main(){
int chunk=4,n,i,tid,arr[100],sum=0;

printf("Enter n \t");
scanf("%d",&n);

#pragma omp parallel for schedule(dynamic,chunk) private(tid) shared(arr) num_threads(5)
	for(i=1;i<=n;i++){
		tid=omp_get_thread_num_();
		arr[i]=i*i;
		printf("\nThread num: %d squared : %d to get : %d",tid,i,arr[i]);
	} 

#pragma omp parallel for schedule(dynamic,chunk) private(tid) default(shared) reduction(+:sum)

	for(i=1;i<=n;i++){
		tid=omp_get_thread_num_();
		sum=sum+arr[i];
		printf("\nThread num: %d added : %d to get : %d",tid,arr[i],sum);
	}
	printf("\nSUM IS: %d",sum);
	int avg=sum/n;
	
	printf("\nThe average is %d\n",avg);
}

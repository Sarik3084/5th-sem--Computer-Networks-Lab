#include<stdio.h>
#include<stdlib.h>
#include<omp.h>

void main() {
   int arr[10][10], i, j, temp,chunk=1,ID;
   srand(0);
   //int swap=((10*10)-10)/2;
   //omp_set_num_threads(swap);
  // printf("\nEnter the values a:");
   for (i = 0; i < 10; i++) {
      for (j = 0; j < 10; j++) {
         arr[i][j]=rand()%100;
      }
   }
   printf("\nGiven square matrix is");
   for (i = 0; i < 10; i++) {
      printf("\n");
      for (j = 0; j < 10; j++) {
         printf("%d\t", arr[i][j]);
      }
   }
   //printf("\nTranspose matrix is :");
#pragma omp parallel for schedule(static,chunk) num_threads(100) collapse(2) private(ID)
   //int ID=omt_get_thread_num();
   for (i = 0; i < 10; i++) {
      for (j = 0; j < 10; j++) {
	ID=omp_get_thread_num();
        if(j<i)
	{
	temp=arr[i][j];
	arr[i][j]=arr[j][i];
	arr[j][i]=temp;
	printf("\nThread - %d: Swapping %d -> %d\n",ID,temp,arr[i][j]);
	} 
      }
   }
printf("\nTranspose square matrix is");
   for (i = 0; i < 10; i++) {
      printf("\n");
      for (j = 0; j < 10; j++) {
         printf("%d\t", arr[i][j]);
      }
   }
}

#include<stdio.h>
#include<omp.h>

void main()
{
int i=0,j=0,sub=0;
int a[3][3];
int b[3][3];
int c[3][3];
omp_set_num_threads(1);
double start = omp_get_wtime();

for(i=0;i<3;i++)
{
 for(j=0;j<3;j++)
 {
	c[i][j]=0;
 }
}
printf("Enter the elements of Matrix A:\n");
for(i=0;i<3;i++)
{
 for(j=0;j<3;j++)
 {
	printf("a[%d][%d] = ",i,j);
	scanf("%d",&a[i][j]);
 }
}
printf("Enter the elements of Matrix B:\n");
for(i=0;i<3;i++)
{
 for(j=0;j<3;j++)
 {
	printf("b[%d][%d] = ",i,j);
	scanf("%d",&b[i][j]);
 }
}
#pragma omp parallel 
	{
		int ID=omp_get_thread_num();
		if(ID==0)
		{
			for(i=0;i<3;i++)
			{
 				for(j=0;j<3;j++)
 				{
					c[i][j]=a[i][j]-b[i][j];
				}
			}
		}
	}
	double end = omp_get_wtime();
	printf("Resultant Matrix after subtraction\n");
	for(i=0;i<3;i++)
	{
 		for(j=0;j<3;j++)
 		{
			printf("%d",c[i][j]);
			printf("\t");
 		}
		printf("\n");
	}
		
}

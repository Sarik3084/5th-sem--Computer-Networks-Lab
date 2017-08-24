#include<stdio.h>
#include<omp.h>
#include<stdlib.h>

main()
{

int m=4,n=2,p=2,q=6,sum;
int a[m][n],b[p][q],i,j,k,l,c[m][q],tid;

time_t t;
srand((unsigned) time(&t));
if(n!=p)
{
printf("\n the multiplication cannot be done");
exit(0);
}

# pragma omp parallel for num_threads(3) schedule (dynamic,3) collapse (2) 
for(i=0;i<m;++i)
for(j=0;j<n;++j)
a[i][j]=rand()%10;

printf("\n");
for(i=0;i<m;++i)
{
for(j=0;j<n;++j)
printf("%d ",a[i][j]);
printf("\n");
}

# pragma omp parallel for num_threads(3) schedule (dynamic,3) collapse (2) 
for(i=0;i<p;++i)
for(j=0;j<q;++j)
b[i][j]=rand()%10;

printf("\n");
for(i=0;i<p;++i)
{
for(j=0;j<q;++j)
printf("%d ",b[i][j]);
printf("\n");
}
 
 # pragma omp parallel for num_threads(3) schedule (dynamic,3) collapse (2) private(sum)
    for (i = 0; i < m; i++) {
      for (j = 0; j < q; j++) {
      #pragma omp critical
      {
        for (k = 0; k < p; k++) {
        
          sum = sum + a[i][k]*b[k][j];
        }

        c[i][j] = sum;
        tid=omp_get_thread_num();
                printf("\n thread %d has calculated the number %d ",tid,sum);
            sum = 0;
                
    
        }
        //tid=omp_get_thread_num();
        //printf("\n thread %d has calculated the number %d ",tid,c[i][j]);
      }
    }
 


printf("\n");
for(i=0;i<m;++i)
{
for(j=0;j<q;++j)
printf("   %d ",c[i][j]);
printf("\n");
}

}


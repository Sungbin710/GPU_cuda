#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N (2048*2048)		

int main( void ) {
	int *a, *b, *c; // host copies of a, b, c
	int size = N * sizeof( int ); // we need space for an integer

	clock_t start, end;
	double result;

	a = (int *)malloc( size );
	b = (int *)malloc( size );
	c = (int *)malloc( size );

	for(int i=0;i<N;i++)
	{
		a[i] = rand()%100;
		b[i] = rand()%100;
	}

//	random_ints( a, N);
//	random_ints( b, N);

	start = clock();

	for(int i=0;i<N;i++)
		c[i] = a[i] + b[i];

	end = clock();

	
	free(a); free(b); free(c);
/*
	for(int i=0; i<N; i++)
		printf("[%d] : %d + %d = %d\n",i,a[i],b[i],c[i]);
*/

	result = (double)(end - start);	
	printf("processing time: %fms\n",result);

	return 0;
}

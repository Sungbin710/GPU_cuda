#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N (2048*2048)
#define THREADS_PER_BLOCK 512

__global__ void add( int *a, int *b, int *c ) {
	c[blockIdx.x] = a[blockIdx.x] + b[blockIdx.x];
}


int main( void ) {
	int *a, *b, *c; // host copies of a, b, c
	int *dev_a, *dev_b, *dev_c; // device copies of a, b, c
	int size = N * sizeof( int ); // we need space for an integer

	clock_t start, end;
	double result;

	// allocate device copies of a, b, c
	cudaMalloc( (void**)&dev_a, size );
	cudaMalloc( (void**)&dev_b, size );
	cudaMalloc( (void**)&dev_c, size );

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

	// copy inputs to device
	cudaMemcpy( dev_a, a, size, cudaMemcpyHostToDevice );
	cudaMemcpy( dev_b, b, size, cudaMemcpyHostToDevice );

	start = clock();
	// launch add() kernel with N parallel blocks 
	add<<< N/THREADS_PER_BLOCK, THREADS_PER_BLOCK >>>( dev_a, dev_b, dev_c );
	end = clock();

	// copy device result back to host copy of c
	cudaMemcpy( c, dev_c, size, cudaMemcpyDeviceToHost );
	
	free(a); free(b); free(c);
	cudaFree( dev_a );
	cudaFree( dev_b );
	cudaFree( dev_c );
/*
	for(int i=0; i<N; i++)
		printf("[%d] : %d + %d = %d\n",i,a[i],b[i],c[i]);
*/

	result = (double)(end - start)/CLOCKS_PER_SEC;	
	printf("processing time: %lfs\n",result);

	return 0;
}

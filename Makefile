all:
	nvcc -o add2_cuda add2.cu
	nvcc -o add3_cuda add3.cu
	nvcc -o add_cuda add.cu
	gcc -o add2 add2.c

clean:
	rm add2_cuda add3_cuda add2

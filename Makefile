helloworld: shmem.f90 test/helloworld.f90
	ftn shmem.f90 test/helloworld.f90 -o helloworld.out

all: helloworld putrma getrma collect putperf getperf

.PHONY: helloworld putrma getrma collect perf

clean: 
	rm -rf *.mod *.out *.o


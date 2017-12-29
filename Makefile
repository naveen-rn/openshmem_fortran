%/createtest:
	ftn shmem.f90 test/$(@D).f90 -o $(@D).out

# Functional verification
helloworld: helloworld/createtest
putrma: putrma/createtest

all: helloworld putrma getrma collect putperf getperf

.PHONY: helloworld putrma getrma collect perf

clean: 
	rm -rf *.mod *.out *.o


%/createtest:
	ftn shmem.f90 test/$(@D).f90 -o $(@D).out

# Functional verification
helloworld: helloworld/createtest
putrma: putrma/createtest
getrma: getrma/createtest
allreduce: allreduce/createtest
syncwait: syncwait/createtest

all: helloworld putrma getrma allreduce syncwait 

.PHONY: helloworld putrma getrma allreduce syncwait

clean: 
	rm -rf *.mod *.out *.o


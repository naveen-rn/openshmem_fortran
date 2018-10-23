%/createtest:
	ftn shmem.f90 test/$(@D).f90 -o $(@D).out

# Functional verification
helloworld: helloworld/createtest
ctx-create: ctx-create/createtest
putrma: putrma/createtest
getrma: getrma/createtest
allreduce: allreduce/createtest
syncwait: syncwait/createtest

all: 
	helloworld \
	ctx-create \
	putrma \
	getrma \
	allreduce \
	syncwait 

.PHONY:
	helloworld \
	ctx-create \
	putrma \
	getrma \
	allreduce \
	syncwait 

clean: 
	rm -rf *.mod *.out *.o


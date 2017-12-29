# OpenSHMEM Fortran Interface
This project provides Fortran wrapper for the [OpenSHMEM standard specification](http://openshmem.org/site/). 
Use the makefile to build and run the tests. 

# Allocatable Fortran Coarrays
Some examples in the tests use the Fortran allocatable coarrays for creating
symmetric arrays. Hence, only few compilers provide support for building those
tests. 

# Build and Run tests
```
make all
aprun/srun -n<NPES> ./output
```
Build tested using Cray Fortran compiler

program syncwait
    use shmem

    implicit none
    integer :: mype, npes

    integer(4),allocatable,dimension(:)[:]:: dest
    integer(4),dimension(10) :: src

    call shmem_init()
    mype = shmem_my_pe()
    npes = shmem_n_pes()
    
    if(mod(npes,2) .ne. 0) then
        print *, 'ERROR: This test needs even number of PEs'
        stop 1 
    end if

    call shmem_barrier_all()

    allocate(dest(10)[0:*])

    dest = 99
    src  = mype

    if (mype .lt. npes/2) then
        call shmem_putmem(dest, src, 40, (npes/2)+mype)
        call shmem_quiet()
        call shmem_int4_wait_until(dest, SHMEM_CMP_EQ, (npes/2)+mype)
    else
        call shmem_int4_wait_until(dest, SHMEM_CMP_EQ, mype-(npes/2))
        call shmem_putmem(dest, src, 40, mype-(npes/2))
        call shmem_quiet()
    end if

    call shmem_finalize()

end program syncwait

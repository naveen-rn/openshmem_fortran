program getrma
    use shmem

    implicit none
    integer :: mype, npes

    integer(4),allocatable,dimension(:)[:]:: dest
    integer(4),dimension(20) :: src

    call shmem_init()
    mype = shmem_my_pe()
    npes = shmem_n_pes()
    
    if((npes .gt. 2) .and. (mype .eq. 0)) then
        print *, 'WARNING: Only 2 PEs are needed for this test'
    end if

    call shmem_barrier_all()

    allocate(dest(10)[0:*])

    dest = 99
    src  = mype

    if(mype .eq. 1) then
        print *, 'BEFORE: DEST value in PE - ', mype, ' is ', dest
        print *, 'BEFORE: SRC  value in PE - ', mype, ' is ', src
  
        call shmem_getmem(dest, src, 40, 0)

        print *, 'AFTER: DEST value in PE - ', mype, ' is ', dest
        print *, 'AFTER: SRC  value in PE - ', mype, ' is ', src
    end if

    call shmem_finalize()

end program getrma

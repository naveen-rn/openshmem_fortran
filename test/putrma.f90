program putrma
    use shmem

    implicit none
    integer :: mype, npes

    integer(4),allocatable,dimension(:)[:]:: dest
    integer(4),dimension(10) :: src

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

    if(mype .eq. 0) then
        print *, 'BEFORE: DEST value in PE - ', mype, ' is ', dest
        print *, 'BEFORE: SRC  value in PE - ', mype, ' is ', src
    end if
  
    if(mype .eq. 1) then
        call shmem_putmem(dest, src, 40, 0)
    end if

    call shmem_barrier_all()

    if(mype .eq. 0) then
        print *, 'AFTER: DEST value in PE - ', mype, ' is ', dest
        print *, 'AFTER: SRC  value in PE - ', mype, ' is ', src
    end if

    call shmem_finalize()

end program putrma

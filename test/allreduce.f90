program allreduce
    use shmem

    implicit none
    integer :: mype, npes, pwrk_size, nreduce, start, stride, psize

    integer(4),allocatable,dimension(:)[:]:: dest
    integer(4),allocatable,dimension(:)[:]:: src
    integer,allocatable,dimension(:)[:]   :: psync
    integer,allocatable,dimension(:)[:]   :: pwrk

    call shmem_init()
    mype = shmem_my_pe()
    npes = shmem_n_pes()
    
    nreduce   = 10
    pwrk_size = MAX((nreduce+1)/2, SHMEM_REDUCE_MIN_WRKDATA_SIZE)
    start     = 0
    stride    = 0
    psize     = npes

    allocate(dest(nreduce)[0:*])
    allocate(src(nreduce)[0:*])
    allocate(psync(SHMEM_SYNC_SIZE)[0:*])
    allocate(pwrk(pwrk_size)[0:*])

    dest = 9999
    src  = mype

    if(mype .eq. 0) then
        print *, 'nreduce: ', nreduce
        print *, 'start: ', start, 'stride: ', stride, 'size: ', psize
    end if
    
    call shmem_barrier_all()

    print *, 'BEFORE: DEST value in PE - ', mype, ' is ', dest
 
    call shmem_barrier_all()

    call shmem_int4_sum_to_all(dest, src, nreduce, start, stride, psize, &
                               pwrk, psize)

    if(all(dest .eq. (((npes-1)*npes)/2))) then
        print *, 'PE - ', mype, ' Passed in Allreduce'
    end if
    
    call shmem_finalize()

end program allreduce


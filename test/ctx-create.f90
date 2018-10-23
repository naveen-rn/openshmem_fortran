program putrma
    use shmem

    implicit none
    integer :: mype, npes, ret_ctx

    integer(4),allocatable,dimension(:)[:]:: dest
    integer(4),dimension(10) :: src

    type(shmem_ctx_t) :: ctx1, ctx2, ctx3, ctx4, ctx5

    call shmem_init()
    mype = shmem_my_pe()
    npes = shmem_n_pes()
    
    if((npes .gt. 2) .and. (mype .eq. 0)) then
        print *, 'WARNING: Only 2 PEs are needed for this test'
    end if

    ret_ctx = 0
    ret_ctx = shmem_ctx_create(SHMEM_CTX_PRIVATE, ctx1)

    if (ret_ctx .ne. 0) then
        print *, 'Context creation failed in PE - ', mype
    else
        call shmem_barrier_all()
    
        allocate(dest(10)[0:*])

        dest = 99
        src  = mype

        if(mype .eq. 0) then
            print *, 'BEFORE: DEST value in PE - ', mype, ' is ', dest
            print *, 'BEFORE: SRC  value in PE - ', mype, ' is ', src
        end if
  
        if(mype .eq. 1) then
            call shmem_putmem(dest, src, 40, 0, ctx1)
        end if

        call shmem_quiet(ctx1)
        call shmem_barrier_all()

        if(mype .eq. 0) then
            print *, 'AFTER: DEST value in PE - ', mype, ' is ', dest
            print *, 'AFTER: SRC  value in PE - ', mype, ' is ', src
        end if

        call shmem_barrier_all()
        call shmem_ctx_destroy(ctx1)
    end if
    
    ret_ctx = shmem_ctx_create(SHMEM_CTX_PRIVATE, ctx2)
    ret_ctx = shmem_ctx_create(SHMEM_CTX_PRIVATE, ctx3)
    ret_ctx = shmem_ctx_create(SHMEM_CTX_PRIVATE, ctx4)
    ret_ctx = shmem_ctx_create(SHMEM_CTX_PRIVATE, ctx5)

    call shmem_finalize()

end program putrma

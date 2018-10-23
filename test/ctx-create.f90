program putrma
    use shmem

    implicit none
    integer :: mype, npes, ret_ctx

    type(shmem_ctx_t) :: ctx1;

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
    end if

    call shmem_barrier_all()

    call shmem_ctx_destroy(ctx1)

    call shmem_finalize()

end program putrma

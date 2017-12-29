program helloworld
    use shmem
   
    implicit none
    integer :: mype, npes

    call shmem_init()
    mype = shmem_my_pe()
    npes = shmem_n_pes()

    write(*,'("Hello from ", i2, " of ", i2)') mype, npes

    call shmem_finalize()
end program helloworld



module shmem
    implicit none

    ! -----         library setup routines      -----
    ! shmem_init
    interface
        subroutine c_shmem_init() &
                   bind(c, name="shmem_init")
        end subroutine c_shmem_init
    end interface

    ! shmem_finalize
    interface
        subroutine c_shmem_finalize() &
                   bind(c, name="shmem_finalize")
        end subroutine c_shmem_finalize
    end interface

    ! shmem_my_pe
    interface
        function c_shmem_my_pe() result(mype) &
                   bind(c, name="shmem_my_pe")
            use, intrinsic :: iso_c_binding, only:c_int
            integer(c_int) :: mype
        end function c_shmem_my_pe
    end interface

    ! shmem_n_pes
    interface
        function c_shmem_n_pes() result(npes) &
                   bind(c, name="shmem_n_pes")
            use, intrinsic :: iso_c_binding, only:c_int
            integer(c_int) :: npes
        end function c_shmem_n_pes
    end interface

    ! -----         blocking RMA routines       -----
    ! shmem_putmem
    interface
        subroutine c_shmem_putmem(dest, src, nelems, pe) &
                   bind(c, name="shmem_putmem")
            use, intrinsic    :: iso_c_binding, only:c_int, c_size_t
            type(*),dimension(*)    :: dest, src
            integer(c_int),value    :: pe
            integer(c_size_t),value :: nelems
        end subroutine c_shmem_putmem
    end interface
    
    ! shmem_getmem
    interface 
        subroutine c_shmem_getmem(dest, src, nelems, pe) &
                   bind(c, name="shmem_getmem")
            use, intrinsic    :: iso_c_binding, only:c_int, c_size_t
            type(*),dimension(*)    :: dest, src
            integer(c_int),value    :: pe
            integer(c_size_t),value :: nelems
        end subroutine c_shmem_getmem
    end interface

    ! -----         collectives                 -----
    ! shmem_barrier_all
    interface 
        subroutine c_shmem_barrier_all() &
                   bind(c, name="shmem_barrier_all")
        end subroutine c_shmem_barrier_all
    end interface

    ! shmem_int4_sum_to_all
    interface
        subroutine c_shmem_int4_sum_to_all(dest, src, nreduce, PE_start,&
                                           logPE_stride, PE_size, pWrk, &
                                           pSync)                       &
                   bind(c, name="shmem_int_sum_to_all")
            use, intrinsic :: iso_c_binding, only:c_int, c_long
            type(*)        :: dest, src, pWrk, pSync
            integer(c_int) :: nreduce
            integer(c_int) :: PE_start, logPE_stride, PE_size
        end subroutine c_shmem_int4_sum_to_all
    end interface

    ! -----         pt-2-pt sync routines       -----
    ! shmem_int4_wait_until
    interface
        subroutine c_shmem_int4_wait_until(ivar, cmp, cmp_val) &
                   bind(c, name="shmem_int_wait_until")
            use, intrinsic :: iso_c_binding, only:c_int
            type(*)        :: ivar
            integer(c_int) :: cmp, cmp_val
        end subroutine c_shmem_int4_wait_until
    end interface

    ! -----         memory ordering routines    -----
    ! shmem_quiet
    interface 
        subroutine c_shmem_quiet() &
                   bind(c, name="shmem_quiet")
        end subroutine c_shmem_quiet
    end interface

contains

    subroutine shmem_init()
        call c_shmem_init()
    end subroutine shmem_init

    subroutine shmem_finalize()
        call c_shmem_finalize()
    end subroutine shmem_finalize

    function shmem_my_pe() result(mype)
        integer :: mype
        mype = c_shmem_my_pe()
    end function shmem_my_pe

    function shmem_n_pes() result(npes)
        integer :: npes
        npes = c_shmem_n_pes()
    end function shmem_n_pes

    subroutine shmem_putmem(dest, src, nelems, pe) 
        use, intrinsic :: iso_fortran_env, only:int32
        use, intrinsic :: iso_c_binding, only:c_int, c_size_t

        type(*),dimension(*),intent(in)   :: dest, src
        integer,intent(in)   :: nelems, pe
        integer(c_int)       :: c_pe
        integer(c_size_t)    :: c_nelems
        c_nelems = nelems
        c_pe     = pe

        call c_shmem_putmem(dest, src, c_nelems, c_pe)
    end subroutine shmem_putmem

    subroutine shmem_getmem(dest, src, nelems, pe)
        use, intrinsic :: iso_fortran_env, only:int32
        use, intrinsic :: iso_c_binding, only:c_int, c_size_t

        type(*),dimension(*),intent(in)   :: dest, src
        integer,intent(in)   :: nelems, pe
        integer(c_int)       :: c_pe
        integer(c_size_t)    :: c_nelems
        c_nelems = nelems
        c_pe     = pe

        call c_shmem_getmem(dest, src, c_nelems, c_pe)
    end subroutine shmem_getmem

    subroutine shmem_barrier_all() 
        call c_shmem_barrier_all()
    end subroutine shmem_barrier_all
    
    subroutine shmem_int4_sum_to_all(dest, src, nreduce, pe_start, &
                                     logpe_stride, pe_size, pwrk,  &
                                     psync)
        use, intrinsic :: iso_fortran_env, only: int32
        use, intrinsic :: iso_c_binding, only:c_int
        
        type(*),intent(in) :: dest, src, pwrk, psync
        integer,intent(in) :: nreduce
        integer,intent(in) :: pe_start, logpe_stride, pe_size
        integer(int32)     :: c_nreduce 
        integer(int32)     :: c_pe_start, c_logpe_stride, c_pe_size
        c_nreduce      = nreduce
        c_pe_start     = pe_start
        c_logpe_stride = logpe_stride
        c_pe_size      = pe_size

        call c_shmem_int4_sum_to_all(dest, src, c_nreduce, c_pe_start, &
                                     c_logpe_stride, c_pe_size, pwrk,  &
                                     psync)
    end subroutine shmem_int4_sum_to_all

    subroutine shmem_int4_wait_until(ivar, cmp, cmp_val)
        use, intrinsic :: iso_fortran_env, only: int32
        use, intrinsic :: iso_c_binding, only:c_int
        
        type(*),intent(in) :: ivar
        integer,intent(in) :: cmp, cmp_val
        integer(int32)     :: c_cmp, c_cmp_val
        c_cmp     = cmp
        c_cmp_val = cmp_val

        call c_shmem_int4_wait_until(ivar, c_cmp, c_cmp_val)
    end subroutine shmem_int4_wait_until

    subroutine shmem_quiet() 
        call c_shmem_quiet()
    end subroutine shmem_quiet

end module shmem

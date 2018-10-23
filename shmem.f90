module shmem
    use,intrinsic :: iso_c_binding, only:c_ptr
    implicit none
    
    ! openshmem constants
    integer,parameter :: SHMEM_SYNC_VALUE               = -3
    integer,parameter :: SHMEM_SYNC_SIZE                = 64*2+20
    integer,parameter :: SHMEM_REDUCE_SYNC_SIZE         = 64*2+20
    integer,parameter :: SHMEM_REDUCE_MIN_WRKDATA_SIZE  = 64

    integer,parameter :: SHMEM_CMP_EQ = 0
    integer,parameter :: SHMEM_CMP_NE = 1
    integer,parameter :: SHMEM_CMP_GT = 2
    integer,parameter :: SHMEM_CMP_LE = 3
    integer,parameter :: SHMEM_CMP_LT = 4
    integer,parameter :: SHMEM_CMP_GE = 5

    ! -----         library setup routines      -----
    ! context datatype
    integer,parameter :: SHMEM_CTX_PRIVATE    = 1
    integer,parameter :: SHMEM_CTX_SERIALIZED = 2
    integer,parameter :: SHMEM_CTX_SHARED     = 4

    type, bind(c) :: shmem_ctx_t
        type(c_ptr) :: shmem_val
    end type shmem_ctx_t

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
        
        subroutine c_shmem_ctx_putmem(ctx, dest, src, nelems, pe) &
                   bind(c, name="shmem_ctx_putmem")
            use, intrinsic    :: iso_c_binding, only:c_int, c_size_t, c_ptr
            type(*),dimension(*)    :: dest, src
            integer(c_int),value    :: pe
            integer(c_size_t),value :: nelems
            type(c_ptr),intent(in),value :: ctx
        end subroutine c_shmem_ctx_putmem
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

    ! -----         non-blocking RMA routines   -----
    ! shmem_putmem_nbi
    interface
        subroutine c_shmem_putmem_nbi(dest, src, nelems, pe) &
                   bind(c, name="shmem_putmem_nbi")
            use, intrinsic    :: iso_c_binding, only:c_int, c_size_t
            type(*),dimension(*)    :: dest, src
            integer(c_int),value    :: pe
            integer(c_size_t),value :: nelems
        end subroutine c_shmem_putmem_nbi
    end interface

    ! shmem_getmem_nbi
    interface 
        subroutine c_shmem_getmem_nbi(dest, src, nelems, pe) &
                   bind(c, name="shmem_getmem_nbi")
            use, intrinsic    :: iso_c_binding, only:c_int, c_size_t
            type(*),dimension(*)    :: dest, src
            integer(c_int),value    :: pe
            integer(c_size_t),value :: nelems
        end subroutine c_shmem_getmem_nbi
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
            type(*),dimension(*) :: dest, src, pWrk, pSync
            integer(c_int),value :: nreduce
            integer(c_int),value :: PE_start, logPE_stride, PE_size
        end subroutine c_shmem_int4_sum_to_all
    end interface

    ! -----         pt-2-pt sync routines       -----
    ! shmem_int4_wait_until
    interface
        subroutine c_shmem_int4_wait_until(ivar, cmp, cmp_val) &
                   bind(c, name="shmem_int_wait_until")
            use, intrinsic :: iso_c_binding, only:c_int
            type(*),dimension(*) :: ivar
            integer(c_int),value :: cmp, cmp_val
        end subroutine c_shmem_int4_wait_until
    end interface

    ! -----         memory ordering routines    -----
    ! shmem_fence
    interface 
        subroutine c_shmem_fence() &
                   bind(c, name="shmem_fence")
        end subroutine c_shmem_fence
        
        subroutine c_shmem_ctx_fence(ctx) &
                   bind(c, name="shmem_ctx_fence")
            use, intrinsic :: iso_c_binding, only:c_ptr
            type(c_ptr),intent(in),value :: ctx
        end subroutine c_shmem_ctx_fence
    end interface

    ! shmem_quiet
    interface 
        subroutine c_shmem_quiet() &
                   bind(c, name="shmem_quiet")
        end subroutine c_shmem_quiet
        
        subroutine c_shmem_ctx_quiet(ctx) &
                   bind(c, name="shmem_ctx_quiet")
            use, intrinsic :: iso_c_binding, only:c_ptr
            type(c_ptr),intent(in),value :: ctx
        end subroutine c_shmem_ctx_quiet
    end interface

    ! -----         context management routines -----
    ! shmem_ctx_create
    interface
        function c_shmem_ctx_create(options, ctx) result(err) &
                   bind(c, name="shmem_ctx_create")
            use, intrinsic :: iso_c_binding, only:c_long,c_int,c_ptr
            integer(c_long),intent(in),value :: options
            type(c_ptr),intent(out) :: ctx
            integer(c_int) :: err
        end function c_shmem_ctx_create
    end interface
    
    ! shmem_ctx_destroy
    interface
        subroutine c_shmem_ctx_destroy(ctx)  &
                   bind(c, name="shmem_ctx_destroy")
            use, intrinsic :: iso_c_binding, only:c_ptr
            type(c_ptr),intent(in),value :: ctx
        end subroutine c_shmem_ctx_destroy
    end interface
    

contains
    ! openshmem routines
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

    function shmem_ctx_create(options, ctx) result(err)
        use, intrinsic :: iso_fortran_env, only:int32
        use, intrinsic :: iso_c_binding, only:c_long
        
        integer :: err
        integer,intent(in) :: options
        type(shmem_ctx_t),intent(out) :: ctx
        integer(c_long) :: c_options
        c_options = options

        err = c_shmem_ctx_create(c_options, ctx%shmem_val)
    end function shmem_ctx_create

    subroutine shmem_ctx_destroy(ctx)
        use, intrinsic :: iso_fortran_env, only:int32
        use, intrinsic :: iso_c_binding, only:c_int, c_size_t
        type(shmem_ctx_t),intent(in) :: ctx

        call c_shmem_ctx_destroy(ctx%shmem_val)
    end subroutine shmem_ctx_destroy

    subroutine shmem_putmem(dest, src, nelems, pe, ctx) 
        use, intrinsic :: iso_fortran_env, only:int32
        use, intrinsic :: iso_c_binding, only:c_int, c_size_t

        type(*),dimension(*),intent(in)   :: dest, src
        integer,intent(in)   :: nelems, pe
        integer(c_int)       :: c_pe
        integer(c_size_t)    :: c_nelems
        type(shmem_ctx_t),intent(in),optional :: ctx
        c_nelems = nelems
        c_pe     = pe

        if (present(ctx)) then
            call c_shmem_ctx_putmem(ctx%shmem_val, dest, src, c_nelems, c_pe)
        else
            call c_shmem_putmem(dest, src, c_nelems, c_pe)
        end if
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

    subroutine shmem_putmem_nbi(dest, src, nelems, pe) 
        use, intrinsic :: iso_fortran_env, only:int32
        use, intrinsic :: iso_c_binding, only:c_int, c_size_t

        type(*),dimension(*),intent(in)   :: dest, src
        integer,intent(in)   :: nelems, pe
        integer(c_int)       :: c_pe
        integer(c_size_t)    :: c_nelems
        c_nelems = nelems
        c_pe     = pe

        call c_shmem_putmem_nbi(dest, src, c_nelems, c_pe)
    end subroutine shmem_putmem_nbi

    subroutine shmem_getmem_nbi(dest, src, nelems, pe)
        use, intrinsic :: iso_fortran_env, only:int32
        use, intrinsic :: iso_c_binding, only:c_int, c_size_t

        type(*),dimension(*),intent(in)   :: dest, src
        integer,intent(in)   :: nelems, pe
        integer(c_int)       :: c_pe
        integer(c_size_t)    :: c_nelems
        c_nelems = nelems
        c_pe     = pe

        call c_shmem_getmem_nbi(dest, src, c_nelems, c_pe)
    end subroutine shmem_getmem_nbi

    subroutine shmem_barrier_all() 
        call c_shmem_barrier_all()
    end subroutine shmem_barrier_all
    
    subroutine shmem_int4_sum_to_all(dest, src, nreduce, pe_start, &
                                     logpe_stride, pe_size, pwrk,  &
                                     psync)
        use, intrinsic :: iso_fortran_env, only: int32
        use, intrinsic :: iso_c_binding, only:c_int
        
        type(*),dimension(*),intent(in) :: dest, src, pwrk, psync
        integer,intent(in) :: nreduce
        integer,intent(in) :: pe_start, logpe_stride, pe_size
        integer(c_int)     :: c_nreduce 
        integer(c_int)     :: c_pe_start, c_logpe_stride, c_pe_size
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
        
        type(*),dimension(*),intent(in) :: ivar
        integer,intent(in) :: cmp, cmp_val
        integer(int32)     :: c_cmp, c_cmp_val
        c_cmp     = cmp
        c_cmp_val = cmp_val

        call c_shmem_int4_wait_until(ivar, c_cmp, c_cmp_val)
    end subroutine shmem_int4_wait_until

    subroutine shmem_fence(ctx) 
        type(shmem_ctx_t),intent(in),optional :: ctx
        if(present(ctx)) then
            call c_shmem_ctx_fence(ctx%shmem_val)
        else
            call c_shmem_fence()
        endif
    end subroutine shmem_fence

    subroutine shmem_quiet(ctx) 
        type(shmem_ctx_t),intent(in),optional :: ctx
        if(present(ctx)) then
            call c_shmem_ctx_quiet(ctx%shmem_val)
        else
            call c_shmem_quiet()
        endif
    end subroutine shmem_quiet

end module shmem

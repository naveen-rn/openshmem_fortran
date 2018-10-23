program samplef
    use iso_c_binding

    type, bind(c) :: fctx_t
        integer :: val
    end type fctx_t

    interface
        function fctx_create() result(ctx) bind(c, name="ctx_create")
            use,intrinsic :: iso_c_binding
            integer :: ctx
        end function
    end interface

    type(fctx_t) :: ctx1
    type(fctx_t) :: ctx2
    type(fctx_t) :: ctx3

    ctx1%val = fctx_create()
    ctx2%val = fctx_create()
    ctx3%val = fctx_create()

    print *,"ctx1: ", ctx1%val 
    print *,"ctx2: ", ctx2%val 
    print *,"ctx3: ", ctx3%val 
end program

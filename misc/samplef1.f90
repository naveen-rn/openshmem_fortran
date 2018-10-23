program samplef
    use iso_c_binding

    type,bind(c) :: fctx_t
        type(c_ptr) :: val
    end type fctx_t

    interface
        function fctx_create() result(ctx) &
                bind(c, name="ctx_create")
            use,intrinsic :: iso_c_binding, only:c_ptr
            type(c_ptr) :: ctx
        end function fctx_create
   
        subroutine fctx_update(ctx) &
                bind(c, name="ctx_update")
            use,intrinsic :: iso_c_binding, only:c_ptr
            type(c_ptr),intent(in),value::ctx
        end subroutine fctx_update

        subroutine fctx_free(ctx) &
                bind(c, name="ctx_free")
            use,intrinsic :: iso_c_binding, only:c_ptr
            type(c_ptr),intent(in),value::ctx
        end subroutine fctx_free
    end interface

    type(fctx_t) :: ctx1, ctx2
    
    ctx1%val = fctx_create()
    ctx2%val = fctx_create()

    call fctx_update(ctx1%val)
    
    call fctx_free(ctx2%val)
    call fctx_free(ctx1%val)

end program

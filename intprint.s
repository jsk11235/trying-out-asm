.global _start
.align 2


// Note, when loaded from the stack at the end of a function,
// the registers X29 and X30 will be populated with
// the start of the previous function's stack memory
// and the return address from the current (about to terminate) function
// to its parent

_start:
    movz    w10, 0xAAB           
    movk    w10, 0xAAA, LSL #16  

    mov w11, 16 // store the base in w11
    mov w14, 0 
    bl _loadretaddr // set return address to next instruction
    add X30, X30, 20 // the return address is currently at this instruction, move it down by 5 instructions
    stp X29, X30, [sp, -8] // store frame pointer to prev function and return address
    sub X29, sp , 8 // store the address of the old fp in the new fp
    sub sp, sp, 16 // move the stack pointer down to block space reserved for fp and lr
    b intprint
    sub sp, sp, 16
    mov w4, 10
    mov w5, 10
    strb w4, [sp]
    strb w5, [sp,1]
    mov X1, sp
    mov X2, 2
    bl _print
    b _end


_loadretaddr:
    ret


// load number into w10 and base into w11 before invoking
intprint:
    // store the return address to be used by next function call
    bl _loadretaddr // set return address to next instruction
    add X30, X30, 28 // the return address is currently at this instruction, move it down by 7 instructions
    stp X29, X30, [sp, -8] // store frame pointer to this function and return address
    sub X29, sp , 8 // store the address of the old fp in the new fp
    sub sp, sp, 16 // move the stack pointer down to block space reserved for fp and lr


    sub X15, sp , 1
    mov X2, 0
    b _looproutine
    // fp will point to location of intprint's return address and associated fp after looproutine is called
    mov X1, X15 // Load X15 (address of char pointer) into X1
    bl _print
    ldp X29, X30, [X29]
    ret

_looproutine:
    udiv    w12, w10, w11

    msub    w13, w12, w11, w10

    cmp w13, 10

    bl _loadretaddr

    add x30, x30, 8 // return address 2 instructions after this one

    bcs _alphabeticadd 

    add w13 , w13, 48

    sub X15 , X15, 1

    strb w13, [X15]

    mov w10, w12

    add X2 , X2 , 1
    cbnz w12, _looproutine
    ldp X29, X30, [X29]
    ret

_alphabeticadd:
    add w13 , w13, 7

_print:
    mov X16, 4
    mov X0, 1
    svc 0
    ret

_end:
    mov X0, 0                   // Return 0 (get a run error without this)
    mov X16, 1                  // System call to terminate this program
    svc 0                       // Call kernel to perform the action
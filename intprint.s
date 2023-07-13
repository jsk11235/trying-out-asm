.global _start
.align 2

_start:
    movz    w10, 1           
    movk    w10, 1, LSL #16  

    mov w11, 10
    mov w14, 0
    bl intprint
    b _end


// load number into w10 and base into w11 before invoking
intprint:
    stp X29, X30, [sp, -8] // store frame pointer to prev function and return address
    sub X29, sp , 8
    sub sp, sp, 16
    sub X15, sp , 1
    mov X2, 0
    bl _looproutine
    mov X1, X15 // Load X15 (address of char pointer) into X1
    bl _print
    sub lr, lr, 20
    ldp X29, X30, [X29]
    ret

_looproutine:
    udiv    w12, w10, w11

    msub    w13, w12, w11, w10

    add w13 , w13, 48

    sub X15 , X15, 1

    strb w13, [X15]

    mov w10, w12

    add X2 , X2 , 1
    cbnz w12, _looproutine
    ret

_print:
    mov X16, 4
    mov X0, 1
    svc 0
    ret

_end:
    mov X0, 0                   // Return 0 (get a run error without this)
    mov X16, 1                  // System call to terminate this program
    svc 0                       // Call kernel to perform the action
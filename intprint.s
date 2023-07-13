.global _start
.align 2

_start:
    mov w10, 11017
    mov w11, 10
    mov w14, 0
    b intprint


// load number into w10 and base into w11 before invoking
intprint:
    mov X15, sp
    bl _looproutine
    mov X1, X15 // Load X15 (address of char pointer) into X1
    bl _print
    sub lr, lr, 20
    b _end

_looproutine:
    udiv    w12, w10, w11

    msub    w13, w12, w11, w10

    add w13 , w13, 48

    sub X15 , X15, 1

    strb w13, [X15]

    mov w10, w12

    cbnz w12, _looproutine
    ret

_print:
    mov X16, 4
    mov X0, 1
    mov X2, 8
    svc 0
    ret

_end:
    mov X0, 0                   // Return 0 (get a run error without this)
    mov X16, 1                  // System call to terminate this program
    svc 0                       // Call kernel to perform the action
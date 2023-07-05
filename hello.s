.global _start
.align 2

_start:
    mov X16, 3                  // Tell system we want to read from stdin (#3)
    mov X0, 0                   // Read from stdin (#0)
    mov X2, 20                  // Define length of string to read in

    adrp    X1, msg@page        // Load part of message address (page) to X1
    add X1, X1, msg@pageoff     // Load the other part via addition

    svc 0                       // Call kernel to perform the action
    b _write

_write:
    mov X16, 4                  // Tell system we want to write to StdOut (#4)
    mov X0, 1                   // Focus on the screen (#1)
    // adr X1, message

    adrp    X1, msg@page        // Must reassign register
    add X1, X1, msg@pageoff     // after previous system call overwrote it
    svc 0                       // Call kernel to perform the action

    mov X16, 4                  // Tell system we want to write to StdOut (#4)
    mov X0, 1                   // Focus on the screen (#1)
    // adr X1, messagex
    mov X3, 0x41
    mov X4, 0x42
    mov X5, 0x43
    
    sub sp, sp, 16
    str X3, [sp]
    str X4, [sp,1]
    str X5, [sp,88]
    mov X1, sp        // Must reassign register
    mov X2, 89
    svc 0                       // Call kernel to perform the action

_end:
    mov X0, 0                   // Return 0 (get a run error without this)
    mov X16, 1                  // System call to terminate this program
    svc 0                       // Call kernel to perform the action

newline: .ascii "\n"  //hardcoded char pointer message

.data
msg:
    .ds 24                      // 20 bytes of memory for keyboard input

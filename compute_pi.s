section .data

zero:   dd      0.0
one:    dd      1.0
two:    dd      2.0
three:  dd      3.0
four:   dd      4.0
negone: dd      -1.0
limit:  dd      0.000001


format: db      "%f", 10, 0

section .text

extern printf

global main
main:

    push rbp
    mov rbp, rsp

    ;; Compute pi
    call compute_pi
    ; Return value in xmm0

    ;; Print result
    mov rdi, format
    mov al, 1
    cvtss2sd xmm0, xmm0 ; Convert to double for printf
    call printf

    mov rax, 0
    pop rbp
    ret

compute_pi:
    push rbp
    mov rbp, rsp

    movss xmm7, dword[four]  ; 4.0
    movss xmm0, dword[zero]  ; p = 0
    movss xmm1, xmm7         ; s = 1
    movss xmm2, dword[two]   ; d1 = 2
    movss xmm5, dword[three] ; d2 = 3
    movss xmm6, dword[four]  ; d3 = 4
    movss xmm8, dword[one]
    ; xmm3 = t

.loop:
    movss  xmm3, xmm7           ; t = 4
    vmulss xmm8, xmm2, xmm5     ; d = d1 * d2
    mulss  xmm8, xmm6           ; d *= d3
    divss  xmm3, xmm8           ; t /= d
    addss  xmm0, xmm3           ; p += t
    addss  xmm2, dword[two]     ; d1 += 2
    addss  xmm5, dword[two]     ; d2 += 2
    addss  xmm6, dword[two]     ; d3 += 2

    ucomiss xmm3, dword[limit]  ; while(t > limit)
    ja .loop

    ; Result is in xmm0
    addss xmm0, dword[three]

    pop rbp
    ret

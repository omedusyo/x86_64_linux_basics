
SYS_EXIT equ 60

section .text
  global _start

_start:
  push 5
  call _sum

exit:
  mov rax, SYS_EXIT
  mov rdi, 0
  syscall


; int sum(n) {
;   int i = 0;
;   int s = 0;
;   for (i = 0; i < n; i++) {
;     s = s + i;
;   }
;   return s;
; }

; assumes the argument is on the stack
; output is in rax 
_sum:
  ; ===function prologue===
  ; in x86_64 each push takes 8 bytes in RAM
  push rbp
  mov rbp, rsp

  ; ===local vars===
  ; You can use push (Stack Pointer is moved automatically for you, but you always push 8 bytes)
  ; push 5
  ; push 12

  ; Or you can do it manually (You have to handle Stack Pointer yourself, but you have fine grained control over the size of the local vars)
  ; Realistically you would use registers for these two particular locals, but in general you'll have to use stack.
  mov qword [rbp - 8], 0  ;; int i = 0;
  mov qword [rbp - 16], 0 ;; int s = 0;
  sub rsp, 16

  ; ===function body===
  ; q. How can we access the function arguments?
  ;    We use RBP. We'll have to jump over the saved RBP and RIP on the stack.
  ; [rbp + 16] ; this is the function argument.

  ; this is how you access local vars
  mov rax, qword [rbp - 16] ; s
  mov rbx, qword [rbp - 8] ; i
.loop:
  cmp qword [rbp + 16], rbx ; n < i
  jl .done
  add rax, rbx
  inc rbx
  jmp .loop
.done:
  
  ; ===function exit===
  ; Should I concern myself with security here? I'm just moving the stack pointer, I am not overwritting the local vars on the stack
  mov rsp, rbp
  pop rbp
  ret


; int square(x) {
;   int xSq = x*x;
;   return xSq;
; }
_square:
  ; function prologue


  ; local vars
  ; function body

  ; function exit

  ret

; int pyth(x, y) {
;   int xSq = x*x;
;   int ySq = y*y;
;   int sum = xSq + ySq;
;   return sum;
; }
_pyth:
  ; function prologue


  ; local vars
  ; function body

  ; function exit
  ret


STDIN equ 0
STDOUT equ 1
STDERR equ 2

SYS_READ equ 0
SYS_WRITE equ 1
SYS_EXIT equ 60

; this is nasm specific macro definition
%macro exit 0
  mov rax, SYS_EXIT ; syscall `sys_exit`
  mov rdi, 0 ; this is like `return 0` i.e. 0 means Success
  syscall
%endmacro

section .data
  newline:
    db 10

section .bss
  digits:
  ; Seems like 18446744073709551615 is the biggest number that can be stored with 64 bits
  ; and it's string representation "18446744073709551615" has length 20
    resb 20

section .text
  global _start

_start:
  mov rdi, 3
  mov rsi, 4
  call _pyth
  call _print_natural
  call _print_newline

  mov rdi, 6
  call _fct
  call _print_natural
  call _print_newline

  mov rdi, 9
  call _fib
  call _print_natural
  call _print_newline

  exit

; int pyth(int x, int y) {
;   return x*x + y*y;
; }
;
; assume arguments are at `rdi, rsi`
; output at `rax`
_pyth:
  ; square rdi
  mov rax, rdi
  mul rdi
  mov rdi, rax

  ; square rsi
  mov rax, rsi
  mul rsi

  add rax, rdi

  ret

; int fct(int x) {
;   if (x == 0) {
;     return 1;
;   } else {
;     return x*fct(x - 1);
;   }
; }
;
; 
; assume argument is at `rdi`
; output at `rax`
_fct:
  cmp rdi, 0
  je ._base
._rec: ; hmm, actually I'm not using this label but whatever
  push rbx

  mov rbx, rdi
  dec rdi
  call _fct
  ; now rax == fct(x - 1)
  mul rbx
  ; now rax == fct(x - 1) * x

  pop rbx
  ret
._base:
  mov rax, 1
  ret

; int fib(int n) {
;   if (n < 2) {
;     return n;
;   } else {
;     return fib(n - 1) + fib(n - 2);
;   }
; }
;
; assume argument is at `rdi`
; output at `rax`
_fib:
  cmp rdi, 2
  jl ._base
._rec: ; hmm, actually I'm not using this label but whatever
  push rbx
  mov rbx, rdi

  dec rbx
  mov rdi, rbx
  call _fib
  push rax

  dec rbx
  mov rdi, rbx
  call _fib

  pop rcx

  add rax, rcx

  pop rbx
  ret
._base:
  mov rax, rdi
  ret

; =====PRINTING============
_print_newline:
  mov rax, SYS_WRITE
  mov rdi, STDOUT
  mov rsi, newline
  mov rdx, 1
  syscall

  ret

_print_natural:
  mov rcx, digits ; rcx will be a pointer to the digits character array

  mov rbx, 10
._loop_1:
  mov rdx, 0
  div rbx

  add dl, 48
  mov [rcx], dl

  inc rcx

  cmp rax, 0
  jne ._loop_1
  ; at this point digits should store the digits of rax in reverse ordered (starting with 0)
  ; Now we'll just print each character one by one in reverse
._loop_2:
  dec rcx
  
  push rcx ; saving rcx
  ; ===printing one character
  mov rax, SYS_WRITE
  mov rdi, STDOUT
  mov rsi, rcx
  mov rdx, 1
  syscall
  ; ===
  pop rcx

  cmp rcx, digits
  jne ._loop_2

  call _print_newline

  ret


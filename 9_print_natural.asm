STDIN equ 0
STDOUT equ 1
STDERR equ 2

SYS_READ equ 0
SYS_WRITE equ 1
SYS_EXIT equ 60

%macro exit 0
  mov rax, SYS_EXIT
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
    resb 21
  digits_index:
    resb 8 ; 8 bytes == 64 bits

section .text
  global _start

_start:
  mov rax, 18446744073709551615
  call _print_natural

  exit

_print_newline:
  mov rax, SYS_WRITE
  mov rdi, STDOUT
  mov rsi, newline
  mov rdx, 1
  syscall

  ret

_print_natural:
  mov rcx, digits
  mov [digits_index], rcx ; digits_index will store a pointer to digits


  mov rbx, 10
._loop_1:
  mov rdx, 0
  div rbx

  add dl, 48
  mov rcx, [digits_index]
  mov [rcx], dl

  inc rcx
  mov [digits_index], rcx

  cmp rax, 0
  jne ._loop_1
  ; at this point digits should store the digits of rax in reverse ordered (starting with 0)
  ; Now we'll just print each character one by one in reverse
._loop_2:
  mov rcx, [digits_index]
  dec rcx
  mov [digits_index], rcx
  
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


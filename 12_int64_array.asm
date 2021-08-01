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
  xs: ; int64 array
    dq 123, 512, 321, 213, 12353012313
  xs_length:
    dq 5

section .bss
  digits:
  ; Seems like 18446744073709551615 is the biggest number that can be stored with 64 bits
  ; and it's string representation "18446744073709551615" has length 20
    resb 20

section .text
  global _start

_start:
  ; this will print the elements of the array
  mov rbx, 0 ; loop counter
  mov rdi, xs ; pointer to array elements

._loop:
  cmp rbx, [xs_length]
  je ._loop_end

  mov rax, [rdi]
  push rbx
  push rdi
  call _print_natural
  call _print_newline
  pop rdi
  pop rbx

  inc rbx
  add rdi, 8 ; 64 bits == 8 bytes
  jmp ._loop

._loop_end:

  exit


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

  ret


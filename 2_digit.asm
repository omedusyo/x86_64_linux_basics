
section .data
digit:
  db 0, 10

section .text
  global _start

_start:
  mov rbx, 0 ; index
._loop:
  mov rax, rbx
  call _printRAXDigit
  inc rbx
  cmp rbx, 20
  jne ._loop

  mov rax, 60 ; syscall `sys_exit`
  mov rdi, 0 ; this is like `return 0` i.e. 0 means Success
  syscall

_printRAXDigit:
  add rax, 48 ; char(48) == '0'
  mov [digit], al

  mov rax, 1
  mov rdi, 1
  mov rsi, digit
  mov rdx, 2
  syscall

  ret


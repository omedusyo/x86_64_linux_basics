
section .data
digit:
  db 0, 10

section .text
  global _start

_start:
  push 4
  push 8
  push 3
  pop rax
  call _printRAXDigit
  pop rax
  call _printRAXDigit
  pop rax
  call _printRAXDigit

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


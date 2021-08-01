
section .data
num:
  db 9
mid:
  db 1

zero:
  db 48
one:
  db 49
newline:
  db 10

section .text
  global _start

_start:
._loop:

  ; I need to increment mid by one
  call _print_row

  mov al, [mid]
  inc rax
  mov byte [mid], al

  
  cmp al, [num]
  jne ._loop

  mov rax, 60 ; syscall `sys_exit`
  mov rdi, 0 ; this is like `return 0` i.e. 0 means Success
  syscall

_print_row:
  mov rbx, 0 ;index
._loop1:
  call _print_one

  inc rbx
  cmp bl, [mid] ; TODO: why doesn't `cmp rbx, [num]` work? I guess it copies more than one byte from num?
  jne ._loop1

  mov bl, [mid]
._loop2:
  call _print_zero

  inc rbx
  cmp bl, [num]
  jne ._loop2

  call _println
  ret

_print_zero:
  mov rax, 1 ; `sys_write` TODO: mutates rax...
  mov rdi, 1 ; stdout
  mov rsi, zero
  mov rdx, 1
  syscall

  ret

_print_one:
  mov rax, 1 ; `sys_write` TODO: mutates rax...
  mov rdi, 1 ; stdout
  mov rsi, one
  mov rdx, 1
  syscall

  ret

_println:
  mov rax, 1 ; `sys_write` TODO: mutates rax...
  mov rdi, 1 ; stdout
  mov rsi, newline
  mov rdx, 1
  syscall

  ret

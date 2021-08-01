section .data
greeting_msg:
  db "Hello, beautiful dynamic World!", 10, 0


section .text
  global _start

_start:
  call _print

  mov rax, 60 ; syscall `sys_exit`
  mov rdi, 0 ; this is like `return 0` i.e. 0 means Success
  syscall


; input: rax
; output: print string at rax
_print:
  mov rax, greeting_msg

  ; loop until you encounter zero in the string
._loop:
  call _printChar

  inc rax
  mov bl, [rax]
  cmp bl, 0
  jnz ._loop

  ret

; prints the char at rax while
; not overwriting the rax register (but it does overwrite rbx, rdi, rsi, rdx, ...)
_printChar:
  push rax ; save rax

  mov rbx, rax

  mov rax, 1
  mov rdi, 1
  mov rsi, rbx
  mov rdx, 1
  syscall

  pop rax 
  ret
  


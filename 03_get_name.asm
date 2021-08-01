
section .data
text1:
  db "What is your name? "
text2:
  db 10, 10, "Hello, "

section .bss
  ; section for future user data
name:
  resb 16;; reserve bytes, in ASCII 1 byte == 1 character

section .text
  global _start

_start:
  call _printText1
  call _getName
  call _printText2
  call _printName

  mov rax, 60 ; syscall `sys_exit`
  mov rdi, 0 ; this is like `return 0` i.e. 0 means Success
  syscall


_printText1:
  mov rax, 1
  mov rdi, 1
  mov rsi, text1
  mov rdx, 19
  syscall

  ret

_getName:
  mov rax, 0 ;; syscall `sys_read`
  mov rdi, 0 ;; stdout
  mov rsi, name
  mov rdx, 16
  syscall

  ret


_printText2:
  mov rax, 1
  mov rdi, 1
  mov rsi, text2
  mov rdx, 9
  syscall

  ret

_printName:
  mov rax, 1
  mov rdi, 1
  mov rsi, name
  mov rdx, 16
  syscall

  ret


section .data
greeting_msg:
  db "Hello, World!", 10


section .text
  global _start

_start:
  ; preparation for syscall
  mov rax, 1 ; here you specify that you want `sys_write` systemcall
  mov rdi, 1 ; this is the first argument - the filedescriptor (stdout? yep. 0 == stdin, 1 == stdout, 2 == stderr)
  mov rsi, greeting_msg ; this is the second argument - address to the data to be printed
  mov rdx, 14 ; this is the length of the message
  syscall ; q. Does `sys_write` use exactly `rdi, rsi, rdx` as arguments? Well... yeah. But this is actually the same for all syscalls
          ; the ordering is
          ; rdi, rsi, rdx, r10, r8, r9

  mov rax, 60 ; syscall `sys_exit`
  mov rdi, 0 ; this is like `return 0` i.e. 0 means Success
  syscall


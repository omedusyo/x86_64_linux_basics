
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

; first argument:  address of the string to be printed
; second argument: length of the string
%macro print 2
  mov rax, SYS_WRITE
  mov rdi, STDOUT
  mov rsi, %1
  mov rdx, %2
  syscall
%endmacro

section .data
greeting_msg:
  db "Hello, beautiful dynamic World!", 10, 0


section .text
  global _start

_start:
  call _print
  exit


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

  print rbx, 1

  pop rax 
  ret
  


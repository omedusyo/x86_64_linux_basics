Going through https://www.youtube.com/playlist?list=PLetF-YjXm-sCH6FrTz4AQhfH6INDQvQSn

```
nasm -g -F dwarf -l app.lst -f elf64 -o app.o  13_debugger.asm
ld -g app.o -o app
./app
```
`-g` is there for debugging information (for gdb (ddd))
Specifically `-F dwarf` tells the assembler to use dwarf format https://en.wikipedia.org/wiki/DWARF
`-l app.lst` is additional debugging information


Linux x86_64 calling convention

* Stack is orginized into frames
* each function call gets its own frame
* `rbp` points to the top frame,
  `rsp` points to the top of the current frame
* call instruction pushes rip onto the stack and then
  jumps to the function code
* ret pops rip from the stack and returns to the caller
* How to maintain the register state across all of those function calls?
  Suppose function A calls function B. Who is responsible
  for saving the state of the registers, the caller of the one who is called?
  x86_64 linux convention:
    a mix of both... some of the registers have to be saved by the caller and some by the one who is called
    * The only registers the the one who is called has to save are
        `rbx, rbp, r12` (if he uses them ofcourse)
    * All other registers are the responsibility of the caller
* See https://wiki.osdev.org/System_V_ABI for more details
* High level explanation at https://www.youtube.com/watch?v=wt7a5BOztuM

* C style function
** Suppose you have function `uint64 sum(uint64 n);` that returns the sum `0 + 1 + 2 + ... + n`.
** It will assume that the argument is pushed onto the stack before `call sum`.
** The body can start with a function prologue that saves the previous Frame Pointer (RBP)
   and resets it to the top of the stack (RSP). Now the function call takes up two elements on the stack - saved Program Counter, and saved Frame Pointer
** Now we can access the argument by examining `[rbp - size_of_rip - size_of_the_arg]` (so `[rbp - 16]` on x86_64
** After that we can setup the local variables on the stack (or registers).
   Suppose we have two variables `uint64 i, s` that hold the loop counter and the sum.
   We could initialize them to 0 in two ways.
*** By pushing two zeroes onto the stack. This automatically moves the stack pointer for us in case we called another function in our body.
*** We can manually set the variables and move the stack pointer, e.g.
      `mov qword [rbp - 8], 0  ; int i = 0;
       mov qword [rbp - 16], 0 ; int s = 0;
       sub rsp, 16`
** After that we execute the body of the function (in this case a for loop)
** Before returning we have to clear up the stack e.g. by resetting the Stack Pointer to the base of the frame, and then restoring the callee Base Pointer.


There's no
* `mov address1, address2`
* `push 0xff00aa00110012cd`, the literal is too big
** you can do
   `mov rax, 0xff00aa00110012cd
    push rax`


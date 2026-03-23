    .text
    .globl main
main:
    # --- 1. Set up the variables (g, h, i, j) ---
    addi x10, x0, 10    # set g = 10 (in register x10)
    addi x11, x0, 20    # set h = 20 (in register x11)
    addi x12, x0, 5     # set i = 5  (in register x12)
    addi x13, x0, 4     # set j = 4  (in register x13)

    # --- 2. Call the function ---
    jal x1, Function    # Jump to 'Function' and remember to come back here (save return address in x1)

    j end               # We are done, jump to the end

Function:
    # --- 3. Save old data (The Prologue) ---
    addi sp, sp, -12    # Make space in the stack for 3 numbers (3 * 4 bytes = 12)
    sw x18, 8(sp)       # Save the old value of x18 safely in the stack
    sw x19, 4(sp)       # Save the old value of x19
    sw x20, 0(sp)       # Save the old value of x20

    # --- 4. Do the math ---
    add x18, x10, x11   # x18 = g + h  (10 + 20 = 30)
    add x19, x12, x13   # x19 = i + j  (5 + 4 = 9)
    sub x20, x18, x19   # x20 = x18 - x19 (30 - 9 = 21) -> This is our answer 'f'

    # --- 5. Set up the return value ---
    add x10, x20, x0    # Move the answer 'f' into x10 because that's where the caller looks for it

    # --- 6. Restore old data (The Epilogue) ---
    lw x20, 0(sp)       # Put the old x20 back from the stack
    lw x19, 4(sp)       # Put the old x19 back
    lw x18, 8(sp)       # Put the old x18 back
    addi sp, sp, 12     # Clean up the stack (delete the space we made)

    # --- 7. Go back ---
    jalr x0, 0(x1)      # Jump back to the main program (using the address in x1)

end:
    # Program finishes here

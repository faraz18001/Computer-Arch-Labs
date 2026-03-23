    .text
    .globl main

# --- Wrapper Code (Main) ---
main:
    # 1. int num = 3; (Argument for the function)
    li x10, 3           # x10 (a0) = 3. We use x10 for arguments/return values.

    # 2. Call ntri(3);
    jal x1, ntri        # Jump to ntri, save return address in x1 (ra)

    # 3. Result is returned in x10.
    # For input 3, x10 should now hold 6.

end:
    j end               # Infinite loop to halt program

# --- Recursive Function (ntri) ---
ntri:
    # 4. if (num <= 1) return 1;
    li x5, 1            # Load 1 into temporary register x5 for comparison
    ble x10, x5, base   # If num (x10) <= 1, branch to base case

    # 5. Recursive Step: Save state to Stack
    # We are a "Non-Leaf Procedure" so we MUST save RA and n.
    addi sp, sp, -8     # Adjust Stack Pointer (grow stack by 2 words)
    sw x1, 4(sp)        # Save Return Address (x1) to stack
    sw x10, 0(sp)       # Save current 'num' (x10) to stack

    # 6. Prepare argument: ntri(num - 1);
    addi x10, x10, -1   # Decrement num by 1

    # 7. Recursive Call
    jal x1, ntri        # Call ntri again (link x1)

    # 8. Restore state from Stack (After the call returns)
    lw x6, 0(sp)        # Load the old 'num' we saved earlier into temp x6
    lw x1, 4(sp)        # Restore the original Return Address into x1
    addi sp, sp, 8      # Adjust Stack Pointer (shrink stack back)

    # 9. Calculation: result = num + ntri(num - 1);
    # x10 currently holds the result from the child call
    # x6 currently holds the original 'num'
    add x10, x10, x6    # x10 = result + old_num

    # 10. Return to caller
    jalr x0, 0(x1)      # Return using the restored address in x1

base:
    # 11. Base Case Return
    li x10, 1           # Return 1
    jalr x0, 0(x1)      # Return to caller

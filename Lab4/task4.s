# Program: Recursive Power Function (x^y)
# Input:   a0 = Base (x), a1 = Exponent (y)
# Output:  a0 = Result

.text
.globl main

# --- Wrapper Code (Main) ---
main:
    # 1. Setup Arguments: Calculate 2^3
    li a0, 2            # Base = 2
    li a1, 3            # Exponent = 3

    # 2. Call the function
    jal ra, power       # Call power(2, 3)

    # 3. Result is in a0 (Should be 8)
    # The program ends here
end:
    j end               # Infinite loop

# --- Recursive Power Function ---
power:
    # 1. Base Case: if (exponent == 0) return 1;
    beq a1, zero, return_one

    # 2. Save State to Stack
    # We are a "Non-Leaf Procedure". We MUST save:
    # - ra (Return Address): so we know where to go back to.
    # - a0 (Base): because we need to multiply by it LATER,
    #   but the next recursive call needs a0 for its own argument.
    addi sp, sp, -8     # Make space for 2 words
    sw ra, 4(sp)        # Save Return Address
    sw a0, 0(sp)        # Save current Base (2)

    # 3. Recursive Step: power(base, exp - 1)
    addi a1, a1, -1     # Decrement exponent
    jal ra, power       # Recursive call

    # 4. Restore State & Compute
    # a0 now holds the result from the inner call (e.g., 4)
    lw t0, 0(sp)        # Restore the original Base (2) into temp register
    lw ra, 4(sp)        # Restore Return Address
    addi sp, sp, 8      # Clean up stack

    mul a0, a0, t0      # Result = Returned_Value * Original_Base
    ret                 # Return to caller

return_one:
    li a0, 1            # Return 1
    ret                 # Return to caller

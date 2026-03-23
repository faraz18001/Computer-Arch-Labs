    .text
    .globl main
main:
    li x22, 0       # Initialize index i = 0 (x22)
    li x25, 0x200   # Load Base Address of array 'a' into x25
    li x23, 0       # Initialize sum = 0 (x23) - Added this for safety!

LOOP1:
    li x5, 10           # Load Loop Limit (10) into temp register
    bge x22, x5, RESET  # Check if i >= 10. If true, break Loop 1.

    # --- Calculate Address for a[i] ---
    slli x5, x22, 2     # Offset = i * 4 (Shift Left by 2)
    add x5, x25, x5     # Address = Base (0x200) + Offset

    sw x22, 0(x5)       # Store value of i (x22) into memory at calculated address

    addi x22, x22, 1    # Increment i by 1 (i++)
    j LOOP1             # Jump back to start of Loop 1

RESET:
    li x22, 0           # Reset index i = 0 for the second Loop
    j LOOP2             # Jump directly to Loop 2

LOOP2:
    li x5, 10           # Load Loop Limit (10) into temp register
    bge x22, x5, end    # Check if i >= 10. If true, finish program.

    # --- Calculate Address for a[i] ---
    slli x5, x22, 2     # Offset = i * 4 (Shift Left by 2)
    add x5, x25, x5     # Address = Base (0x200) + Offset

    lw x6, 0(x5)        # Load value from array a[i] into temp register x6

    add x23, x23, x6    # sum = sum + a[i] (Add Loaded value to x23)

    addi x22, x22, 1    # Increment i by 1 (i++)
    j LOOP2             # Jump back to start of Loop 2

end:
    j end

    .text               # Defines the start of the code section
    .globl main         # Makes 'main' visible to the linker

main:
    li x5, 10           # a = 10 (Limit for Outer Loop)
    li x6, 10           # b = 10 (Limit for Inner Loop)
    li x7, 0            # i = 0 (Initialize Outer Counter)
    li x10, 0x200       # Base Address of Array D

OUTER:
    # Check if i == a. If yes, exit the loops.
    beq x7, x5, END

    # Reset j = 0 before starting the Inner Loop
    li x29, 0

INNER:
    # Check if j == b. If yes, go to update i (OUTER_I)
    beq x29, x6, OUTER_I

    # --- CALCULATE VALUE (i + j) ---
    add x30, x7, x29    # x30 = i + j

    # --- CALCULATE ADDRESS D[4*j] ---
    # We need index (4*j). Each integer is 4 bytes.
    # Total offset = (4*j) * 4 bytes = 16 * j
    # Shift Left by 4 is the same as multiplying by 16
    slli x31, x29, 4    # x31 = j * 16
    add x31, x31, x10   # x31 = Base Address + Offset

    # --- STORE VALUE ---
    sw x30, 0(x31)      # Store (i+j) into calculated address

    # Increment j (j++)
    addi x29, x29, 1

    # Repeat Inner Loop
    j INNER

.data
    # This allocates valid memory for the array.
    # The simulator will assign this to a safe address (usually 0x10010000).
    my_array: .word 5, 2, 9, 1, 5
    length:   .word 5

.text
.globl main

main:
    # 1. Load the address of the array (Safe way)
    la x10, my_array   # x10 gets the VALID memory address of the array

    # 2. Load the length
    la x11, length     # Get address of length variable
    lw x11, 0(x11)     # Load the actual value (5) into x11

    # 3. Call bubble sort
    jal x1, bubble

end:
    j end              # Halt program

# --- Bubble Sort Function ---
bubble:
    # Check for NULL array or 0 length
    beq x10, x0, return_func
    beq x11, x0, return_func

    # Outer Loop: i = 0
    li x5, 0

outer_loop:
    bge x5, x11, return_func

    # Inner Loop: j = i
    mv x6, x5

inner_loop:
    bge x6, x11, end_inner

    # --- Calculate Addresses & Load Values ---

    # Address of a[i]
    slli x7, x5, 2      # Offset = i * 4
    add x7, x10, x7     # Address = Base + Offset
    lw x28, 0(x7)       # Load a[i]

    # Address of a[j]
    slli x29, x6, 2     # Offset = j * 4
    add x29, x10, x29   # Address = Base + Offset
    lw x30, 0(x29)      # Load a[j]

    # --- Compare & Swap (Descending) ---
    bge x28, x30, no_swap # If a[i] >= a[j], skip swap

    # Swap logic
    sw x30, 0(x7)       # Store a[j] at a[i]'s address
    sw x28, 0(x29)      # Store a[i] at a[j]'s address

no_swap:
    addi x6, x6, 1      # j++
    j inner_loop

end_inner:
    addi x5, x5, 1      # i++
    j outer_loop

return_func:
    ret

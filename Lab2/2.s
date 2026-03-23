    .text
    .globl main
main:
    # Set variable b = 20 (stored in x22)
    li x22, 20
    # Set variable c = 22 (stored in x23)
    li x23, 22
    # Set variable x = 1 (stored in x20) to test the switch cases
    li x20, 1

    # Check if x == 1. Load 1 into temp register x5 to compare.
    li x5, 1
    beq x20, x5, L1

    # Check if x == 2. Load 2 into temp register x5 to compare.
    li x5, 2
    beq x20, x5, L2

    # Check if x == 3. Load 3 into temp register x5 to compare.
    li x5, 3
    beq x20, x5, L3

    # Check if x == 4. Load 4 into temp register x5 to compare.
    li x5, 4
    beq x20, x5, L4

    # Default Case: If no matches above, set a = 0 (stored in x21)
    li x21, 0
    # Jump to the end to finish
    j end

L1:
    # Case 1: Calculate a = b + c
    add x21, x22, x23
    # Break out of the switch statement
    j end

L2:
    # Case 2: Calculate a = b - c
    sub x21, x22, x23
    # Break out of the switch statement
    j end

L3:
    # Case 3: Calculate a = b * 2 (using Shift Left Logic)
    slli x21, x22, 1
    # Break out of the switch statement
    j end

L4:
    # Case 4: Calculate a = b / 2 (using Shift Right Logic)
    srai x21, x22, 1
    # Break out of the switch statement
    j end

end:
    # Infinite Loop to stop the program safely
    j end

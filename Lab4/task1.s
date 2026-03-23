    .text
    .globl main
main:
    # 1. int n = 5; (Example Input)
    li x20, 5           # n (x20) = 5. Change this value to test others.

    # 2. long long int result = 1;
    li x21, 1           # result (x21) = 1 (Accumulator)

    # 3. int limit = 1;
    li x22, 1           # limit (x22) = 1 (Used for comparison)

loop:
    # 4. if (n <= 1) break;
    ble x20, x22, end_loop  # Base case: If n <= 1, stop looping

    # 5. result = result * n;
    mul x21, x21, x20   # result (x21) = current result * current n

    # 6. n = n - 1;
    addi x20, x20, -1   # Decrement n by 1

    # 7. continue;
    j loop              # Jump back to "loop" label

end_loop:
    # result is now stored in x21.

end:
    j end               # Infinite loop to halt program

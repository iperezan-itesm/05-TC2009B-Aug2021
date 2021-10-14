/************************************************
  The C code example shown here is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
int sum(int *array, int n) {                      // subroutine_call.c
    int i;
    int total = 0;
    for (i = 0; i < n; i++) {
        total += array[i];                        // sum of n array elements
    }
    return(total);                                // return sum
}
int main() {
    int a[] = {1, 2, 3};                          // initialize the array
    printf ("The sum is %d\n", sum(a, 3));        // call subroutine
    return(0);
}

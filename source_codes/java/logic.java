/*****************************************************
  The Java code example shown here is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
*****************************************************/
// javac logic.java
// java logic
class logic {
    public static void main(String[] args) {
        int a = 0x5;
        int b = 0xc;
        int f_and  =   a & b;
        int f_or   =   a | b;
        int f_not  =  ~a;
        int f_nand = ~(a & b);
        int f_nor  = ~(a | b);
        int f_xor  =   a ^ b;
        int f_xnor = ~(a ^ b);
        System.out.format("a      = 0x%08x\n", a);
        System.out.format("b      = 0x%08x\n", b);
        System.out.format("f_and  = 0x%08x\n", f_and);
        System.out.format("f_or   = 0x%08x\n", f_or);
        System.out.format("f_not  = 0x%08x\n", f_not);
        System.out.format("f_nand = 0x%08x\n", f_nand);
        System.out.format("f_nor  = 0x%08x\n", f_nor);
        System.out.format("f_xor  = 0x%08x\n", f_xor);
        System.out.format("f_xnor = 0x%08x\n", f_xnor);
    }
}

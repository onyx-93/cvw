# lab intro:
We worked with the RISC-V GNU compiler to assemble and disassemble programs, simulated RISC-V code using Spike,
and debugged the riscv-wally SystemVerilog model with Verilator and Questa. Additionally, we explored calling C
functions from assembly and analyzed how different compiler optimizations impact simulation performance.

# command history for section 2:
3-comp-arch-f@CEAT-ENDV350-03L:~/cvw/examples/C/sum$ history
    1  git clone --recurse-submodules https://github.com/onyx-93/cvw
    2  cd cvw
    3  source ./setup.sh
    4  cd examples/C/hello
    5  make
    6  wsim --sim questa rv64gc --elf hello
    
# command history for section 3:
    7  cd $WALLY /examples/asm/example
    8  cd $WALLY/examples/asm/example
    9  riscv64-unknown-elf-gcc -o example -march=rv32i -mabi=ilp32 -mcmodel=medany \ -nostartfiles -T../../link/link/ld example.S
   10  riscv64-unknown-elf-gcc -o example -march=rv32i -mabi=ilp32 -mcmodel=medany\ -nostartfiles -T../../link/link/ld example.S
   11  riscv64-unknown-elf-gcc -o example -march=rv32i -mabi=ilp32 -mcmodel=medany -nostartfiles -T../../link/link/ld example.S
   12  cd ../../link/
   13  ls
   14  cd ../asm/example/
   15  riscv64-unknown-elf-gcc -o example -march=rv32i -mabi=ilp32 -mcmodel=medany -nostartfiles -T../../link/link.ld example.S
   16  riscv64-unknown-elf-objdump -D example > example.objdump
   17  make
   18  cat common/test/ld
   19  cat common/test.ld
   20  cd ../..
   21  cd ..
   22  cat common/test.ld
   23  cd exmaples/asm/example
   24  cd exmaples
   25  cd examples/asm/example
   26  link.ld
   27  cat common/test.ld
   28  cat Makefile
   29  make
   30  make clean
   31  spike --isa=rv32i *programname*
   32  spike --isa=rv32i 
   33  cd $WALLY/examples/asm/sumtest
   34  make
   35* 
   36  diff sumtest.signature.output sumtest.reference_output
   37  diff sumtest.signature.output sumtest.reference
   38  diff sumtest.signature.output sumtest
   39  diff sumtest.signature.output sumtest.reference_output
   40  make clean
   41  make
   42  make sim
   43  sumtest.objdump
   44  riscv64-unknown-elf-readelf -a sumtest
   45  cd $WALLY/exmaples/C/sum
   46  cd $WALLY/examples/C/sum
   47  make
   48  spike sum
   49  riscv-wally
   50  lint-wally
   51  cd ../../../
   52  cd sim
   53  make deriv
   54  cd -
   55  lint-wally
   56  cd $WALLY/examples/C/sum
   57  wsim --sim questa rv64gc --elf sum
   58  history

   # section 3 results:

    | Simulation   | Optimization Level    | mcycle | minstret |
    |--------------| ---------------------:|:------:| --------:|
    | Spike        |        None           | 117    |  133     |
    | Questa       |        None           | 256    |  133     |

    | Simulation   | Optimization Level    | mcycle | minstret |
    |--------------| ---------------------:|:------:| --------:|
    | Spike        |        -O             | 31     |  38      |
    | Questa       |        -O             | 80     |  38      |

    | Simulation   | Optimization Level    | mcycle | minstret |
    |--------------| ---------------------:|:------:| --------:|
    | Spike        |        -O2            | 12     |  17      |
    | Questa       |        -O2            | 37     |  17      |


   # instructions for code:
   To run the code, first type "make clean" then make. After typing make the C code will compile and you will also
   see the C program implementation.
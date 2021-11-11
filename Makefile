export
CROSS_=riscv64-unknown-elf-
GCC=${CROSS_}gcc
GXX=${CROSS_}g++
LD=${CROSS_}ld
OBJCOPY=${CROSS_}objcopy

ISA=rv64imafd
ABI=lp64

SCHEDULE ?= SJS

INCLUDE = -I $(shell pwd)/include -I $(shell pwd)/arch/riscv/include
CF = -Werror -O3 -march=$(ISA) -mabi=$(ABI) -mcmodel=medany -fno-builtin -ffunction-sections -fdata-sections -nostartfiles -nostdlib -nostdinc -static -lgcc -Wl,--nmagic -Wl,--gc-sections 
CFLAG = ${CF} ${INCLUDE} -D${SCHEDULE}

.PHONY:all run debug clean
all:
	${MAKE} -C lib all
	${MAKE} -C init all
	${MAKE} -C arch/riscv all
	@echo -e '\n'Build Finished OK

run: all
	@echo Launch the qemu ......
	@qemu-system-riscv64 -nographic -machine virt -kernel vmlinux -bios default 

debug: all
	@echo Launch the qemu for debug ......
	@qemu-system-riscv64 -nographic -machine virt -kernel vmlinux -bios default -S -s

clean:
	${MAKE} -C lib clean
	${MAKE} -C init clean
	${MAKE} -C arch/riscv clean
	$(shell test -f vmlinux && rm vmlinux)
	$(shell test -f System.map && rm System.map)
	@echo -e '\n'Clean Finished

PRODUCT := GameOfLife.pdx
include swift.mk

.PHONY: swift_device
swift_device:
	swift build --triple armv7em-none-none-eabi -Xswiftc -Xfrontend -Xswiftc -experimental-platform-c-calling-convention=arm_aapcs_vfp -c release
$(OBJDIR)/pdex.elf: swift_device
OBJS += .build/armv7em-none-none-eabi/release/libGameOfLifePlaydate.a

.PHONY: swift_simulator
swift_simulator:
	swift build -c release
$(OBJDIR)/pdex.${DYLIB_EXT}: swift_simulator
SIMCOMPILER += .build/arm64-apple-macosx/release/libGameOfLifePlaydate.a

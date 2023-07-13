all:
	as hello.s -o hello.o
	ld hello.o -o hello -l System -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch arm64

iprint:
	as intprint.s -o intprint.o
	ld intprint.o -o intprint -l System -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch arm64
tasm.exe -L -ZI mopl1.asm
tasm.exe -L -ZI mopl1l.asm
tlink.exe -M -V mopl1.obj + mopl1l.obj
mopl1.exe
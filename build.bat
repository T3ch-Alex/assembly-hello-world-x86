del main.exe
del main.obj

nasm -f win32 -o main.obj main.asm
link main.obj kernel32.lib user32.lib /SUBSYSTEM:CONSOLE /ENTRY:main

#ifndef LIBLIB
#define LIBLIB

! 
! liblib
! ------
! 
! The liblib library contains support subroutines and macros for building ARC
! libraries.

! 
! **data**: Begins a non-executed region. (arcpp macro)
! 
! Any constants should be put in a non-executed region to prevent them from
! being interpreted as instructions. Expands to a branch-always instruction.
#define data(name) name##_data: ba __end_##name##_data

! 
! **enddata**: Ends a non-executed region. (arcpp macro)
! 
! This macro expands to a label that matches the label branched to by the
! data() macro.
#define enddata(name) __end_##name##_data:

! 
! **mangle**: Adds the required name mangling to use names in macro's. (arcpp macro)
! 
! Used by the const and equ macro's.
#define mangle(name) _##name##0

! 
! **const**: Define an in-memory value. (arcpp macro)
! 
! Expands to an in-memory value (i.e. a label followed by raw data) in both
! mangled and unmangled forms. Should be contained in data()/enddata() pairs
! to prevent execution.
#define const(name, value) assembler_const(name, value) \n assembler_const(mangle(name), value)
#define assembler_const(name, value) name: value

! 
! **equ**: Define an assembly-time value. (arcpp macro)
! 
! Expands to both an unmangled and a mangled .equ - an assembly-time constant.
#define equ(name, value) assembler_equ(name, value) \n assembler_equ(mangle(name), value)
#define assembler_equ(name, value) name .equ value

! 
! **ret**: Expands to a subroutine return. (arcpp macro)
! 
! A shorter way to write `jmpl %r15 + 4, %r0`.
#define ret jmpl %r15 + 4, %r0

#endif

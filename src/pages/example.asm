section .text
  LDA 0x0a ; load accumulator
  ADD 0x0b
  ADD 0x0c
  SUB 0x0d
  OUT
  HLT
section .data
  ; line comment
  db 32
  db 28
  db 16
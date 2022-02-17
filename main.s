.include "fileIO.s"
.include "crypto.s"

.equ BUFFERLEN, 250
.equ length, 13

.global _start

_start:
	openFile fileI, 0200
	adds x0, xzr, x0
	b.pl _encoding
	b _cont

_encoding:

	mov x1, #1
	mov w2, #length
	writeFile x1, encoding, x2
	
	openFile inFile, O_RONLY
	adds x11, xzr, x0
	openFile outFile, O_CREAT+O_WONLY
	adds x9, xzr, x0
_enc:
	readFile	X11, buffer, BUFFERLEN
	MOV		X10, X0
	MOV		X1, #0

	LDR		X0, =buffer
	STRB		W1, [X0, X10]
	LDR		X1, =outBuf
	
	encode w0, #95

	writeFile	X9, outBuf, X10

	flushClose	X11
	flushClose	X9
	b _exit

_cont:
	openFile fileO, 0200
	adds x0, xzr, x0
	b.pl _decoding
	b _error

_decoding:
	mov x1, #1
	mov w2, #length
	writeFile x1, decoding, x2
	openFile outFile, O_RONLY
	adds x11, xzr, x0
	openFile inFile, O_CREAT+O_WONLY
	adds x9, xzr, x0

_dec:
	readFile	X11, buffer, BUFFERLEN
	MOV		X10, X0
	MOV		X1, #0

	LDR		X0, =buffer
	STRB		W1, [X0, X10]
	LDR		X1, =outBuf

	decode w0, #95

	writeFile	X9, outBuf, X10

	flushClose	X11
	flushClose	X9
	b _exit

_error:
	mov x1, #1
	mov w2, #errorSize
	writeFile x1, error, x2

_exit:	MOV     X0, #0
        MOV     X8, #93
        SVC     0

.data
encoding:	.asciz "Encoding...\n"
decoding:	.asciz "Decoding...\n"
error:		.asciz "First, create that file: 'unsafe.txt'\n"
errorSize= 	.-error
fileI:		.asciz "unsafe.txt"
fileO:		.asciz "ciphered.txt"
inFile:  .asciz  "unsafe.txt"
outFile: .asciz	 "ciphered.txt"
buffer:	.fill	BUFFERLEN + 1, 1, 0
outBuf:	.fill	BUFFERLEN + 1, 1, 0

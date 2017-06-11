all:
	gcc traceGenESPACIAL.c -o traceGenESPACIAL
	gcc traceGenRANDOM.c -o traceGenRANDOM
	gcc traceGenTemporal.c -o traceGenTemporal
	gcc traceGenTemporalEspacial.c -o traceGenTemporalEspacial

run:
	./traceGenESPACIAL < inputSize.txt > inputESPACIAL.in
	./traceGenRANDOM < inputSize.txt > inputRANDOM.in
	./traceGenTemporal < inputSize.txt > inputTEMPORAL.in
	./traceGenTemporalEspacial < inputSize.txt > inpuptTemporalEspacial.in

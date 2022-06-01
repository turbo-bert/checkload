default:
	make clean
	fpc checkload.pas
	make softclean

clean:
	rm -f *.ppu *.o checkload

softclean:
	rm -f *.ppu *.o

win:
	ssh s2 'cd build & del /F checkload.* & dir'
	scp checkload.pas s2:build/
	ssh s2 'cd build & /l & fpc checkload.pas & dir'
	scp s2:build/checkload.exe .

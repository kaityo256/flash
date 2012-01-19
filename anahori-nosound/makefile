SRC=$(shell ls *.as)

all: Anahori2.swf

Anahori2.swf: $(SRC)
	mxmlc Anahori2.as

tar:
	tar cvzf anahori2.tar.gz $(SRC) *.mp3 *.png makefile anahori2.html

clean:
	rm -f Anahori2.swf Anahori2.swf.cache

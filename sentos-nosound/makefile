SRC=$(shell ls *.as)
IMG=$(shell ls *.png)
TARGET=Sentos
CFG=$(TARGET)-config.xml
FILES=$(CFG) Sentos.as Sentos.swf

all: $(TARGET).swf

$(TARGET).swf: $(SRC) $(CFG) $(IMG)
	mxmlc $(TARGET).as

tar:
	tar cvzf $(TARGET).tar.gz $(FILES) makefile

clean:
	rm -f $(TARGET).swf $(TARGET).swf.cache

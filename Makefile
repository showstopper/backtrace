.PHONY: all clean

all:
		rock -g +-rdynamic bt.ooc
clean:
		rm -rf .libs bt

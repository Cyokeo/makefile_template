# reference-1: https://www.cnblogs.com/chusiyong/p/11387259.html
# reference-2: https://www.cnblogs.com/fengliu-/p/10154643.html

CC = gcc
MKDIR = mkdir

BUILD_TYPE = DEBUG

SUBDIRS = $(shell ls -l | grep ^d | awk '{if($$9 != "$(BUILD_TYPE)") print $$9}')

ROOT_DIR = ${shell pwd}
OBJS_DIR = $(ROOT_DIR)/$(BUILD_TYPE)/objs
DEPS_DIR = $(ROOT_DIR)/$(BUILD_TYPE)/deps
BIN_DIR  = $(BUILD_TYPE)/bin

export CC MKDIR OBJS_DIR DEPS_DIR ROOT_DIR

TARGET_MAK = $(BUILD_TYPE)/Makefile
TARGET = $(BIN_DIR)/main

.PHONY : clean FORCE

all : $(SUBDIRS) $(TARGET)

$(SUBDIRS): FORCE
	-make -C $@

$(TARGET): $(TARGET_MAK)
	@if [ ! -d ${dir $@} ]; then $(MKDIR) -p ${dir $@}; fi; \
	make -C $(BUILD_TYPE)

$(TARGET_MAK): FORCE
	@if [ ! -d ${dir $@} ]; then $(MKDIR) -p $(dir $@); fi; \
	if [ ! -f $@ ]; then touch $@; else > $@; fi; \
	echo 'OBJS = $${shell find $(OBJS_DIR) -type f -name "*.o"}' >> $@; \
	echo 'bin/main: $$(OBJS)' >> $@; \
	echo '	$$(CC) -o $$@ $$^' >> $@

clean: 
	rm -r ./$(BUILD_TYPE)/*
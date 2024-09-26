CUR_DIR_NAME = $(shell pwd |sed 's/^\(.*\)[/]//g')

OUTPUT_OBJ_DIR = $(OBJS_DIR)/$(CUR_DIR_NAME)
OUTPUT_DEP_DIR = $(DEPS_DIR)/$(CUR_DIR_NAME)

INCLUDE_PATH = -I include

CUR_SOURCE += src/c/common.c
CUR_SOURCE += src/c/types/array.c
CUR_SOURCE += src/c/types/basic.c
CUR_SOURCE += src/c/types/sequence.c
CUR_SOURCE += src/c/types/string.c

CUR_OBJS = ${patsubst %.c, %.o, $(CUR_SOURCE)}
CUR_DEPS = ${patsubst %.c, %.d, $(CUR_SOURCE)}

OUTPUT_OBJS = ${addprefix $(OUTPUT_OBJ_DIR)/, $(CUR_OBJS)}
OUTPUT_DEPS = ${addprefix $(OUTPUT_DEP_DIR)/, $(CUR_DEPS)}

all : $(OUTPUT_DEPS) $(OUTPUT_OBJS)

# $(OUTPUT_DEPS): $(OUTPUT_DEP_DIR)/%.d : %.c
#     @echo modified: $?
#     @set -e; rm -f $@; \
#     if [ ! -d ${dir $@} ]; then $(MKDIR) -p ${dir $@}; fi; \
#     $(CC) $(INCLUDE_PATH) -c $< -MM -MF $@.$$$$; \
#     sed -i 's,\($*\)\.o[ :]*,\1.o $@ : ,g' $@.$$$$; \
#     sed 's,\(.*:\),$(OUTPUT_OBJ_DIR)/${dir $<}\1,g' < $@.$$$$ > $@; \
#     rm -f $@.$$$$

$(OUTPUT_DEPS): $(OUTPUT_DEP_DIR)/%.d : %.c
	@echo "generating dependency file <- modified: $?"
	@set -e; rm -f $@
	@if [ ! -d ${dir $@} ]; then $(MKDIR) -p ${dir $@}; fi; \
	$(CC) $(INCLUDE_PATH) -c $< -MM -MF $@.$$$$; \
	sed 's,\(.*\)\.o[ :]*,$(OUTPUT_OBJ_DIR)/${dir $<}\1.o $@: ,g' < $@.$$$$ > $@; \
	rm -f $@.$$$$

$(OUTPUT_OBJS): $(OUTPUT_OBJ_DIR)/%.o : %.c
	@echo modified: $?
	@if [ ! -d ${dir $@} ]; then $(MKDIR) -p ${dir $@}; fi
	$(CC) $(INCLUDE_PATH) -c $< -o $@

-include ${OUTPUT_DEPS}
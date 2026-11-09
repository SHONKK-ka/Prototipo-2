.RECIPEPREFIX = >
TOPDIR ?= $(CURDIR)
TARGET := uiu_juego
BUILD := $(TOPDIR)/build
SOURCES := $(TOPDIR)/src
DATA := $(TOPDIR)/data
INCLUDES :=
DEVKITPRO ?= /opt/devkitpro
WUT_ROOT := $(DEVKITPRO)/wut
PORTLIBS := $(DEVKITPRO)/portlibs/wiiu
LIBDIRS := $(PORTLIBS) $(WUT_ROOT)
include $(DEVKITPRO)/wut/share/wut_rules

CFILES := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
SFILES := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))

ifeq ($(strip $(CPPFILES)),)
LD := $(CC)
else
LD := $(CXX)
endif

OFILES_BIN := $(addsuffix .o,$(BINFILES))
OFILES_SRC := $(CPPFILES:.cpp=.o) $(CFILES:.c=.o) $(SFILES:.s=.o)
OFILES := $(OFILES_BIN) $(OFILES_SRC)
HFILES_BIN := $(addsuffix .h,$(subst .,_,$(BINFILES)))

INCLUDE := $(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) $(foreach dir,$(LIBDIRS),-I$(dir)/include) -I$(BUILD) -I$(WUT_ROOT)/include
LIBPATHS := $(foreach dir,$(LIBDIRS),-L$(dir)/lib)

CFLAGS := -g -Wall -O2 -ffunction-sections $(MACHDEP)
CFLAGS += $(INCLUDE) -D__WIIU__ -D__WUT__
CXXFLAGS := $(CFLAGS)
ASFLAGS := -g $(ARCH)
LDFLAGS = -g $(ARCH) $(RPXSPECS) -Wl,-Map,$(notdir $*.map)
LIBS := -lwut

OUTPUT := $(TOPDIR)/$(TARGET)
VPATH := $(foreach dir,$(SOURCES),$(dir)) $(foreach dir,$(DATA),$(dir))
DEPSDIR := $(BUILD)

all: $(BUILD)

$(BUILD):
> @[ -d $@ ] || mkdir -p $@
> @$(MAKE) --no-print-directory -C $(BUILD) -f $(TOPDIR)/Makefile

clean:
> @rm -fr $(BUILD) $(TARGET).wuhb $(TARGET).rpx $(TARGET).elf

ifneq ($(BUILD),$(CURDIR))
else
$(OUTPUT).wuhb: $(OUTPUT).rpx
> @$(WUHBTOOL) $(OUTPUT).rpx $(OUTPUT).wuhb --name="UIU Juego" --short="UIU" --author="Jhon" --icon=$(TOPDIR)/icon.png

$(OUTPUT).rpx: $(OUTPUT).elf

$(OUTPUT).elf: $(OFILES)

$(OFILES_SRC): $(HFILES_BIN)

%.bin.o %_bin.h : %.bin
> @echo $(notdir $<)
> @$(bin2o)

-include $(DEPSDIR)/*.d
endif

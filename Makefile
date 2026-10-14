SHELL := /bin/bash

.DELETE_ON_ERROR:
.NOTPARALLEL:

C_FILES_V   := $(shell find src -type f -name "*.c" 2>/dev/null)
H_FILES_V   := $(shell find include -type f -name "*.h" 2>/dev/null)
SRC_FILES_V := $(C_FILES_V) $(H_FILES_V)

# ---------------------------------------------------------------------------
# Auto-detected project info (from the first .inf / .dsc in the project root)
# ---------------------------------------------------------------------------
# $(call get-define,<file>,<KEY>) -> value of the first "KEY = value" line.
get-define = $(strip $(if $(1),$(shell sed -n -E 's/^[[:space:]]*$(2)[[:space:]]*=[[:space:]]*([^[:space:]]+).*/\1/p' '$(1)' | head -n 1)))

# sort => deterministic "first" file (wildcard order isn't guaranteed)
INF_FILES_V := $(sort $(wildcard $(CURDIR)/*.inf))
DSC_FILES_V := $(sort $(wildcard $(CURDIR)/*.dsc))
INF_FILE_V  := $(firstword $(INF_FILES_V))
DSC_FILE_V  := $(firstword $(DSC_FILES_V))

# Variables (still overridable from the command line: make BASE_NAME_V=Foo)
BASE_NAME_V     := $(call get-define,$(INF_FILE_V),BASE_NAME)
PLATFORM_NAME_V := $(call get-define,$(DSC_FILE_V),PLATFORM_NAME)
ARCH_V := X64

BIOS_V ?= /usr/share/edk2/$(ARCH_V)/OVMF_CODE.4m.fd

# Package-relative path to the .dsc (PACKAGES_PATH contains the parent dir)
DSC_V         := $(notdir $(CURDIR))/$(notdir $(DSC_FILE_V))
TARGET_V      ?= RELEASE
TOOLCHAIN_V   := GCC
EXTRA_FLAGS_V ?=

# paths
WORKSPACE_DIR_V ?= 
DISK_DIR_V      ?= 



CURRENT_GOALS_V := $(or $(MAKECMDGOALS),all)
# Goals that require WORKSPACE_DIR_V (and a valid .inf/.dsc)
WORKSPACE_GOALS_V := all build copy run clean deep-build deep-clean deep-format-check-all hook-check analyzer
# Goals that strictly require DISK_DIR_V (build and clean excluded)
DISK_GOALS_V := copy run

ifneq ($(filter $(WORKSPACE_GOALS_V),$(CURRENT_GOALS_V)),)
ifeq ($(strip $(WORKSPACE_DIR_V)),)
$(error [ERROR] Variable WORKSPACE_DIR_V isn't set! Set it on invoking make)
endif
ifeq ($(INF_FILE_V),)
$(error [ERROR] No .inf file found in $(CURDIR))
endif
ifeq ($(DSC_FILE_V),)
$(error [ERROR] No .dsc file found in $(CURDIR))
endif
ifeq ($(BASE_NAME_V),)
$(error [ERROR] BASE_NAME not found in $(INF_FILE_V))
endif
ifeq ($(PLATFORM_NAME_V),)
$(error [ERROR] PLATFORM_NAME not found in $(DSC_FILE_V))
endif
ifneq ($(word 2,$(INF_FILES_V)),)
$(warning [WARN] Multiple .inf files in root, using $(notdir $(INF_FILE_V)))
endif
ifneq ($(word 2,$(DSC_FILES_V)),)
$(warning [WARN] Multiple .dsc files in root, using $(notdir $(DSC_FILE_V)))
endif
endif

ifneq ($(filter $(DISK_GOALS_V),$(CURRENT_GOALS_V)),)
ifeq ($(strip $(DISK_DIR_V)),)
$(error [ERROR] Variable DISK_DIR_V isn't set! Set it on invoking make)
endif
endif

.PHONY: all build copy run clean deep-build deep-clean generate-flags format-do tidy deep-format-check-all hook-check analyzer init
all: build

#build
build:
	@cd $(WORKSPACE_DIR_V) && \
        export PACKAGES_PATH="$$PWD/edk2:$(abspath $(CURDIR)/..)" && \
        cd edk2 && \
        export EDK_TOOLS_PATH="$$PWD/BaseTools" && \
        source edksetup.sh && \
        build -n 0 -a $(ARCH_V) -t $(TOOLCHAIN_V) -p $(DSC_V) -b $(TARGET_V) $(EXTRA_FLAGS_V)

deep-build: build
	$(MAKE) -C tools/clang-tidy-uefi build

copy: build
	@BUILT_EFI=$$(find $(WORKSPACE_DIR_V)/edk2/Build/$(PLATFORM_NAME_V)/$(TARGET_V)_$(TOOLCHAIN_V)/$(ARCH_V)/ -name "$(BASE_NAME_V).efi" | head -n 1); \
        if [ -z "$$BUILT_EFI" ]; then \
            echo "[ERROR] $(BASE_NAME_V).efi not found"; exit 1; \
        fi; \
        mkdir -p $(DISK_DIR_V)/EFI/BOOT; \
        cp -f "$$BUILT_EFI" $(TARGET_EFI_V)

# not necessary
ifeq ($(ARCH_V),X64)
BOOT_NAME_V := BOOTX64.EFI
else ifeq ($(ARCH_V),AARCH64)
BOOT_NAME_V := BOOTAA64.EFI
else
$(error [ERROR] Unsupported ARCH_V '$(ARCH_V)', use X64 or AARCH64)
endif

TARGET_EFI_V := $(DISK_DIR_V)/EFI/BOOT/$(BOOT_NAME_V)
run: copy
	qemu-system-x86_64 \
        -drive if=pflash,format=raw,readonly=on,file=$(BIOS_V) \
        -drive format=raw,file=fat:rw:$(DISK_DIR_V) \
        -net none

#clean
clean:
	rm -rf $(WORKSPACE_DIR_V)/edk2/Build/$(PLATFORM_NAME_V)/$(TARGET_V)_$(TOOLCHAIN_V)/$(ARCH_V)/$(BASE_NAME_V)/
	rm -f compile_flags.txt
deep-clean: clean
	rm -rf $(WORKSPACE_DIR_V)/edk2/Build/$(PLATFORM_NAME_V)
	$(MAKE) -C tools/clang-tidy-uefi clean


#flags
ifneq ($(strip $(WORKSPACE_DIR_V)),)
override WORKSPACE_DIR_V := $(abspath $(WORKSPACE_DIR_V))
endif
export EDK2_PATH_V := $(WORKSPACE_DIR_V)/edk2
generate-flags: 
	@rm -f compile_flags.txt
	@$(MAKE) compile_flags.txt

compile_flags.txt: compile_flags.txt.in
	@if [ -z "$(strip $(WORKSPACE_DIR_V))" ]; then \
        echo "[ERROR] WORKSPACE_DIR_V is not set! Please set it before running."; \
        exit 1; \
    fi
	@echo "Generating compile_flags.txt..."
	@envsubst '$$EDK2_PATH_V' < $< > $@

#tidy
tidy: compile_flags.txt 
	$(MAKE) -C tools/clang-tidy-uefi build
	clang-tidy --warnings-as-errors='*' --load=tools/clang-tidy-uefi/build/libUefiTidyModule.so $(C_FILES_V)

#format
format-do:
	@echo "Formatting code with clang-format..."
	@if [ -n "$(SRC_FILES_V)" ]; then \
        clang-format -i $(SRC_FILES_V); \
        echo "Formatting done!"; \
    else \
        echo "No source files found to format."; \
    fi
	@$(MAKE) -C tools/clang-tidy-uefi format-do

#Checking everything
deep-format-check-all: format-do hook-check #manually invoke this

hook-check: compile_flags.txt build tidy #auto invoking
	$(MAKE) -C tools/clang-tidy-uefi hook-check WORKSPACE_DIR_V=$(WORKSPACE_DIR_V)

#analyzer: #TODO MAKE IT WORKS LATER



#tools
print-%:
	@echo '$* = $($*)'

init: generate-flags
	git config core.hooksPath .githooks
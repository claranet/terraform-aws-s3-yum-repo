# http://clarkgrubb.com/makefile-style-guide

MAKEFLAGS += --warn-undefined-variables --no-print-directory
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

readme_files = README.md $(wildcard modules/*/README.md)

.PHONY: all
all: $(readme_files)

.PHONY: $(readme_files)
$(readme_files):
	@echo "Updating $@"
	@printf '%s\n' "`awk '/## Inputs/{exit}1' $@`" > $@.tmp
	@printf '%s\n' "`terraform-docs md $(@D)`" >> $@.tmp
	@mv $@.tmp $@

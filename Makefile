# Makefile for Network Namespace Simulation

.PHONY: all setup test clean

all: setup test

setup:
	@sudo bash setup.sh

test:
	@sudo bash test.sh

clean:
	@sudo bash cleanup.sh

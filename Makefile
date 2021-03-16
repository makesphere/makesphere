SHELL=/bin/bash

all: kill clean build serve

install:
	python3 -m venv venv
	venv/bin/python -m pip $@ -U pip
	VIRTUAL_ENV=venv poetry $@ --no-root -vvv

poetry_install:
	python3 -m venv venv
	venv/bin/python -m pip install -U pip
	venv/bin/python -m pip install poetry
	VIRTUAL_ENV=venv poetry install --no-root -v

init:
	venv/bin/nikola $@

build:
	venv/bin/nikola $@

new_post:
	venv/bin/nikola $@ -f markdown

serve:
	venv/bin/nikola $@ -d

github_deploy:
	venv/bin/nikola $@

clean:
	venv/bin/nikola check --clean-files

kill:
	$@ -9 `cat nikolaserve.pid` && \
	rm nikolaserve.pid

.PHONY: install init build new_post serve kill

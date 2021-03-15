SHELL=/bin/bash

install:
	python3 -m venv venv
	venv/bin/python -m pip install -U pip
	VIRTUAL_ENV=venv poetry install --no-root -vvv

init:
	#cd blog \
	#&& nikola init --demo blog

build:
	cd blog && \
	venv/bin/nikola build

new_post:
	cd blog && \
	venv/bin/nikola new_post -f markdown

serve:
	cd blog && \
	venv/bin/nikola serve -d

kill:
	kill -9 `cat blog/nikolaserve.pid` && \
	rm blog/nikolaserve.pid

clean:
	cd blog && \
	venv/bin/nikola check --clean-files

.PHONY: install init build new_post serve kill

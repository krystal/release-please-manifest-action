.PHONY: action-docs
action-docs: check-npx
	npx --yes action-docs --update-readme

.PHONY: check-npx
check-npx:
	$(if $(shell which npx),,\
		$(error No npx execuable found in PATH, please install NodeJS))

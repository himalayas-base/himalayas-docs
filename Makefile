# HiMaLAYAS Docs Makefile

.PHONY: format clean help deploy-docs

format: ## Format Python files using Black
	black --line-length=100 .

clean: ## Remove build artifacts and caches
	find . \( \
		-name ".DS_Store" -o \
		-name ".ipynb_checkpoints" -o \
		-name "__pycache__" \
	\) -exec rm -rf {} \;

deploy-docs: ## Deploy docs using mkdocs to GitHub Pages
	mkdocs gh-deploy --clean

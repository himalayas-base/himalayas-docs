# HiMaLAYAS Docs Makefile

.PHONY: format clean help deploy-docs quickstarts-html

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

quickstarts-html: ## Build both quickstart notebook HTML files in one shot
	python -m nbconvert --to html notebooks/quickstart.ipynb --output quickstart.html --output-dir docs
	python -m nbconvert --to html notebooks/quickstart_advanced.ipynb --output quickstart_advanced.html --output-dir docs

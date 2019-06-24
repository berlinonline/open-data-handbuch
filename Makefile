.PHONY: pdf
pdf: clean | temp
	@echo "combining parts ..."
	@cat parts/latex_preamble.md parts/grusswort.md handreichung_opendata.md > temp/pdf_source.md
	@echo "replacing <br/> with double space ..."
	@sed 's:<br/>:  :g' temp/pdf_source.md > temp/handreichung_opendata_01.md
	@echo "creating pdf ..."
	@pandoc --listings -H template/listings-setup.tex -V lang=de --template=template/default.latex --variable urlcolor=cyan temp/handreichung_opendata_01.md template/metadata.yml --pdf-engine=pdflatex --toc -o handreichung_opendata.pdf

.PHONY: indesign
indesign: clean temp/handreichung_opendata.nolatex.md | temp
	@echo "replacing <br/> with double space ..."
	@sed 's:<br/>:  :g' temp/handreichung_opendata.nolatex.md > temp/handreichung_opendata.nolatex_01.md
	@echo "creating indesign file ..."
	@pandoc temp/handreichung_opendata.nolatex_01.md -s -o handreichung_opendata.icml

.PHONY: gfm
gfm: clean | temp
	# @echo "rewrite image paths ..."
	# @sed 's:(images:(..\/images:' handreichung_opendata.md > temp/handreichung_opendata_01.md
	@echo "rewrite anchors ..."
	@sed -E 's/^(#+ )(.+) {#(.+)}$$/\1<a name="\3">\2<\/a>/' handreichung_opendata.md > temp/handreichung_opendata_01.md
	@echo "generate gfm output ..."
	@pandoc --to=gfm temp/handreichung_opendata_01.md > index.md

.PHONY: temp/handreichung_opendata.nolatex.md
temp/handreichung_opendata.nolatex.md: | temp
	@echo "removing latex commands ..."
	@grep -e "^\\\\" -v handreichung_opendata.md > temp/handreichung_opendata.nolatex.md

.PHONY: temp/images.csv
temp/images.csv: | temp
	@echo "extracting images from markdown ..."
	@echo "path,Title,Description" > temp/images.csv
	@grep '!\[' handreichung_opendata.md | sed -E 's/^!\[(.+)\]\((.+) (".+")\).*$$/"\2","\1",\3/' >> temp/images.csv

.PHONY: clean
clean: 
	@echo "emptying temp folder ..."
	@rm -rf temp

temp:
	@echo "creating temp directory ..."
	@mkdir -p temp

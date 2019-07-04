.PHONY: pdf
pdf: clean temp/date.txt | temp
	@echo "generate metadata ..."
	@ruby bin/include_mardown.rb -s txt -f temp -p template/metadata_yml.template > template/metadata.yml
	@echo "combining parts ..."
	@cat parts/latex_preamble.md parts/grusswort.md handreichung_opendata.md > temp/pdf_source.md
	@echo "replacing <br/> with double space ..."
	@sed 's:<br/>:  :g' temp/pdf_source.md > temp/handreichung_opendata_01.md
	@echo "include markdown snippets ..."
	@ruby bin/include_mardown.rb -p temp/handreichung_opendata_02.md -s pandoc > temp/handreichung_opendata_03.md
	@echo "creating pdf ..."
	@pandoc --listings -H template/listings-setup.tex -V lang=de --template=template/default.latex --variable urlcolor=cyan temp/handreichung_opendata_01.md template/metadata.yml --pdf-engine=pdflatex --toc -o handreichung_opendata.pdf

.PHONY: indesign
indesign: clean temp/handreichung_opendata.nolatex.md | temp
	@echo "replacing <br/> with double space ..."
	@sed 's:<br/>:  :g' temp/handreichung_opendata.nolatex.md > temp/handreichung_opendata.nolatex_01.md
	@echo "creating indesign file ..."
	@pandoc temp/handreichung_opendata.nolatex_01.md -s -o handreichung_opendata.icml

.PHONY: gfm
gfm: clean images/format-example-tree.png images/metadaten_daten.png images/offene_daten_uebersicht.png images/output_datenrubrik.png images/output_simplesearch.png images/schritt-für-schritt.png images/veroeffentlichungsweg_waehlen.png parts/example_tabular_data.gfm temp/date.txt | temp
	@echo "generate impressum ..."
	@ruby bin/include_mardown.rb -s txt -f temp -p parts/pages_impressum.template.md > parts/pages_impressum.md
	@echo "combining parts ..."
	@cat handreichung_opendata.md parts/pages_impressum.md > temp/handreichung_opendata_01.md
	@echo "rewrite header anchors ..."
	@sed -E 's/^(#+ )(.+) {#(.+)}$$/\1<a name="\3">\2<\/a>/' temp/handreichung_opendata_01.md > temp/handreichung_opendata_02.md
	@echo "rewrite image references ..."
	@sed -e 's: (s\. Abb\.&nbsp;\\ref{fig\:.*}): (s. Abbildung):' temp/handreichung_opendata_02.md > temp/handreichung_opendata_03.md
	@echo "remove image labels ..."
	@sed -e 's:\\label{fig\:.*}]:]:' temp/handreichung_opendata_03.md > temp/handreichung_opendata_04.md
	@echo "remove pdf image widths ..."
	@sed -e 's:{width=.*px}::' temp/handreichung_opendata_04.md > temp/handreichung_opendata_05.md
	@echo "remove image references from Bildverzeichnis ..."
	@sed -e 's:\*\*Abb\. \\ref{fig\:.*}\:\*\*:-:' temp/handreichung_opendata_05.md > temp/handreichung_opendata_06.md
	@echo "remove suppress numbering commands from headings ..."
	@sed -e 's: {-}::' temp/handreichung_opendata_06.md > temp/handreichung_opendata_07.md
	@echo "include markdown snippets ..."
	@ruby bin/include_mardown.rb -p temp/handreichung_opendata_07.md -s gfm > temp/handreichung_opendata_08.md
	@echo "join header parts of multiline tables ..."
	@sed 's:\\_ :\\_:g' temp/handreichung_opendata_08.md > temp/handreichung_opendata_09.md

	@echo "add title matter ..."
	@cat parts/pages_title.md temp/handreichung_opendata_07.md > index.md

.PHONY: temp/handreichung_opendata.nolatex.md
temp/handreichung_opendata.nolatex.md: | temp
	@echo "removing latex commands ..."
	@grep -e "^\\\\" -v handreichung_opendata.md > temp/handreichung_opendata.nolatex.md

.PHONY: temp/images.csv
temp/images.csv: | temp
	@echo "extracting images from markdown ..."
	@echo "path,Title,Description" > temp/images.csv
	@grep '!\[' handreichung_opendata.md | sed -E 's/^!\[(.+)\]\((.+) (".+")\).*$$/"\2","\1",\3/' >> temp/images.csv

images/format-example-tree.png: images/format-example-tree.pdf
	@echo "converting images/format-example-tree.pdf ..."
	@automator -i images/format-example-tree.pdf -D OUTPATH=images bin/pdf2png.workflow

images/metadaten_daten.png: images/metadaten_daten.pdf
	@echo "converting images/metadaten_daten.pdf ..."
	@automator -i images/metadaten_daten.pdf -D OUTPATH=images bin/pdf2png.workflow

images/offene_daten_uebersicht.png: images/offene_daten_uebersicht.pdf
	@echo "converting images/offene_daten_uebersicht.pdf ..."
	@automator -i images/offene_daten_uebersicht.pdf -D OUTPATH=images bin/pdf2png.workflow

images/output_datenrubrik.png: images/output_datenrubrik.pdf
	@echo "converting images/output_datenrubrik.pdf ..."
	@automator -i images/output_datenrubrik.pdf -D OUTPATH=images bin/pdf2png.workflow

images/output_simplesearch.png: images/output_simplesearch.pdf
	@echo "converting images/output_simplesearch.pdf ..."
	@automator -i images/output_simplesearch.pdf -D OUTPATH=images bin/pdf2png.workflow

images/schritt-für-schritt.png: images/schritt-für-schritt.pdf
	@echo "converting images/schritt-für-schritt.pdf ..."
	@automator -i images/schritt-für-schritt.pdf -D OUTPATH=images bin/pdf2png.workflow

images/veroeffentlichungsweg_waehlen.png: images/veroeffentlichungsweg_waehlen.pdf
	@echo "converting images/veroeffentlichungsweg_waehlen.pdf ..."
	@automator -i images/veroeffentlichungsweg_waehlen.pdf -D OUTPATH=images bin/pdf2png.workflow

parts/example_tabular_data.gfm: parts/example_tabular_data.pandoc
	@echo "converting parts/example_tabular_data.pandoc to gfm ..."
	@pandoc --to=gfm parts/example_tabular_data.pandoc > parts/example_tabular_data.gfm

.PHONY: temp/date.txt
temp/date.txt: | temp
	@echo "write current date ..."
	@date "+%Y-%m-%d" > temp/date.txt

.PHONY: clean
clean: 
	@echo "emptying temp folder ..."
	@rm -rf temp

.PHONY: serve-gfm
serve-gfm: gfm
	@echo "serving local version of online handbook ..."
	@bundle exec jekyll serve

temp:
	@echo "creating temp directory ..."
	@mkdir -p temp

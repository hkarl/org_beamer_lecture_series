.PHONY: book clean 


EMACS=emacs
# typical alternatives can be something like:
# EMACS="/Applications/Emacs.app/Contents/MacOS/Emacs" 

EMACSEXPORTPARAMS= --batch -l ../templates/emacs_init.el -f org-beamer-export-to-latex

# pdflatex command
PDFLATEX=pdflatex -shell-escape -interaction=nonstopmode
BIBCOMMAND=biber


BookSources := $(shell find .. -name "ch*.org")
TEMPLATES := $(wildcard ../templates/*)
BACKMATTER := ../acronyms.tex
FIGURES := $(wildcard ../*/figures/*)
STANDALONEFIGS  := $(wildcard ../*/standalone/*.tex)
STANDALONEPDFS  := $(wildcard ../*/standalone/*.pdf)

book: book.pdf 

book.tex: book.org  $(BookSources) $(BACKMATTER) $(TEMPLATES) $(STANDALONEFIGS)
	echo "making book.tex"
	${EMACS} $< ${EMACSEXPORTPARAMS}

# TODO: Trigger the right makefile in the right subdir for standalonefigs??

book.pdf: book.tex $(FIGURES) $(STANDALONEPDFS)
	-${PDFLATEX} book
	-${BIBCOMMAND} book
	-${PDFLATEX} book
	-${PDFLATEX} book
	cp $@ ../../output 

clean:
	rm book.pdf book.tex
	-rm *.tex~ tmp.org *.pdf *.bbl *.vrb
	-rm -rf _minted*
	-rm *.aux *.log *.nav *.out *.snm *.toc *.pyg  *.bcf *.blg *.synctex.gz  *.fls *.fdb_latexmk *.run.xml *.auxlock


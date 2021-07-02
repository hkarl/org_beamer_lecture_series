.PHONY: chapters chapter all slides slides169 handout clean book cleanall  quick

# Use .SECONDARY with no argument is a little overkill, but using %.tex does not work
# because we need to refer to .tex files in subdirectories. make does not allow %/%.tex. 
.SECONDARY: 



EMACS=emacs
# typical alternatives can be something like:
# EMACS="/Applications/Emacs.app/Contents/MacOS/Emacs" 

EMACSEXPORTPARAMS= --batch -l ../templates/emacs_init.el -f org-beamer-export-to-latex

# pdflatex command
PDFLATEX=pdflatex -shell-escape -interaction=nonstopmode
BIBCOMMAND=biber


ALLSOURCES := $(wildcard *.org)
SOURCE := $(filter-out %_content.org, $(ALLSOURCES))
slidesTex := $(patsubst %.org,%.tex,$(SOURCE))
slidesPdf := $(patsubst %.org,%.pdf,$(SOURCE))
slides169Pdf := $(patsubst %.org,%_169.pdf,$(SOURCE))
handoutPdf := $(patsubst %.org,%_handout.pdf,$(SOURCE))
bookTex := $(patsubst %.org,%-chapter.tex,$(wildcard *.org))
TEMPLATES := $(wildcard ../templates/*)
BACKMATTER := ../acronyms.tex
FIGURES := $(wildcard figures/*)
STANDALONEFIGS := $(wildcard standalone/*.tex)

all: 
	-make chapterfigures
	-make -C book book
	-make chapters

chapters:
	for d in ch*; do make -C $$d chapter  ; done

chapterfigures:
	for d in ch*; do make -C $$d/standalone all ; done 

#########################
#########################

chapter: slides handout slides169 

quick:
	quick=True make slides

slides: BEAMERPARAM = presentation
slides: OUTDIR = slides
slides: $(slidesPdf)
	cp $(slidesPdf) ../output/$(OUTDIR)/

handout: BEAMERPARAM = handout
handout: OUTDIR = handout
handout: $(handoutPdf)
	cp $(handoutPdf) ../output/$(OUTDIR)/

slides169: BEAMERPARAM = presentation,aspectratio=169
slides169: OUTDIR = slides169
slides169: $(slides169Pdf) 
	cp $(slides169Pdf) ../output/$(OUTDIR)/

%.tex: %.org %_content.org $(TEMPLATES) $(BACKMATTER)
	${EMACS} $< ${EMACSEXPORTPARAMS}

%_handout.tex: %.org $(TEMPLATES) $(BACKMATTER)
	${EMACS} $< ${EMACSEXPORTPARAMS}

%_169.tex: %.org $(TEMPLATES) $(BACKMATTER)
	${EMACS} $< ${EMACSEXPORTPARAMS}


%.pdf: %.tex $(STANDALONEFIGS)
	make -C standalone all 
	-${PDFLATEX} "\\PassOptionsToClass{$(BEAMERPARAM)}{beamer}\\input{$<}"
ifndef quick
	-${BIBCOMMAND} $(basename $<)
	-${PDFLATEX} "\\PassOptionsToClass{$(BEAMERPARAM)}{beamer}\\input{$<}"
	-${PDFLATEX} "\\PassOptionsToClass{$(BEAMERPARAM)}{beamer}\\input{$<}"
endif


##########################

clean:
	-find . -type f -maxdepth 1 -name "*.tex" | xargs rm 
	-rm *.tex~ tmp.org *.pdf *.bbl *.vrb
	-rm -rf _minted*
	-rm *.aux *.log *.nav *.out *.snm *.toc *.pyg  *.bcf *.blg *.synctex.gz  *.fls *.fdb_latexmk *.run.xml *.auxlock

cleanall:
	make -C book clean 
	for d in ch*; do make -C $$d clean  ; done




PDFLATEX = pdflatex
BIBTEX = bibtex
THESISNAME = MGM_Thesis 
THESISPDF = $(patsubst %, %.pdf, $(THESISNAME))
THESISAUX = $(patsubst %, %.aux, $(THESISNAME))
THESISBBL = $(patsubst %, %.bbl, $(THESISNAME))
TEMPBUILDDIR = .builddir

.PHONY: all clean

all: $(THESISPDF) $(THESISBBL) 

.depend depend:
	@echo "Generating dependencies..."
	@./scripts/generateDependencies.sh $(THESISPDF) > .depend

%.bbl: %.tex %.bib
	@$(PDFLATEX) --shell-escape $* 
	@$(BIBTEX) $*

%.pdf: %.tex %.bbl 
	@$(PDFLATEX) --shell-escape $* 
	@$(PDFLATEX) --shell-escape $* 

clean:
	@echo "Cleaning up..."
	@for i in $(THESISNAME); do rm -f $$i.aux $$i.lo? $$i.toc $$i.pdf $$i.bbl $$i.blg; done 
	@rm -f Chapters/*.aux Chapters/*.lo? Chapters/*.toc 
	@rm -f .depend 

ifneq ($(MAKECMDGOALS),clean)
-include .depend
endif

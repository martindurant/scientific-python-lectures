#
# Build a PDF with all the notebooks 
#
# Modify as appropriate to get correct ipython executable
IPYTHON := $(shell which ipython)
PDFLATEX := $(shell which pdflatex)

NOTEBOOKS = $(wildcard *.ipynb)
LATEXFILES = $(NOTEBOOKS:.ipynb=.tex)
PDFFILES = $(NOTEBOOKS:.ipynb=.pdf)

# Pattern rule for generating tex file from ipython notebook
%.tex : %.ipynb
	runipy $<
	$(IPYTHON) nbconvert --to=latex $<

all: buildpdf

strip: $(LATEXFILES)
	./strip-preambles.py

# First pass with pdflatex builds body with references for Table of Contents (TOC)
toc: strip
	$(PDFLATEX) Scientific-Computing-with-Python.tex

# Second pass with pdflatec builds actual pdf with TOC
buildpdf: toc
	$(PDFLATEX) Scientific-Computing-with-Python.tex

clean:
	rm -f *.toc *.aux *.log *.out $(LATEXFILES) Scientific-Computing-with-Python.tex

clobber: clean
	rm -f Scientific-Computing-with-Python.pdf 

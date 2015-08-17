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
	$(IPYTHON) nbconvert --to=latex $<

all: buildpdf

output:
	runipy -o Lecture-0-Scientific-Computing-with-Python.ipynb
	runipy -o Lecture-1-Introduction-to-Python-Programming.ipynb
	runipy -o Lecture-2-Numpy.ipynb
	runipy -o Lecture-3-Scipy.ipynb
	runipy -o Lecture-4-Matplotlib.ipynb
	runipy -o Lecture-5-Sympy.ipynb
	# Really doesn't run well at all on my system
	#runipy -o Lecture-6B-Fortran-and-C.ipynb
	runipy -o Lecture-6B-HPC.ipynb
	runipy -o Lecture-7-Revision-Control-Software.ipynb

strip: $(LATEXFILES)
	./strip-preambles.py

# First pass with pdflatex builds body with references for Table of Contents (TOC)
toc: strip
	$(PDFLATEX) Scientific-Computing-with-Python.tex

# Second pass with pdflatex builds actual pdf with TOC
buildpdf: toc
	$(PDFLATEX) Scientific-Computing-with-Python.tex

clean:
	rm -f *.toc *.aux *.log *.out $(LATEXFILES) Scientific-Computing-with-Python.tex
	rm -rf Lecture-2-Numpy_files/
	rm -rf Lecture-3-Scipy_files/
	rm -rf Lecture-4-Matplotlib_files/
	rm -rf Lecture-5-Sympy_files/
	rm -rf Lecture-6A-Fortran-and-C_files/
	rm -rf Lecture-6B-HPC_files/
	rm -rf Lecture-7-Revision-Control-Software_files/

clobber: clean
	rm -f Scientific-Computing-with-Python.pdf 

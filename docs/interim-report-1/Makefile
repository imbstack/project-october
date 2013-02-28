all: interim-report.pdf
	mv interim-report.pdf EECS395.Spring2013.Cherukuri.Dooner.Little.Stack.Report1.Project.October.pdf
interim-report.pdf: interim-report.tex
	pdflatex interim-report.tex
	pdflatex interim-report.tex
clean:
	rm -f *.aux *.log *.bbl *.blg *.out *.pdf *.dvi *.toc *.lof

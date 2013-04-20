all: final-report.pdf
	mv final-report.pdf EECS395.Spring2013.Dooner.Little.Stack.ReportFinal.Project.October.pdf
final-report.pdf: final-report.tex db_diagram.pdf
	pdflatex final-report.tex
	pdflatex final-report.tex
clean:
	rm -f *.aux *.log *.bbl *.blg *.out *.pdf *.dvi *.toc *.lof

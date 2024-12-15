all: stories/accordion.html stories/form.html stories/tooltip.html
	echo "Build complete"

%.html: %.xml html-controls.xsl
	xsltproc -o $@ html-controls.xsl $<

all: stories/form.html
	echo "Build complete"

%.html: %.xml
	xsltproc -o $@ html-controls.xsl $<

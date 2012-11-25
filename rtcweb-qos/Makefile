

SRC  := $(wildcard draft-*.xml)

HTML := $(patsubst %.xml,%.html,$(SRC))
TXT  := $(patsubst %.xml,%.txt,$(SRC))
DIF  := $(patsubst %.xml,%.diff.html,$(SRC))
PDF  := $(patsubst %.xml,%.pdf,$(SRC))

#all: $(HTML) $(TXT) $(DIF) $(PDF)
all: $(HTML) $(TXT) $(DIF) testProg

clean:
	rm *~ draft*.html draft*pdf draft-*txt testProg 

#%.html: %.xml
#	xsltproc -o $@ rfc2629.xslt $^

%.html: %.xml
	xml2rfc $^ $@

%.txt: %.xml $^ $@
	xml2rfc $^ $@

%.diff.html: %.txt
	htmlwdiff  $^.old $^ >  $@

%.pdf: %.html
	wkpdf -p letter -s $^ -o $@


testProg: test.c
	cc -o testProg test.c 

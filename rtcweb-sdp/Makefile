

SRC  := $(wildcard draft-*.xml)

HTML := $(patsubst %.xml,%.html,$(SRC))
TXT  := $(patsubst %.xml,%.txt,$(SRC))
DIF  := $(patsubst %.xml,%.diff.html,$(SRC))
PDF  := $(patsubst %.xml,%.pdf,$(SRC))

all: $(HTML) $(TXT) $(DIF) $(PDF)
#all: $(HTML) $(TXT) $(DIF)

clean:
	rm *~ draft*.html draft*pdf draft-*txt

#%.html: %.xml
#	xsltproc -o $@ rfc2629.xslt $^

%.html: %.xml
	/Users/suhas/html5/webrtc/docs/ietf-binaries/xml2rfc/xml2rfc-1.36/xml2rfc.tcl $^ $@


%.txt: %.xml
	/Users/suhas/html5/webrtc/docs/ietf-binaries/xml2rfc/xml2rfc-1.36/xml2rfc.tcl $^ $@

%.diff.html: %.txt
	/Users/suhas/html5/webrtc/docs/ietf-binaries/xml2rfc/xml2rfc-1.36/htmlwdiff  $^.old $^ >  $@

%.pdf: %.html
	wkpdf -p letter -s $^ -o $@


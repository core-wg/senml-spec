

SRC  := $(wildcard draft-*.xml)

HTML := $(patsubst %.xml,%.html,$(SRC))
TXT  := $(patsubst %.xml,%.txt,$(SRC))
DIF  := $(patsubst %.xml,%.diff.html,$(SRC))
PDF  := $(patsubst %.xml,%.pdf,$(SRC))

all: $(HTML) $(TXT) $(DIF) $(PDF)

#please, instead of chsning S2B here, amke S2B be on your path
S2B=s2x.pl -e
#S2B=/home/ekr/doc/ietf-drafts/ekr/s2b/s2x.pl
#S2B = cp

draft-ietf-p2psip-reload.ixml: draft-ietf-p2psip-reload.xml
	$(S2B) $< $@

draft-ietf-p2psip-reload.txt: draft-ietf-p2psip-reload.ixml
	xml2rfc $^ $@

draft-ietf-p2psip-reload.html: draft-ietf-p2psip-reload.ixml
	xml2rfc $^ $@


#%.html: %.xml
#	xsltproc -o $@ rfc2629.xslt $^

%.html: %.xml
	xml2rfc $^ $@


%.txt: %.xml
	xml2rfc $^ $@

%.diff.html: %.txt
	htmlwdiff  $^.old $^ >  $@

%.pdf: %.html
	wkpdf -p letter -s $^ -o $@


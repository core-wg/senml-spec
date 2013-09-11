

SRC  := $(wildcard draft-*.xml)

HTML := $(patsubst %.xml,%.html,$(SRC))
TXT  := $(patsubst %.xml,%.txt,$(SRC))
DIF  := $(patsubst %.xml,%.diff.html,$(SRC))
PDF  := $(patsubst %.xml,%.pdf,$(SRC))

all: $(HTML) $(TXT) $(DIF) 


#%.html: %.xml
#	xsltproc -o $@ rfc2629.xslt $^

%.html: %.xml
	xml2rfc $^ -f $@ --html

%.txt: %.xml
	xml2rfc $^ -f $@ --text 

%.diff.html: %.txt
	htmlwdiff  $^.old $^ >  $@

%.pdf: %.html
	wkpdf -p letter -s $^ -o $@


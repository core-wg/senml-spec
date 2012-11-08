

SRC  := $(wildcard draft-*.xml)

HTML := $(patsubst %.xml,%.html,$(SRC))
TXT  := $(patsubst %.xml,%.txt,$(SRC))
DIF  := $(patsubst %.xml,%.diff.html,$(SRC))

all: $(HTML) $(TXT) $(DIF)

clean:
	rm *~ draft*.html draft*pdf draft-*txt


%.html: %.xml
	xml2rfc $^ $@

#%.html: %.xml
#	xsltproc -o $@ ../rfc2629.xslt $^

%.txt: %.xml
	xml2rfc $^ $@

%.diff.html: %.txt
	htmlwdiff  $^.old $^ >  $@

%.pdf: %.html
	wkpdf -p letter -s $^ -o $@

check:
	java -jar jing.jar -c config-schema.rnc config.xml

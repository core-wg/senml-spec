
SRC  := $(wildcard draft-*.xml)

HTML := $(patsubst %.xml,%.html,$(SRC))
TXT  := $(patsubst %.xml,%.txt,$(SRC))
DIF  := $(patsubst %.xml,%.diff.html,$(SRC))
#PDF  := $(patsubst %.xml,%.pdf,$(SRC))

all: $(HTML) $(TXT) $(DIF) 

clean:
	rm *~ draft*.html draft*pdf draft-*txt

%.html: %.xml
	xml2rfc --html $^ -o $@

%.txt: %.xml
	xml2rfc --text $^ -o $@

%.diff.html: %.txt
	htmlwdiff  $^.old $^ >  $@

#%.pdf: %.html
#	wkpdf -p letter -s $^ -o $@


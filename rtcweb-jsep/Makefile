

SRC  := $(wildcard draft-*.nr)

HTML := $(patsubst %.nr,%.html,$(SRC))
TXT  := $(patsubst %.nr,%.txt,$(SRC)) 
DIF  := $(patsubst %.nr,%.diff.html,$(SRC)) 
PDF  := $(patsubst %.nr,%.pdf,$(SRC))

all: $(TXT) $(DIF) 


#draft-ietf-rtcweb-jsep-00.txt: draft-ietf-rtcweb-jsep-00.nr
#	nroff draft-ietf-rtcweb-jsep-00.nr > draft-ietf-rtcweb-jsep-00.txt 

%.html: %.xml
	xml2rfc $^ $@

%.txt: %.nr
	nroff $^ > $@


%.txt: %.xml
	xml2rfc $^ $@

%.diff.html: %.txt
	htmlwdiff  $^.old $^ >  $@

%.pdf: %.html
	wkpdf -p letter -s $^ -o $@




SRC  := $(wildcard draft-*.xml) 

HTML := $(patsubst %.xml,%.html,$(SRC))
TXT  := $(patsubst %.xml,%.txt,$(SRC))
DIF  := $(patsubst %.xml,%.diff.html,$(SRC))

all: $(HTML) $(TXT) $(DIF) senml-simple.exi senml.exi

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

%.exi: %.xml 
	java -jar ExiProcessor.jar -xml_in $^ -exi_out $@ -schema senml.xsd  \
		-alignment bit_packed -strict -header_options -schemaID a

# decode
# java -jar ExiProcessor.jar -exi_in senml-simple.exi -schema senml.xsd -xml_out foo.xml -alignment byte_packed

#senml.exi: senml.xml 
#	java -jar ExiProcessor.jar -xml_in $^ -exi_out $@ -schema senml.xsd  -schemaID a -compression


senml-simple.exi: senml-simple.xml 
	java -jar ExiProcessor.jar -xml_in $^ -exi_out $@ -schema senml.xsd  \
		-alignment byte_packed -strict -header_options -schemaID a

senml-temp.exi: senml-temp.xml 
	java -jar ExiProcessor.jar -xml_in $^ -exi_out $@ -schema senml.xsd  \
		-alignment byte_packed -strict -header_options -schemaID a


%.dec.xml: %.exi 
	java -jar ExiProcessor.jar -exi_in $^ -xml_out $@ 



#   https://pypi.python.org/pypi/xml2rfc
xml2rfc ?= xml2rfc
#   https://github.com/cabo/kramdown-rfc2629
kramdown-rfc2629 ?= kramdown-rfc2629


draft = draft-jennings-core-senml-02

.PHONY: latest txt html pdf  diff clean  

latest: txt html senml-chk.xml


txt: $(draft).txt
html: $(draft).html
pdf: $(draft).pdf


clean:
	-rm -f $(draft).{txt,html,xml,pdf} senml-gen.* 


.INTERMEDIATE: $(draft).xml


%.xml: %.md
	$(kramdown-rfc2629) $< > $@

%.txt: %.xml
	$(xml2rfc) $< -o $@ --text

%.html: %.xml
	$(xml2rfc) $< -o $@ --html



senml-gen.xml: senml.xml
	cp senml.xml senml-gen.xml

senml-gen.exi: senml-gen.xml
	java -cp "bin/xercesImpl.jar:bin/exificient.jar" com.siemens.ct.exi.cmd.EXIficientCMD -encode -i senml-gen.xml -o senml-gen.exi -schema senml.xsd -bytePacked

senml-chk.xml: senml-gen.exi
	java -cp "bin/xercesImpl.jar:bin/exificient.jar" com.siemens.ct.exi.cmd.EXIficientCMD -decode -i senml-gen.exi -o senml-chk.xml -schema senml.xsd -bytePacked

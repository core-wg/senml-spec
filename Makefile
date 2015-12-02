
#   https://pypi.python.org/pypi/xml2rfc
xml2rfc ?= xml2rfc
#   https://github.com/cabo/kramdown-rfc2629
kramdown-rfc2629 ?= kramdown-rfc2629


draft = draft-jennings-core-senml-02

.PHONY: latest txt html pdf  diff clean  

latest: txt html senml-chk.xml senml-gen.jlog


txt: $(draft).txt
html: $(draft).html
pdf: $(draft).pdf


clean:
	-rm -f $(draft).{txt,html,xml,pdf} senml-gen.* senml-v2-gen.* ex[0-9]-gen.{exi,hex,json-trim}


.INTERMEDIATE: $(draft).xml


%.xml: %.md ex4-gen.json-trim senml-v2-gen.xsd ex8-gen.hex ex9-gen.hex
	$(kramdown-rfc2629) $< > $@

%.txt: %.xml
	$(xml2rfc) $< -o $@ --text

%.html: %.xml
	$(xml2rfc) $< -o $@ --html



senml-gen.xml: senml.xml
	cp senml.xml senml-gen.xml

senml-gen.exi: senml-gen.xml senml-gen.xsd
	java -cp "bin/xercesImpl.jar:bin/exificient.jar" com.siemens.ct.exi.cmd.EXIficientCMD -encode -i senml-gen.xml -o senml-gen.exi -schema senml-gen.xsd -bytePacked -strict -includeOptions -includeSchemaId 

senml-chk.xml: senml-gen.exi senml-gen.xsd
	java -cp "bin/xercesImpl.jar:bin/exificient.jar" com.siemens.ct.exi.cmd.EXIficientCMD -decode -i senml-gen.exi -o senml-chk.xml -schema senml-gen.xsd -bytePacked -strict -includeOptions -includeSchemaId 

senml-gen.rng: senml.rnc
	java -jar bin/trang.jar senml.rnc senml-gen.rng

senml-gen.xsd: senml.rnc 
	java -jar bin/trang.jar senml.rnc senml-gen.xsd

senml-v2-gen.xsd: senml-v2.rnc 
	java -jar bin/trang.jar senml-v2.rnc senml-v2-gen.xsd

senml-gen.jlog: senml.rnc senml-gen.xml
	java -jar bin/jing.jar -c senml.rnc senml-gen.xml > senml-gen.jlog


ex4-gen.json-trim: ex4.json
	head -13 < ex4.json > ex4-gen.json-trim


ex8-gen.exi: ex8.xml senml-v2-gen.xsd
	java -cp "bin/xercesImpl.jar:bin/exificient.jar" com.siemens.ct.exi.cmd.EXIficientCMD -encode -i ex8.xml -o ex8-gen.exi -schema senml-v2-gen.xsd -strict -includeOptions -includeSchemaId 

ex8-gen.hex: ex8-gen.exi
	hexdump ex8-gen.exi > ex8-gen.hex


ex9-gen.exi: ex9.xml senml-v2-gen.xsd
	java -cp "bin/xercesImpl.jar:bin/exificient.jar" com.siemens.ct.exi.cmd.EXIficientCMD -encode -i ex9.xml -o ex9-gen.exi -schema senml-v2-gen.xsd -bytePacked -strict -includeOptions -includeSchemaId 

ex9-gen.hex: ex9-gen.exi
	hexdump -C ex9-gen.exi > ex9-gen.hex

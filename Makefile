
#   https://pypi.python.org/pypi/xml2rfc
xml2rfc ?= xml2rfc
#   https://github.com/cabo/kramdown-rfc2629
kramdown-rfc2629 ?= kramdown-rfc2629


DRAFT = draft-jennings-core-senml
VERSION = 05

.PHONY: latest txt html pdf  diff clean check 

latest: txt html 

check: ex12.gen.chk ex11.gen.chk ex10.gen.chk ex1.gen.chk ex2.gen.chk ex7.gen.chk ex6.gen.chk ex5.gen.chk ex4.gen.chk ex3.gen.chk ex2.gen.chk ex1.gen.chk


txt: $(DRAFT)-$(VERSION).txt
html: $(DRAFT)-$(VERSION).html
pdf: $(DRAFT)-$(VERSION).pdf


clean:
	-rm -f $(draft).{txt,html,xml,pdf} *.gen.{chk,xsd,hex,exi,xml} *.gen.json-trim


.INTERMEDIATE: $(draft).xml 


$(DRAFT)-$(VERSION).xml: $(DRAFT).md ex4.gen.json-trim ex7.gen.xml senml5.gen.xsd ex2.gen.xml ex2.gen.hex ex1.gen.xml ex1.gen.hex 
	$(kramdown-rfc2629) $< > $@

%.txt: %.xml
	$(xml2rfc) $< -o $@ --text

%.html: %.xml
	$(xml2rfc) $< -o $@ --html

%.gen.xml: %.json
	senmlCat -xml -ijsons -i -print  $< | tidy -xml -i -wrap 68 -q -o $@

%.chk: %.xml senml5.rnc
	java -jar bin/jing.jar -c senml5.rnc $< > $@

%.tmp.xsd: %.rnc 
	java -jar bin/trang.jar $< $@

%.gen.xsd: %.tmp.xsd 
	cat $< | tidy -xml -q -i -wrap 68 -o $@


ex4.gen.json-trim: ex4.json
	head -13 <  $< > $@ 



ex2.gen.exi: ex2.gen.xml senml5.gen.xsd
	java -cp "bin/xercesImpl.jar:bin/exificient.jar" com.siemens.ct.exi.cmd.EXIficientCMD -encode -i ex2.gen.xml -o ex2.gen.exi -schema senml5.gen.xsd -strict -includeOptions -includeSchemaId 

ex2.gen.hex: ex2.gen.exi
	hexdump ex2.gen.exi > ex2.gen.hex



ex1.gen.exi: ex1.gen.xml senml5.gen.xsd
	java -cp "bin/xercesImpl.jar:bin/exificient.jar" com.siemens.ct.exi.cmd.EXIficientCMD -encode -i ex1.gen.xml -o ex1.gen.exi -schema senml5.gen.xsd -strict -includeOptions -includeSchemaId -bytePacked 

ex1.gen.hex: ex1.gen.exi
	hexdump -C ex1.gen.exi | sed -e "s/000000//" | sed -e "s/  |/ |/" | sed -e "s/  / /" | sed -e "s/  / /" > ex1.gen.hex

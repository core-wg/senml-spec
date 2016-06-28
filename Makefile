
#   https://pypi.python.org/pypi/xml2rfc
xml2rfc ?= xml2rfc
#   https://github.com/cabo/kramdown-rfc2629
kramdown-rfc2629 ?= kramdown-rfc2629


DRAFT = draft-ietf-core-senml
VERSION = 01

.PHONY: draft txt html pdf  clean check check2

draft: txt html 

all: draft check check2  $(DRAFT).diff.html

check: ex11.gen.chk ex10.gen.chk  ex8.gen.chk ex6.gen.chk ex5.gen.chk ex4.gen.chk ex3.gen.chk ex2.gen.chk ex1.gen.chk

check2: ex11.chk ex10.chk  ex8.chk ex6.chk ex5.chk ex4.chk ex3.chk ex2.chk ex1.chk  ex3.gen.cbor.chk ex3.gen.cbor.txt


$(DRAFT).diff.html: $(DRAFT)-$(VERSION).txt $(DRAFT)-old.txt 
	htmlwdiff   $(DRAFT)-old.txt   $(DRAFT)-$(VERSION).txt >   $(DRAFT).diff.html


txt: $(DRAFT)-$(VERSION).txt
html: $(DRAFT)-$(VERSION).html
pdf: $(DRAFT)-$(VERSION).pdf


clean:
	-rm -f $(draft).{txt,html,xml,pdf} *.gen.{chk,xsd,hex,exi,xml,cbor} *.chk *.gen.cbor.hex *.gen.exi.hex *.gen.json-trim

size: ex5.json ex5.gen.xml ex5.gen.exi ex5.gen.cbor ex5.json.Z ex5.gen.xml.Z ex5.gen.exi.Z ex5.gen.cbor.Z

.INTERMEDIATE: $(draft).xml 

%.Z: %
	gzip -n -c -9 < $< > $@


$(DRAFT)-$(VERSION).xml: $(DRAFT).md ex1.gen.exi.hex ex1.gen.xml ex1.json ex10.json ex11.json  ex2.gen.exi.hex ex2.gen.xml ex2.json ex3.json ex4.gen.json-trim ex5.json ex6.json senml.gen.xsd senml.rnc ex8.json ex3.gen.xml ex3.gen.cbor.hex size.md ex3.gen.cbor.txt
	$(kramdown-rfc2629) $< > $@

%.txt: %.xml
	$(xml2rfc) $< -o $@ --text

%.html: %.xml
	$(xml2rfc) $< -o $@ --html

%.gen.xml: %.json
	senmlCat -xml -ijson -i -print  $< | tidy -xml -i -wrap 68 -q -o $@

%.gen.cbor: %.json senml-json2cbor.rb
	ruby senml-json2cbor.rb  $< > $@

%.gen.cbor.txt: %.gen.cbor 
	cbor2pretty.rb $< | sed -e "s/6465763a6f773a3130653230373361303130383/ ... /" > $@

%.chk: %.xml senml.rnc
	java -jar bin/jing.jar -c senml.rnc $< > $@

%.chk: %.json senml.cddl senml-json.cddl
	cat senml.cddl senml-json.cddl | cddl - validate $<  > $@

%.gen.cbor.chk: %.gen.cbor senml.cddl senml-cbor.cddl
	cat senml.cddl senml-cbor.cddl | cddl - validate $<  > $@

%.tmp.xsd: %.rnc 
	java -jar bin/trang.jar $< $@

%.gen.xsd: %.tmp.xsd 
	cat $< | tidy -xml -q -i -wrap 68 -o $@


ex4.gen.json-trim: ex4.json
	head -13 <  $< > $@ 


%.hex: %
	hexdump -C $< | sed -e "s/0000//" | sed -e "s/  |/ |/" | sed -e "s/  / /" | sed -e "s/  / /" >  $@ 


ex5.gen.exi: ex5.gen.xml senml.gen.xsd
	java -cp "bin/xercesImpl.jar:bin/exificient.jar" com.siemens.ct.exi.cmd.EXIficientCMD -encode -i ex5.gen.xml -o ex5.gen.exi -schema senml.gen.xsd -strict -includeOptions -includeSchemaId

ex2.gen.exi: ex2.gen.xml senml.gen.xsd
	java -cp "bin/xercesImpl.jar:bin/exificient.jar" com.siemens.ct.exi.cmd.EXIficientCMD -encode -i ex2.gen.xml -o ex2.gen.exi -schema senml.gen.xsd -strict -includeOptions -includeSchemaId 

ex1.gen.exi: ex1.gen.xml senml.gen.xsd
	java -cp "bin/xercesImpl.jar:bin/exificient.jar" com.siemens.ct.exi.cmd.EXIficientCMD -encode -i ex1.gen.xml -o ex1.gen.exi -schema senml.gen.xsd -strict -includeOptions -includeSchemaId -bytePacked 


size.md: ex5.gen.cbor ex5.gen.cbor.Z ex5.gen.exi ex5.gen.exi.Z ex5.gen.xml ex5.gen.xml.Z ex5.json ex5.json.Z
	echo "| Encoding | Size | Compressed Size |" > size.md
	echo "| JSON |  "  `cat ex5.json | wc -c `  "|" `cat ex5.json.Z | wc -c` "|" >> size.md 
	echo "| XML |  "  `cat ex5.gen.xml | wc -c `  "|" `cat ex5.gen.xml.Z | wc -c` "|" >> size.md 
	echo "| CBOR |  "  `cat ex5.gen.cbor | wc -c `  "|" `cat ex5.gen.cbor.Z | wc -c` "|" >> size.md 
	echo "| EXI |  "  `cat ex5.gen.exi | wc -c `  "|" `cat ex5.gen.exi.Z | wc -c` "|" >> size.md 


#   https://pypi.python.org/pypi/xml2rfc
xml2rfc ?= xml2rfc
#   https://github.com/cabo/kramdown-rfc2629
kramdown-rfc2629 ?= kramdown-rfc2629


DRAFT = draft-ietf-core-senml
VERSION = 04

.PHONY: draft txt html pdf  clean check check2

draft: txt html 

diff: $(DRAFT).diff.html

gen: check check2  ex1.gen.exi.hex ex1.gen.xml ex1.json ex10.json ex11.json  ex2.gen.exi.hex ex2.gen.xml ex2.json ex3.json ex4.gen.json-trim ex5.json ex6.json senml.gen.xsd senml.rnc ex8.json ex3.gen.xml ex3.gen.cbor.hex size.md ex3.gen.cbor.txt ex3.gen.cbor ex8.gen.xml ex1.gen.json  ex10.gen.json  ex11.gen.json  ex2.gen.json  ex3.gen.json  ex5.gen.json  ex6.gen.json  ex8.gen.json  ex3.gen.wrap.json ex6.gen.wrap.json ex8.gen.wrap.json ex7.gen.json ex5.gen.resolved.json ex9.gen.json ex12.gen.json ex13.gen.json ex5.gen.wrap.json ex5.gen.resolved.wrap.json ex10.gen.wrap.json ex11.gen.wrap.json ex4.gen.wrap.json

check: ex11.gen.chk ex10.gen.chk  ex8.gen.chk ex6.gen.chk ex5.gen.chk ex4.gen.chk ex3.gen.chk ex2.gen.chk ex1.gen.chk ex9.gen.chk ex12.gen.chk ex13.gen.chk

check2: ex11.chk ex10.chk  ex8.chk ex6.chk ex5.chk ex4.chk ex3.chk ex2.chk ex1.chk  ex3.gen.cbor.chk ex3.gen.cbor.txt ex9.chk ex12.chk ex13.chk

all: gen draft diff

$(DRAFT).diff.html: $(DRAFT)-$(VERSION).txt $(DRAFT)-old.txt 
	htmlwdiff   $(DRAFT)-old.txt   $(DRAFT)-$(VERSION).txt >   $(DRAFT).diff.html


txt: $(DRAFT)-$(VERSION).txt
html: $(DRAFT)-$(VERSION).html
pdf: $(DRAFT)-$(VERSION).pdf


clean:
	-rm -f $(DRAFT)-$(VERSION).{txt,html,xml,pdf} *.gen.{chk,xsd,hex,exi,xml,cbor} *.chk *.gen.cbor.hex *.gen.exi.hex *.gen.json-trim

size: ex5.json ex5.gen.xml ex5.gen.exi ex5.gen.cbor ex5.json.Z ex5.gen.xml.Z ex5.gen.exi.Z ex5.gen.cbor.Z

.INTERMEDIATE: $(draft).xml 

%.Z: %
	gzip -n -c -9 < $< > $@


$(DRAFT)-$(VERSION).xml: $(DRAFT).md 
	$(kramdown-rfc2629) $< > $@

#$(DRAFT)-$(VERSION).xml: $(DRAFT).md ex1.gen.exi.hex ex1.gen.xml ex1.json ex10.json ex11.json  ex2.gen.exi.hex ex2.gen.xml ex2.json ex3.json ex4.gen.json-trim ex5.json ex6.json senml.gen.xsd senml.rnc ex8.json ex3.gen.xml ex3.gen.cbor.hex size.md ex3.gen.cbor.txt
#	$(kramdown-rfc2629) $< > $@


%.txt: %.xml
	$(xml2rfc) $< -o $@ --text

%.html: %.xml
	$(xml2rfc) $< -o $@ --html

%.gen.xml: %.json
	senmlCat -xml -ijson -i -print  $< | tidy -xml -i -wrap 68 -q -o $@

%.gen.json: %.json
	senmlCat -json -ijson -i -print  $<	> $@ 

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


ex4.gen.json-trim: ex4.gen.wrap.json
	head -11 <  $< > $@ 

ex3.gen.wrap.json: ex3.gen.json
	cat ex3.gen.json | sed -e 's/,"bu"/,#   "bu"/' | sed -e 's/,"n"/,#   "n"/' | tr "#" "\n" > ex3.gen.wrap.json

ex10.gen.wrap.json: ex10.gen.json
	cat ex10.gen.json | sed -e 's/,"v"/,#   "v"/' | tr "#" "\n" > ex10.gen.wrap.json

ex11.gen.wrap.json: ex11.gen.json
	cat ex11.gen.json | sed -e 's/,"v"/,#   "v"/' | tr "#" "\n" > ex11.gen.wrap.json

ex4.gen.wrap.json: ex4.gen.json
	cat ex4.gen.json | sed -e 's/,"bu"/,#   "bu"/' | tr "#" "\n" > ex4.gen.wrap.json

ex5.gen.wrap.json: ex5.gen.json
	cat ex5.gen.json | sed -e 's/,"bu"/,#   "bu"/' | tr "#" "\n" > ex5.gen.wrap.json

ex5.gen.resolved.wrap.json: ex5.gen.resolved.json
	cat ex5.gen.resolved.json | sed -e 's/,"v"/,#   "v"/' | tr "#" "\n" > ex5.gen.resolved.wrap.json

ex6.gen.wrap.json: ex6.gen.json
	cat ex6.gen.json | sed -e 's/5,/5,#   /' | tr "#" "\n" > ex6.gen.wrap.json

ex8.gen.wrap.json: ex8.gen.json
	cat ex8.gen.json | sed -e 's/,"l"/,#   "l"/' |  sed -e 's/,"n"/,#   "n"/' | tr "#" "\n" > ex8.gen.wrap.json

ex5.gen.resolved.json: ex5.json
	senmlCat -json -ijson -resolve -i -print ex5.json | sed -e 's/"bver"\:.,//' >  ex5.gen.resolved.json

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

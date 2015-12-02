
#   https://pypi.python.org/pypi/xml2rfc
xml2rfc ?= xml2rfc
#   https://github.com/cabo/kramdown-rfc2629
kramdown-rfc2629 ?= kramdown-rfc2629


draft = draft-jennings-core-senml-03

.PHONY: latest txt html pdf  diff clean check 

latest: txt html 

check: ex12.gen.chk ex11.gen.chk ex10.gen.chk ex9.gen.chk ex8.gen.chk ex7.gen.chk ex6.gen.chk ex5.gen.chk ex4.gen.chk ex3.gen.chk ex2.gen.chk ex1.gen.chk


txt: $(draft).txt
html: $(draft).html
pdf: $(draft).pdf


clean:
	-rm -f $(draft).{txt,html,xml,pdf} *.gen.{chk,xsd,hex,exi,xml} *.gen.json-trim


.INTERMEDIATE: $(draft).xml 


%.xml: %.md ex4.gen.json-trim ex7.gen.xml  senml3.gen.xsd ex8.gen.xml ex8.gen.hex ex9.gen.xml ex9.gen.hex 
	$(kramdown-rfc2629) $< > $@

%.txt: %.xml
	$(xml2rfc) $< -o $@ --text

%.html: %.xml
	$(xml2rfc) $< -o $@ --html


%.gen.xml: %.json
	checkSenML -xml -i $< > $@

%.chk: %.xml senml3.rnc
	java -jar bin/jing.jar -c senml3.rnc $< > $@

%.gen.xsd: %.rnc 
	java -jar bin/trang.jar $< $@

ex4.gen.json-trim: ex4.json
	head -13 <  $< > $@ 



ex8.gen.exi: ex8.xml senml3.gen.xsd
	java -cp "bin/xercesImpl.jar:bin/exificient.jar" com.siemens.ct.exi.cmd.EXIficientCMD -encode -i ex8.xml -o ex8.gen.exi -schema senml3.gen.xsd -strict -includeOptions -includeSchemaId 

ex8.gen.hex: ex8.gen.exi
	hexdump ex8.gen.exi > ex8.gen.hex


ex9.gen.exi: ex9.xml senml3.gen.xsd
	java -cp "bin/xercesImpl.jar:bin/exificient.jar" com.siemens.ct.exi.cmd.EXIficientCMD -encode -i ex9.xml -o ex9.gen.exi -schema senml3.gen.xsd -bytePacked -strict -includeOptions -includeSchemaId 

ex9.gen.hex: ex9.gen.exi
	hexdump -C ex9.gen.exi > ex9.gen.hex

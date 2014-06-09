all: generate test ttf woff eot ttf-dist sfd-dist web-dist  
version:= 2.93.0

generate : ttf 
	cp ../scripts/auto_test.py .;	
	@echo "----------Generating  test-case-output from ttf file-----------"
	python auto_test.py test.txt Lohit-Devanagari.ttf generate

test: test-ttf
	@echo "----------Testing actual-output with expected-output----------"
	python auto_test.py std-test-out.txt Lohit-Devanagari.ttf testing
	
ttf: ttf-bin
	@echo "----------Generating ttf from sfd file----------"
	python apply_featurefile.py Lohit-Devanagari.sfd Lohit-Devanagari.fea
	./generate.pe *.sfd
	@echo "----------Finished generating ttf file----------"
	@echo " "

woff: woff-bin
	@echo "----------Generating woff from ttf file----------"
	java -jar /usr/share/java/sfnttool.jar -w Lohit-Devanagari.ttf Lohit-Devanagari.woff
	@echo "----------Finished generating woff file----------"
	@echo " "

eot: eot-bin
	@echo "----------Generating eot from ttf file----------"
	java -jar /usr/share/java/sfnttool.jar -e -x Lohit-Devanagari.ttf Lohit-Devanagari.eot
	@echo "----------Finished generating eot file----------"
	@echo " "

ttf-dist: dist
	mkdir lohit-devanagari-ttf-$(version)
	cp -p COPYRIGHT OFL.txt test-devanagari.txt README  AUTHORS ChangeLog 66-lohit-devanagari.conf Lohit-Devanagari.ttf lohit-devanagari-ttf-$(version)
	rm -rf lohit-devanagari-ttf-$(version)/.git
	tar -cf lohit-devanagari-ttf-$(version).tar lohit-devanagari-ttf-$(version)
	gzip lohit-devanagari-ttf-$(version).tar
	rm -rf lohit-devanagari-ttf-$(version)

sfd-dist: dist
	mkdir lohit-devanagari-$(version)
	cp -p COPYRIGHT OFL.txt test-devanagari.txt README  AUTHORS generate*.pe *.py *.fea Makefile ChangeLog 66-lohit-devanagari.conf Lohit-Devanagari.sfd lohit-devanagari-$(version)
	rm -rf lohit-devanagari-$(version)/.git
	rm -rf lohit-devanagari-$(version)/*.ttf
	tar -cf lohit-devanagari-$(version).tar lohit-devanagari-$(version)
	gzip lohit-devanagari-$(version).tar
	rm -rf lohit-devanagari-$(version)

web-dist: webdist
	mkdir lohit-devanagari-web-$(version)
	cp -p COPYRIGHT OFL.txt test-devanagari.txt README  AUTHORS ChangeLog Lohit-Devanagari.woff  Lohit-Devanagari.eot lohit-devanagari-web-$(version)
	rm -rf lohit-devanagari-web-$(version)/.git
	tar -cf lohit-devanagari-web-$(version).tar lohit-devanagari-web-$(version)
	gzip lohit-devanagari-web-$(version).tar
	rm -rf lohit-devanagari-web-$(version)

clean: cleanall
	rm -f *.ttf *.eot *.woff
	rm -rf *.tar.gz
	rm -rf lohit-devanagari*

.PHONY: generate-test test-ttf ttf-bin woff-bin eot-bin webdist dist cleanall version

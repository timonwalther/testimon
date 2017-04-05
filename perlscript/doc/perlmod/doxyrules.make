DOXY_EXEC_PATH = /var/www/html/testimon/perlscript
DOXYFILE = /var/www/html/testimon/perlscript/-
DOXYDOCS_PM = /var/www/html/testimon/perlscript/Doc/perlmod/DoxyDocs.pm
DOXYSTRUCTURE_PM = /var/www/html/testimon/perlscript/Doc/perlmod/DoxyStructure.pm
DOXYRULES = /var/www/html/testimon/perlscript/Doc/perlmod/doxyrules.make

.PHONY: clean-perlmod
clean-perlmod::
	rm -f $(DOXYSTRUCTURE_PM) \
	$(DOXYDOCS_PM)

$(DOXYRULES) \
$(DOXYMAKEFILE) \
$(DOXYSTRUCTURE_PM) \
$(DOXYDOCS_PM): \
	$(DOXYFILE)
	cd $(DOXY_EXEC_PATH) ; doxygen "$<"

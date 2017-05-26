use Test::More;

#https://docs.travis-ci.com/user/languages/perl/
#https://perldoc.perl.org/Test/More.html

require "../../perlscript/boosttest.pm";
use lib "../../perlscript";


print "Test-More \n";

####StringHelper####

#withoutWhitespaces
ok(StringHelper::withoutWhitespaces("there a lot of W h i t e s p a c e   s") eq "therealotofWhitespaces", "StringHelper test function withoutWhitespaces()");

ok(StringHelper::withoutCheckedPassed("haspassed blabla check") eq "blabla","StringHelper test function withoutCheckedPassed()");  

####XMLHelper####

#getFileElement close
ok(XMLHelper::getFileElement("test.xml","close") eq "</test>", "XMLHelper test function getFileElement called with close");

#getFileElement open
ok(XMLHelper::getFileElement("test.xml","open") eq "<test type=\"file\">", "XMLHelper test function getFileElement called with open");

#getOnlyValueOfAttr
ok(XMLHelper::getOnlyValueOfAttr("name", 'name="value"') eq "value", "XMLHelper test function getOnlyValueOfAttr()");

#buildAttribute
ok(XMLHelper::buildAttribute("name","value") eq 'name="value"', "XMLHelper test function buildAttribute()");

#getFileElement
ok(XMLHelper::getXPathQueryBoosttest ("caseName", "info") eq '//TestCase[@name=\'caseName\']/Info', "XMLHelper test function getXPathQuery()");
  

done_testing();
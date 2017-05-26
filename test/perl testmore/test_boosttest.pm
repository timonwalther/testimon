use Test::More;

#https://docs.travis-ci.com/user/languages/perl/
#https://perldoc.perl.org/Test/More.html

require "../../perlscript/boosttest.pm";
use lib "../../perlscript";


print "Test-More \n";


#withoutWhitespaces
ok(StringHelper::withoutWhitespaces("there a lot of W h i t e s p a c e   s") eq "therealotofWhitespaces", "test function withoutWhitespaces()");

#getOnlyValueOfAttr
ok(XMLHelper::getOnlyValueOfAttr("name", 'name="value"') eq "value", "test function getOnlyValueOfAttr()");

#buildAttribute
ok(XMLHelper::buildAttribute("name","value") eq 'name="value"', "test function buildAttribute()");

#getFileElement
ok(XMLHelper::getXPathQueryBoosttest ("caseName", "info") eq '//TestCase[@name=\'caseName\']/Info', "test function getXPathQuery()");
  

done_testing();
use Test::More;

#https://docs.travis-ci.com/user/languages/perl/
#https://perldoc.perl.org/Test/More.html

require "../boosttest.pm";
use lib "../";


print "Test-More \n";


#withoutWhitespaces
ok(withoutWhitespaces("there a lot of W h i t e s p a c e   s") eq "therealotofWhitespaces", "test function withoutWhitespaces()");

#getOnlyValueOfAttr
ok(getOnlyValueOfAttr("name", 'name="value"') eq "value", "test function getOnlyValueOfAttr()");

#buildAttribute
ok(buildAttribute("name","value") eq 'name="value"', "test function buildAttribute()");

#getFileElement
ok(getXPathQuery ("caseName", "info") eq '//TestCase[@name=\'caseName\']/Info', "test function getXPathQuery()");
  

done_testing();
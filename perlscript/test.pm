require 'xmlHelper.pm';


my $a = XMLHelper::WhoIS('<!-- Bla ssd lasd sdsd  sdsd -->'); 


if ($a eq 'Comment') {
	print "Comment\n";
}
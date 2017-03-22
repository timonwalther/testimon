#!/usr/bin/perl
use strict;

#parameter 
sub Worker {
  print "Worker out of Catch Test\n";
  # print $_[0]; 
}



#it is only for 
sub returnValue {
return 1;
}
my $returnValueRequire = returnValue();
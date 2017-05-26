#** @file dependency.pm
#
#*

use lib "../perlscript/";
# for documentation
use Doxygen::Filter::Perl;

# for testing
#use Template;
use Pod::Coverage;
use Test::More;
use Test::Differences; 


# for development
use XML::LibXML;
use File::Touch;
use Path::Class;
use JSON::Parse 'json_file_to_perl';


#packages 
require "stringHelper.pm";
require "xmlHelper.pm";
1;
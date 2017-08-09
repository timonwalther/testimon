#** @file nunit.pm
#   This file change the boost xml format in the defined middle format 
#* 

use 		strict;
use 		warnings;

#use lib "../libs/perl/XML-LibXML-2.0129/lib/XML/LibXML";
use lib "../perlscript/";

#use constants
use 		constant FRAMEWORK 			=> "nunit"; 
use 		constant ROOTXMLELEMENT 	=> '<?xml version="1.0"?><test-framework name="'.FRAMEWORK.'">';
use 		constant CLOSEROOTELEMENT	=> '</test-framework>';
use 		constant PATHNEWFILE		=> '../uploadfiles/newformats/format.xml';	

#use constructs 
use 		Switch;
use 		experimental 'smartmatch'; #to search with that ~~
use 		XML::LibXML;

require 	"dependency.pm"; #this source holds every dependency
   
#** @method Worker
#   
#*   
  
sub Worker {

    print "Worker out of NUNIT Test\n";
  
    my $result 				= ROOTXMLELEMENT; 
    my $parser     			= XML::LibXML->new();
	my $test_str;
	my $key;
	my $testcase;					
	my $node;
	my $parentNode;
    

	my 	%fileContent;
		%fileContent 	=  	%{shift()};

	my 	$dir;
		$dir 			= 	shift;
	
	
	my @testcases;
	my @attributes;
	
	
	my $name;
	my $fileName;
	my $string;
	my $caseResult;
	my $line;
	my $time;
	
	
    # for all arguments   
    foreach $key (keys %fileContent) {
     
		#** @var $test
		#   take one argument (the content of a file) 
		#*
			
        #$test_fil 	=	$parser->parse_file($dir.'\\'.$key);			
		$test_str  	= 	$parser->parse_string($fileContent{$key});
	    			
		$node = $test_str;
		
		$node = XMLHelper::nextNode($node);

		while (XMLHelper::nextNode($node)) {
			
			if ($node->nodeName eq 'test-case') {
			
				$fileName = "file='".$key."'"; 
			
				if (XMLHelper::allAttributes($node)) {
					
					@attributes = XMLHelper::allAttributes($node);
					for (my $i = 0; $i < scalar @attributes; $i++) {
					   
						if ($attributes[$i]->name eq 'name') {
							$name =  "name='".$attributes[$i]->value."'";
						}
						
						if ($attributes[$i]->name eq 'time') {
							$name =  "time='".$attributes[$i]->value."'";
						}

						if ($attributes[$i]->name eq 'success') {
							if ($attributes[$i]->value eq 'True') { 
								$caseResult = "result='success'";
							}
							else {
								$caseResult = "result='failure'";
							}
						}
					}#end for 
					$line = "line=''";
					
				}#end if attributes
				
				$testcase = "<test-case ".$name." ".$fileName." ".$line." ".$time." ".$caseResult." "."/>\n\r";	
							
				if ( not ($testcase ~~ @testcases)) {
					print $testcase."\n";
					$result .= $testcase;
					push @testcases, $testcase;
				}
				else {
				}
			}#end if test-case
					
			$node = XMLHelper::nextNode($node); 	
		}#end while	
	}#end foreach	

	$result   	.= CLOSEROOTELEMENT;  
	my $file; 
	
	#touching the new file
	if (touch(PATHNEWFILE)) {   
		#write the testCaseContent to new file 
		$file = file(PATHNEWFILE);
		$file->spew($result);
	}	
}
1;
#var/www/html/testimon

#** @file junit.pm
#   This file change the boost xml format in the defined middle format 
#* 

use 		strict;
use 		warnings;

use lib "../perlscript/";
use experimental 'smartmatch'; #to search with that ~~

#use constants
use 		constant FRAMEWORK 			=> "catch"; 
use 		constant ROOTXMLELEMENT 	=> '<?xml version="1.0"?><test-framework name="'.FRAMEWORK.'">';
use 		constant CLOSEROOTELEMENT	=> '</test-framework>';
use 		constant PATHNEWFILE		=> '../uploadfiles/newformats/format.xml';	

#use constructs 
use 		Switch;

require 	"dependency.pm"; #this source holds every dependency
 

sub Worker {

    print "Worker out of Catch Test\n";
  
    my $result 				= ROOTXMLELEMENT; 
    my $parser     			= XML::LibXML->new();
    
	my $test;
	my $node;
	my $tempNode;
	my $info;
	my $passed = '1';
	my @attributes;
	my @testcases;
	
	my $name;
	my $fileName;
	my $string;
	my $caseResult;
	my $line;
	
	my $key;
	my $testcase;
 
	my %fileContent;
	%fileContent =  %{shift()};
  
    # for all arguments   
    foreach $key (keys %fileContent) {
     
		#** @var $test
		#   take one argument (the content of a file) 
		#*
				
		$test   				= 	$parser->parse_string($fileContent{$key});   
		
		$node = $test;
		
		$node = XMLHelper::nextNode($node);

		while (XMLHelper::nextNode($node)) {
						
			if ($node->nodeName eq 'testcase') {
			
				$fileName = "file='".$key."'"; 
			
				if (XMLHelper::allAttributes($node)) {
					
					@attributes = XMLHelper::allAttributes($node);
					for (my $i = 0; $i < scalar @attributes; $i++) {
					   
						if ($attributes[$i]->name eq 'name') {
							$name =  "name='".StringHelper::replaceSign($attributes[$i]->value, "'", "´")."'";
						}

					}#end for 	
				}#end if attributes
				
				if (XMLHelper::nextNode($node)->nodeName eq 'failure'){
					$caseResult = "result='failure'";
				}
				else {
					$caseResult = "result='success'";
				}
								
				$line = "line=''"; 
				
				$testcase = "<test-case ".$name." ".$fileName." ".$line." ".$caseResult." "."/>\n\r";	
						
				if ( not ($testcase ~~ @testcases)) {
					$result .= $testcase;
					push @testcases, $testcase;
				}
				else {
				}
			}#end if test-case
			
			#optimazion you can overjump this or that
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
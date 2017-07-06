#var/www/html/testimon

#** @file boosttest.pm
#   This file change the boost xml format in the defined middle format 
#* 

use 		strict;
use 		warnings;

use lib "../perlscript/";

#use constants
use 		constant FRAMEWORK 			=> "boosttest"; 
use 		constant ROOTXMLELEMENT 	=> '<?xml version="1.0"?><test-framework name="'.FRAMEWORK.'">';
use 		constant CLOSEROOTELEMENT	=> '</test-framework>';
use 		constant PATHNEWFILE		=> '../uploadfiles/newformats/format.xml';	
use 		constant ROOT				=> 'TestLog';

#use constructs 
use 		Switch;

require 	"dependency.pm"; #this source holds every dependency
 
sub buildAttributes {

	my $caseName 	= shift; 	
	my $caseFile	= shift;	
	my $caseLine	= shift;	
	my $testTime	= shift;	
	my $result;

	if (defined $caseName and defined $caseFile and defined $caseLine and defined $testTime) {
	
		$caseName		= XMLHelper::buildAttribute('case', $caseName);  
		$caseLine		= StringHelper::withoutWhitespaces('case'.$caseLine); 
		$testTime		= XMLHelper::buildAttribute('testingTime',$testTime); 

		$result 	= ' '.$caseName.' '.$caseLine.' '.$caseFile.' '.$testTime;
	}
	else {
		$result		= "SOME VALUES ARE UNDEFINED";
	}
	
	return $result;
}

sub buildElements {
	
	my %testCaseInfoInit		= %{shift()};   	#get first argument
	my %testCaseInfoLine 	 	= %{shift()};
	my %testCaseTestingTime		= %{shift()};
	my @caseLines           	= @{shift()}; 
	my @caseFiles           	= @{shift()};
		
	my @testCaseInfoResult   	= ();
	
	my $info;
	my $lineIndex	= 0; 			 
	my $key;
	
	foreach $key (keys %testCaseInfoInit) {
		
			$info			 	= "";	
			
			#go trough the hash entry by entry 
			for (my $i = 0; $i < scalar @{$testCaseInfoInit{$key}}; $i++) {
			
			
				#get the info string in the right shape (without Whitespaces and as an string)
				$info 		=  	@{$testCaseInfoInit{$key}}[$i]->to_literal;
				$info 		= 	StringHelper::withoutWhitespaces ($info);
			
					#HINT could add more cases 
					#CASE check haspassed
					if ($info =~ /check/  and $info =~ /haspassed/ ) {
                		
						#remove those two keywords checked and haspassed in the string	
						$info =  StringHelper::withoutCheckedPassed($info); 																				
																										#name -      file               line                 time
						$info = '<test-case-passed '.@{$testCaseInfoLine{$key}}[$i].buildAttributes($key, $caseFiles[$lineIndex],$caseLines[$lineIndex],$testCaseTestingTime{$key}).'>'.$info.'</test-case-passed>' ;
						push @testCaseInfoResult, $info;
					}
			
			}#for end	
            $lineIndex++;					
	}#foreach end
	return "@testCaseInfoResult";	
}  
  
#** @method Worker
#   
#*   
  
sub Worker {

    print "Worker out of Boost Test\n";
  
    my $result 				= ROOTXMLELEMENT; 
    my $parser     			= XML::LibXML->new();
    
	my $test;
	my $key;
	my $caseName;
	my $suite;	
	my $branch;				#build of Master Test Suite
 
	my %fileContent;
	%fileContent =  %{shift()};
  
    # for all arguments   
    foreach $key (keys %fileContent) {
     
		#** @var $test
		#   take one argument (the content of a file) 
		#*
				
		$test   				= 	$parser->parse_string($fileContent{$key});   
		$suite					=	$test->findnodes('//'.ROOT.'/TestSuite/@name'); 
		$branch					= 	StringHelper::getBranch($suite);
	
		$result			 		.=  XMLHelper::getFileElement($key, 'open');  
		 
		foreach my $case ($test->findnodes('/'.ROOT.'/TestSuite')) {
  		
				#get the attributes:  	<Testcase  'name' , 'line' , 'file'>   
				my @caseNames      		= $case->findnodes('//TestCase/@name');				
				my @caseLines			= $case->findnodes('//TestCase/@line'); 
				my @caseFiles       	= $case->findnodes('//TestCase/@file');
		
				my %info;
				my %line;
				my %testTime;
					
				for (my $j = 0; $j < scalar @caseNames; $j++) {
		
					$caseName = XMLHelper::getOnlyValueOfAttr ('name', $caseNames[$j]);
		
				    #for every case name look for the infos
				    $info{$caseName} 	 		= $case->findnodes(XMLHelper::getXPathQueryBoosttest($caseName,'info')); 		#fills the %info  var
				    #for every info look for the line attribute
				    $line{$caseName}    		= $case->findnodes(XMLHelper::getXPathQueryBoosttest($caseName,'infoline'));	#fills the %line var
				    #for every case name look for the testing Time
				    $testTime{$caseName} 		= $case->findnodes(XMLHelper::getXPathQueryBoosttest($caseName,'testtime'));	#fills the %testTime var 
				    
				   
			}#end for
			$result 	   .=  buildElements (\%info, \%line, \%testTime, \@caseLines, \@caseFiles);	
		}#end foreach
		$result  		.= XMLHelper::getFileElement($key, 'close');
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
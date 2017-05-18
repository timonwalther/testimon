#var/www/html/testimon


#** @file boosttest.pl
#   This file change the boost xml format in the defined middle format 
#* 

use 		strict;
use 		constant FRAMEWORK 	=> "boosttest"; 
use 		Switch;

require 	"dependency.pm"; #this source holds every dependency
  

#delete whitespaces of a value
sub withoutWhitespaces  {

	my $value = shift;
	while ($value 	=~ s/\s+//) {}
	return $value;
}

#get only the value without any quotes 
sub getOnlyValueOfAttr {

	my $attrName 		= shift;
	my $attrValue 		= shift;
 
	$attrValue 			=~ s/$attrName=//; 			#delete attributename	
	while ($attrValue 	=~ s/"//) {} 				#delete  "" 
	$attrValue 			=~ s/\s//;					#delete  whitespaces
	
	return $attrValue ;
}# getOnlyValueOfAttr

#build an attribute with value and name 
sub buildAttribute {

	my $attrName 		= shift();
    my $attrValue		= shift();
		
	return $attrName.'="'.$attrValue.'"';  	
}#end buildAttribute


sub buildElementTestPassed {

    my $result 		= '<test-case-passed';
	return $result;
}#end buildElementTestPassed

#build special element - #one argument
sub getFileElement {  

		my $result 		= shift();
		
		if ($result =~ /.xml/) {
			#delete dot and suffix
			$result =~ s/.xml//;
			return '<'.$result.' type="file">';
		} 			
}#end getFileElement



#method which sends 
sub getXPathQuery {

	my $caseName 	= 	shift();	
	#get the query keyword
	my $selector	=  	shift(); 

	switch ($selector) {
	
		case "info" 	{
			return '//TestCase[@name=\''.$caseName.'\']/Info';
		}
		case "infoline" {		
			return '//TestCase[@name=\''.$caseName.'\']/Info/@line';
		}
		case "testtime" {
			return '//TestCase[@name=\''.$caseName.'\']/TestingTime/text()';
		}	
		else			{
			print "There occours a query mistake!\n";
			return "";
		}   
	} 
}#end getXPathQuery


sub builtElements {
	
	my %testCaseInfoInit		= %{shift()};   	#get first argument
	my %testCaseInfoLine 	 	= %{shift()};
	my %testCaseTestingTime		= %{shift()};
	my @caseLines           	= @{shift()}; 
	my @caseFiles           	= @{shift()};
		

	my @testCaseInfoResult   	= ();
	
	my $info;
	my $testTime;
	my $caseName;
	my $caseLine;  
	my $caseFile;
	
	my $lineIndex	= 0; 			 
	my $key;
	
	foreach $key (keys %testCaseInfoInit) {
		
			$info			 	= "";	
			
			$caseName 			= buildAttribute('case', $key); 
			$caseLine			= @caseLines[$lineIndex];
			$caseFile			= @caseFiles[$lineIndex];
			$caseLine			= 'case'.$caseLine;
			
			$testTime       	= $testCaseTestingTime{$key};		
			$testTime 			= buildAttribute('testingTime',$testTime); 
			
			$lineIndex++;
			
			$caseLine = withoutWhitespaces ($caseLine);		
			
			#go trough the hash entry by entry 
			for (my $i = 0; $i < scalar @{$testCaseInfoInit{$key}}; $i++) {
			
			
				#get the info string in the right shape (without Whitespaces and as an string)
				$info 		=  	@{$testCaseInfoInit{$key}}[$i]->to_literal;
				$info 		= 	withoutWhitespaces ($info);
			
					#HINT could add more cases 
					#CASE check haspassed
					if ($info =~ /check/  and $info =~ /haspassed/ ) {
                		
						#remove those two keywords in the string	
						$info =~ s/check//;
						$info =~ s/haspassed//;
					
						$info = '<test-case-passed '.@{$testCaseInfoLine{$key}}[$i].' '.$caseName.' '.$caseLine.' '.$caseFile.' '.$testTime.'>'.$info.'</test-case-passed>' ;
						push @testCaseInfoResult, $info;
					}
				}#for end			
	}#foreach end
	return "@testCaseInfoResult";	
}  
  
#** @method Worker
#   
#*   
  
sub Worker {

    print "Worker out of Boost Test\n";
  
    my $testCaseContent 	= '<?xml version="1.0"?><test-framework name="'.FRAMEWORK.'">';
    my $parser     			= XML::LibXML->new();
    my $test;
	my $key;
	my $caseName;
 
 
	my %fileContent;
	%fileContent =  %{shift()};
  
    # for all arguments   
    foreach $key (keys %fileContent) {
     
		#** @var $test
		#   take one argument (the content of a file) 
		#*
				
		$test   				= 	$parser->parse_string($fileContent{$key});
	
		$testCaseContent 		.=  getFileElement($key);  
		 
		foreach my $case ($test->findnodes('/TestLog/TestSuite')) {
  		
				#get the attributes:  	<Testcase  'name' , 'line' , 'file'>   
				my @caseNames      		= $case->findnodes('//TestCase/@name');
				
				my @caseLines			= $case->findnodes('//TestCase/@line'); 
				my @caseFiles       	= $case->findnodes('//TestCase/@file');
		
				my %info;
				my %line;
				my %testTime;
					
				for (my $j = 0; $j < scalar @caseNames; $j++) {
		
					$caseName = getOnlyValueOfAttr ('name', @caseNames[$j]);
		
				    #for every case name look for the infos
				    $info{$caseName} 	 		= $case->findnodes(getXPathQuery($caseName,'info')); 		#fills the %info  var
				    #for every info look for the line attribute
				    $line{$caseName}    		= $case->findnodes(getXPathQuery($caseName,'infoline'));	#fills the %line var
				    #for every case name look for the testing Time
				    $testTime{$caseName} 		= $case->findnodes(getXPathQuery($caseName,'testtime'));	#fills the %testTime var 
				    
				   
			}#end for
			$testCaseContent   .=  builtElements (\%info, \%line, \%testTime, \@caseLines, \@caseFiles);	
		}#end foreach
		$testCaseContent 		.= '</'.getFileElement($key).'>';
	}#end foreach	
		
	$testCaseContent  	.= '</test-framework>';
  
  
	my $file; 
	
	#touching the new file
	if (touch('format.xml')) {   
		#write the testCaseContent to new file 
		$file = file('format.xml');
		$file->spew( $testCaseContent  );
	}	
}

#it is only for working in general
sub returnValue {
return 1;
}
my $returnValueRequire = returnValue();
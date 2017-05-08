#var/www/html/testimon


#** @file boosttest.pl
#   This file change the boost xml format in the defined middle format 
#* 

use 		strict;
use 		constant FRAMEWORK 	=> "boosttest"; 

require 	"dependency.pm"; #this source holds every dependency
 
 
#** @method builtElements
#   
#* 


#delete whitespaces of a value
sub withoutWhitespaces  {

	my $value = shift;
	while ($value 	=~ s/\s+//) {}
	return $value;
}

#get only the value without any quotes 
sub getOnlyValueOfAttr {

	my $attrValue 		= shift;
	my $attrName 		= shift;
	 
	$attrValue 			=~ s/$attrName=//; 			#delete attributename	
	while ($attrValue 	=~ s/"//) {} 				#delete  "" 
	$attrValue 			=~ s/\s//;					#delete  whitespaces
	
	return $attrValue ;
}


 
sub builtElements {
	
	my %testCaseInfoInit		= %{shift()};   	#get first argument
	my %testCaseInfoLine 	 	= %{shift()};
	my %testCaseTestingTime		= %{shift()};
	my @caseLines           	= @{shift()}; 
	my @caseFiles           	= @{shift()};
		

	my @testCaseInfoResult   	= ();
	
	my $info;
	my $testTime;
	my $case;
	my $caseLine;  
	my $caseFile;
	
	my $lineIndex	= 0; 			 
	my $key;
	
	foreach $key (keys %testCaseInfoInit) {
		
			$info			 	= "";	
			
			$case 				= 'case="'.$key.'"';
			$caseLine			= @caseLines[$lineIndex];
			$caseFile			= @caseFiles[$lineIndex];
			$caseLine			= 'case'.$caseLine;
			
			$testTime       	= $testCaseTestingTime{$key};		
			$testTime 			= 'testingTime="'.$testTime.'"';
			
			$lineIndex++;
			
			$caseLine = withoutWhitespaces ($caseLine);		
			
			#go trough the hash entry by entry 
			for (my $i = 0; $i < scalar @{$testCaseInfoInit{$key}}; $i++) {
			
				$info 		=  @{$testCaseInfoInit{$key}}[$i]->to_literal;
			
				$info = withoutWhitespaces ($info);
			
					#HINT could add more cases 
					#CASE check haspassed
					if ($info =~ /check/  and $info =~ /haspassed/ ) {
                		
						#remove those two keywords in the string	
						$info =~ s/check//;
						$info =~ s/haspassed//;
					
						$info = '<test-case-passed '.@{$testCaseInfoLine{$key}}[$i].' '.$case.' '.$caseLine.' '.$caseFile.' '.$testTime.'>'.$info.'</test-case-passed>' ;
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
	my $tempKey;
 
	my %fileContent;
	%fileContent =  %{shift()};
  
    # for all arguments   
    foreach $key (keys %fileContent) {
     
		#** @var $test
		#   take one argument (the content of a file) 
		#*
				
		$test   				= $parser->parse_string($fileContent{$key});
		
		$tempKey 				= $key;
		$tempKey 				=~ s/.xml//; 					#delete dot and suffix
		$testCaseContent 		.= '<'.$tempKey.' type="file">';
		 
		foreach my $case ($test->findnodes('/TestLog/TestSuite')) {
  		
				#get the attributes:  	<Testcase  'name' , 'line' , 'file'>   
				my @caseNames      		= $case->findnodes('//TestCase/@name');
				
				my @caseLines			= $case->findnodes('//TestCase/@line'); 
				my @caseFiles       	= $case->findnodes('//TestCase/@file');
		
				my %info;
				my %line;
				my %testTime;
					
				for (my $j = 0; $j < scalar @caseNames; $j++) {
		
					@caseNames[$j] = getOnlyValueOfAttr (@caseNames[$j], 'name');
		
				    #for every case name look for the infos
				    my $query 						= '//TestCase[@name=\''.@caseNames[$j].'\']/Info';
				    $info{@caseNames[$j]} 	 		= $case->findnodes($query); 						#fills the %info  var
				    #for every info look for the line attribute
				    $query  		    			= '//TestCase[@name=\''.@caseNames[$j].'\']/Info/@line';
				    $line{@caseNames[$j]}    		= $case->findnodes($query);							#fills the %line var
				    #for every case name look for the testing Time
				    $query 							= '//TestCase[@name=\''.@caseNames[$j].'\']/TestingTime/text()';
				    $testTime{@caseNames[$j]} 		=  $case->findnodes($query);						#fills the %testTime var 
				    
				    $query 							= ''
				    
				   
			}#end for
			$testCaseContent   .=  builtElements (\%info, \%line, \%testTime, \@caseLines, \@caseFiles);	
		}#end foreach
		$testCaseContent 		.= '</'.$tempKey.'>';
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
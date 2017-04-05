#var/www/html/testimon


#** @file boosttest.pl
#   This file change the boost xml format in the defined middle format 
#* 

use 		strict;
use 		constant FRAMEWORK 	=> "boosttest"; 

require 	"dependency.pm";
 
 
#** @method builtElements
#   
#* 
 
sub builtElements {
	
	my %testCaseInfoInit		= %{shift()};
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
			
			#this isn't correct
			$case 				= 'case="'.$key.'"';
			$caseLine			= @caseLines[$lineIndex];
			$caseFile			= @caseFiles[$lineIndex];
			$caseLine			= 'case'.$caseLine;
			
			$testTime       		= $testCaseTestingTime{$key};		
			$testTime 			= 'testingTime="'.$testTime.'"';
			
			$lineIndex++;
			
			while ($caseLine =~ s/\s+//) {}
			
			#go trough the hash entry by entry 
			for (my $i = 0; $i < scalar @{$testCaseInfoInit{$key}}; $i++) {
			
				$info 		=  @{$testCaseInfoInit{$key}}[$i]->to_literal;
			
				#without whitespaces
				while ($info 	=~ s/\s+//) {}
			
				#HINT could add more cases 
				#CASE check haspassed
				if ($info =~ /check/  and $info =~ /haspassed/ ) {
                		
					#remove those two keywords in the string	
					$info =~ s/check//;
					$info =~ s/haspassed//;
					
					$info = '<test-case-passed type="file" '.@{$testCaseInfoLine{$key}}[$i].' '.$case.' '.$caseLine.' '.$caseFile.' '.$testTime.'>'.$info.'</test-case-passed>' ;
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
    my $parser     		= XML::LibXML->new();
    my $test;
 
 
    # for all arguments   
    for  (my $i = 0; $i < scalar @_; $i++) {
     
		#** @var $test
		#   take one argument (the content of a file) 
		#*
     
		$test   	= $parser->parse_string($_[$i]);
		 
		foreach my $case ($test->findnodes('/TestLog/TestSuite')) {
  		
				#get the attributes:  	<Testcase  'name' , 'line' , 'file'>   
				my @caseNames      	= $case->findnodes('//TestCase/@name');
				
				
				
				
				my @caseLines		= $case->findnodes('//TestCase/@line'); 
				my @caseFiles       	= $case->findnodes('//TestCase/@file');
		
				my %info;
				my %line;
				my %testTime;
				my %cfiles;
				my %clines;
		
				for (my $j = 0; $j < scalar @caseNames; $j++) {
		
				    @caseNames[$j]			=~ s/name=//;  	#delete name=
				    while (@caseNames[$j]	 	=~ s/"//) {} 	#delete  ""  					  
				    @caseNames[$j] 		     	=~ s/\s//;	#delete  whitespaces
				    #so you got the casename
				    
				    #for every case name look for the infos
				    my $query 				= '//TestCase[@name=\''.@caseNames[$j].'\']/Info';
				    $info{@caseNames[$j]} 	 	= $case->findnodes($query); 	
				    #for every info look for the line attribute
				    $query  		    		.= '/@line';
				    $line{@caseNames[$j]}    		= $case->findnodes($query);	
				    #for every case name look for the testing Time
				    $query 				= '//TestCase[@name=\''.@caseNames[$j].'\']/TestingTime/text()';
				    $testTime{@caseNames[$j]} 		=  $case->findnodes($query);
				    
				    $query 				= ''
				    
				    
				    
			}#end for
			$testCaseContent   .=  builtElements (\%info, \%line, \%testTime, \@caseLines, \@caseFiles);	
		}#end foreach
	}#end for	
		
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
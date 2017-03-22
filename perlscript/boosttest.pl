#!/usr/bin/perl
use strict;

use constant FRAMEWORK 	=> "boosttest"; 

require "dependency.pl";
 
 
sub builtElements {
	
	my %testCaseInfoInit		= %{shift()};
	my %testCaseInfoLine 	 	= %{shift()};
    my @caseLines           	= @{shift()}; 
	my @caseFiles           	= @{shift()}; 

	my @testCaseInfoResult   	= ();
	
	my $info;			 	
    my $case;
	my $caseLine;  
	my $caseFile;
	
	my $lineIndex			 	= 0; 			 
	my $key;
	
	foreach $key (keys %testCaseInfoInit) {
		
			$info			 	= "";			
			$case 				= 'case="'.$key.'"';
			$caseLine			= @caseLines[$lineIndex];
			$caseFile			= @caseFiles[$lineIndex];
			$caseLine			= 'case'.$caseLine;
			$lineIndex++;
			
			while ($caseLine =~ s/\s+//) {}
			
			
			#go trough the hash entry by entry 
			for (my $i = 0; $i < scalar @{$testCaseInfoInit{$key}}; $i++) {
			
				$info =  @{$testCaseInfoInit{$key}}[$i]->to_literal;
				while ($info =~ s/\s+//) {}
			
				#HINT could add more cases 
				#CASE check haspassed
				if ($info =~ /check/  and $info =~ /haspassed/ ) {
                		
					#remove those two keywords in the string	
					$info =~ s/check//;
					$info =~ s/haspassed//;
					
					$info = '<test-case-passed type="file" '.@{$testCaseInfoLine{$key}}[$i].' '.$case.' '.$caseLine.' '.$caseFile.'>'.$info.'</test-case-passed>' ;
					push @testCaseInfoResult, $info;
				}
			}#for end			
	}#foreach end
	return "@testCaseInfoResult";	
}  
  
#parameter 
sub Worker {

  print "Worker out of Boost Test\n";
  
  my $testCaseContent 		= '<?xml version="1.0"?><test-framework name="'.FRAMEWORK.'">';
  my $parser     			= XML::LibXML->new();
  my $test;
 
  for  (my $i = 0; $i < scalar @_; $i++) {
     
		$test   				= $parser->parse_string($_[$i]);

		foreach my $case ($test->findnodes('/TestLog/TestSuite')) {
  		
				my @caseNames      	= $case->findnodes('//TestCase/@name');
				my @caseLines		= $case->findnodes('//TestCase/@line'); 
				my @caseFiles       = $case->findnodes('//TestCase/@file');
		
				my %info;
				my %line;
		
				for (my $j = 0; $j < scalar @caseNames; $j++) {
		
				@caseNames[$j]			 =~ s/name=//;
				while (@caseNames[$j]	 =~ s/"//) {} 	
				@caseNames[$j] 		     =~ s/\s//;			
		
				my $query 				 = '//TestCase[@name=\''.@caseNames[$j].'\']/Info';
				$info{@caseNames[$j]} 	 = $case->findnodes($query); 		 
				$query  		    	.= '/@line';
				$line{@caseNames[$j]}    = $case->findnodes($query);	
			}#end for
			$testCaseContent   			.=  builtElements (\%info, \%line, \@caseLines, \@caseFiles);	
		}#end foreach
	}#end for	
		
  $testCaseContent  		   		.= '</test-framework>';
  
  
	my $file; 
	
	#touching the new file
	if (touch('format.xml')) {   
		#write the testCaseContent to new file 
		$file 			= file('format.xml');
		$file->spew( $testCaseContent  );
	}	
}

#it is only for 
sub returnValue {
return 1;
}
my $returnValueRequire = returnValue();
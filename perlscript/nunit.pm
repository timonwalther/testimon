#** @file nunit.pm
#   This file change the boost xml format in the defined middle format 
#* 

use 		strict;
use 		warnings;

use lib "../perlscript/";

#use constants
use 		constant FRAMEWORK 			=> "nunit"; 
use 		constant ROOTXMLELEMENT 	=> '<?xml version="1.0"?><test-framework name="'.FRAMEWORK.'">';
use 		constant CLOSEROOTELEMENT	=> '</test-framework>';
use 		constant PATHNEWFILE		=> '../uploadfiles/newformats/format.xml';	
use 		constant ROOT				=> 'test-results';

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

    print "Worker out of NUNIT Test\n";
  
    my $result 				= ROOTXMLELEMENT; 
    my $parser     			= XML::LibXML->new();
    
	my $test;
	my $key;
	my $caseName;
	my $results;	
	my $branch;				
	
	
	
	
	my $enviroment;
	my $cultureInfo;
 
 
	my %testResultAttributes;
	my %enviromnetAttributes;
	my %cultureInfoAttributes;
 
 #
 # Schema 
 #  
 # test-suite
 #          results

 #				   test-suite
 #
 #
 
 
 
	my %fileContent;
	%fileContent =  %{shift()};
  
    # for all arguments   
    foreach $key (keys %fileContent) {
     
		#** @var $test
		#   take one argument (the content of a file) 
		#*
				
		$test   				= 	$parser->parse_string($fileContent{$key});
	    
		$results				=	$test->findnodes('//'.ROOT); 
		
		if ($test->findnodes('//'.ROOT.'/@name')) {
			$testResultAttributes{'name'} = $test->findnodes('//'.ROOT.'/@name');		
		} 
		
		if ($test->findnodes('//'.ROOT.'/@total')) {
			$testResultAttributes{'total'} = $test->findnodes('//'.ROOT.'/@total');
		} 
		
		if ($test->findnodes('//'.ROOT.'/@errors')) {
			$testResultAttributes{'errors'} = $test->findnodes('//'.ROOT.'/@errors');
		} 
		
		if ($test->findnodes('//'.ROOT.'/@failures')) {
			$testResultAttributes{'failures'} = $test->findnodes('//'.ROOT.'/@failures');
		} 
		
		if ($test->findnodes('//'.ROOT.'/@not-run')) {
			$testResultAttributes{'notrun'} = $test->findnodes('//'.ROOT.'/@not-run');
		} 
		
		if ($test->findnodes('//'.ROOT.'/@inconclusive')) {
			$testResultAttributes{'inconclusive'} = $test->findnodes('//'.ROOT.'/@inconclusive');
		} 
		
		if ($test->findnodes('//'.ROOT.'/@ignored')) {
			$testResultAttributes{'ignored'} = $test->findnodes('//'.ROOT.'/@ignored');
		} 
		
		if ($test->findnodes('//'.ROOT.'/@skipped')) {
			$testResultAttributes{'skipped'} = $test->findnodes('//'.ROOT.'/@skipped');
		} 
			
		if ($test->findnodes('//'.ROOT.'/@invalid')) {
			$testResultAttributes{'invalid'} = $test->findnodes('//'.ROOT.'/@invalid');
		} 

		if ($test->findnodes('//'.ROOT.'/@date')) {
			$testResultAttributes{'date'} = $test->findnodes('//'.ROOT.'/@date');
		} 

		if ($test->findnodes('//'.ROOT.'/@time')) {
			$testResultAttributes{'time'} = $test->findnodes('//'.ROOT.'/@time');
		} 		
			
		
		if ($test->findnodes('//'.ROOT.'/environment')) {
			
			if ($test->findnodes('//'.ROOT.'/environment/@nunit-version')) {
				$enviromnetAttributes{'nunitversion'}  	= $test->findnodes('//'.ROOT.'/environment/@nunit-version');	
			}
			
			if ($test->findnodes('//'.ROOT.'/environment/@clr-version')) {
				$enviromnetAttributes{'clrversion'} 	= $test->findnodes('//'.ROOT.'/environment/@clr-version');	
			}
			
			if ($test->findnodes('//'.ROOT.'/environment/@os-version')) {
				$enviromnetAttributes{'osversion'}		= $test->findnodes('//'.ROOT.'/environment/@os-version');	
			}
			
			if ($test->findnodes('//'.ROOT.'/environment/@platform')) {
				$enviromnetAttributes{'platform'}		= $test->findnodes('//'.ROOT.'/environment/@platform');	
			}
			
			if ($test->findnodes('//'.ROOT.'/environment/@cwd')) {
				$enviromnetAttributes{'cwd'}			= $test->findnodes('//'.ROOT.'/environment/@cwd');	
			}
			
			if ($test->findnodes('//'.ROOT.'/environment/@machine-name')) {
				$enviromnetAttributes{'machinename'}	= $test->findnodes('//'.ROOT.'/environment/@machine-name');	
			}
			
			if ($test->findnodes('//'.ROOT.'/environment/@user')) {
				$enviromnetAttributes{'user'}			= $test->findnodes('//'.ROOT.'/environment/@user');	
			}

			if ($test->findnodes('//'.ROOT.'/environment/@user-domain')) {
				$enviromnetAttributes{'userdomain'}		= $test->findnodes('//'.ROOT.'/environment/@user-domain');	
			}
			
			
		}
			
		if ($test->findnodes('//'.ROOT.'/culture-info')) {
		
			if ($test->findnodes('//'.ROOT.'/culture-info/@current-uiculture')) {
				$cultureInfoAttributes{'currentuiculture'} 	= $test->findnodes('//'.ROOT.'/culture-info/@current-uiculture');	
			}
			
			if ($test->findnodes('//'.ROOT.'/culture-info/@current-culture')) {
				$cultureInfoAttributes{'currentculture'} 	=  $test->findnodes('//'.ROOT.'/culture-info/@current-culture')."\n";	
			}
		}
		 
		
	
	}	
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
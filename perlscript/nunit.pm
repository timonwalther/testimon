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
use 		constant ROOT				=> 'test-results';

#use constructs 
use 		Switch;
use 		XML::LibXML;

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


#sub GoTrough {
#
#	my $path = shift;
#	my $test = shift; 
#	
#	if ($test->hasChildnodes()) {
#		GoTrough($path.'/test-suite', $test);
#		
#	}	
#	else
#			{
#		
#			if ($test->)	
#
#			}
#}

  
#** @method Worker
#   
#*   
  
sub Worker {

    print "Worker out of NUNIT Test\n";
  
    my $result 				= ROOTXMLELEMENT; 
    my $parser     			= XML::LibXML->new();
    
	my $test_str;
	my $test_fil;
	my $key;
	my $caseName;
	my $results;	
	my $branch;				
	
	
	
	
	my $enviroment;
	my $cultureInfo;
	my $node;
	my $parentNode;
    
 
	my %testResultAttributes;
	my %enviromnetAttributes;
	my %cultureInfoAttributes;
	my %XmlTree;
	my @XmlStructure;
 
 
 #
 # Schema 
 #  
 # test-suite
 #          results

 #				   test-suite
 #
 
	my 	%fileContent;
		%fileContent 	=  	%{shift()};

	my 	$dir;
		$dir 			= 	shift;
	
			
    # for all arguments   
    foreach $key (keys %fileContent) {
     
		#** @var $test
		#   take one argument (the content of a file) 
		#*
			
        $test_fil 	=	$parser->parse_file($dir.'\\'.$key);			
		$test_str  	= 	$parser->parse_string($fileContent{$key});
	   
	   
		$results	=	$test_str->findnodes('//'.ROOT); 
		
		if ($test_str->findnodes('//'.ROOT.'/@name')) {
			$testResultAttributes{'name'} = $test_str->findnodes('//'.ROOT.'/@name');		
		} 
		
		if ($test_str->findnodes('//'.ROOT.'/@total')) {
			$testResultAttributes{'total'} = $test_str->findnodes('//'.ROOT.'/@total');
		} 
		
		if ($test_str->findnodes('//'.ROOT.'/@errors')) {
			$testResultAttributes{'errors'} = $test_str->findnodes('//'.ROOT.'/@errors');
		} 
		
		if ($test_str->findnodes('//'.ROOT.'/@failures')) {
			$testResultAttributes{'failures'} = $test_str->findnodes('//'.ROOT.'/@failures');
		} 
		
		if ($test_str->findnodes('//'.ROOT.'/@not-run')) {
			$testResultAttributes{'notrun'} = $test_str->findnodes('//'.ROOT.'/@not-run');
		} 
		
		if ($test_str->findnodes('//'.ROOT.'/@inconclusive')) {
			$testResultAttributes{'inconclusive'} = $test_str->findnodes('//'.ROOT.'/@inconclusive');
		} 
		
		if ($test_str->findnodes('//'.ROOT.'/@ignored')) {
			$testResultAttributes{'ignored'} = $test_str->findnodes('//'.ROOT.'/@ignored');
		} 
		
		if ($test_str->findnodes('//'.ROOT.'/@skipped')) {
			$testResultAttributes{'skipped'} = $test_str->findnodes('//'.ROOT.'/@skipped');
		} 
			
		if ($test_str->findnodes('//'.ROOT.'/@invalid')) {
			$testResultAttributes{'invalid'} = $test_str->findnodes('//'.ROOT.'/@invalid');
		} 

		if ($test_str->findnodes('//'.ROOT.'/@date')) {
			$testResultAttributes{'date'} = $test_str->findnodes('//'.ROOT.'/@date');
		} 

		if ($test_str->findnodes('//'.ROOT.'/@time')) {
			$testResultAttributes{'time'} = $test_str->findnodes('//'.ROOT.'/@time');
		} 		
			
		
		if ($test_str->findnodes('//'.ROOT.'/environment')) {
			
			if ($test_str->findnodes('//'.ROOT.'/environment/@nunit-version')) {
				$enviromnetAttributes{'nunitversion'}  	= $test_str->findnodes('//'.ROOT.'/environment/@nunit-version');	
			}
			
			if ($test_str->findnodes('//'.ROOT.'/environment/@clr-version')) {
				$enviromnetAttributes{'clrversion'} 	= $test_str->findnodes('//'.ROOT.'/environment/@clr-version');	
			}
			
			if ($test_str->findnodes('//'.ROOT.'/environment/@os-version')) {
				$enviromnetAttributes{'osversion'}		= $test_str->findnodes('//'.ROOT.'/environment/@os-version');	
			}
			
			if ($test_str->findnodes('//'.ROOT.'/environment/@platform')) {
				$enviromnetAttributes{'platform'}		= $test_str->findnodes('//'.ROOT.'/environment/@platform');	
			}
			
			if ($test_str->findnodes('//'.ROOT.'/environment/@cwd')) {
				$enviromnetAttributes{'cwd'}			= $test_str->findnodes('//'.ROOT.'/environment/@cwd');	
			}
			
			if ($test_str->findnodes('//'.ROOT.'/environment/@machine-name')) {
				$enviromnetAttributes{'machinename'}	= $test_str->findnodes('//'.ROOT.'/environment/@machine-name');	
			}
			
			if ($test_str->findnodes('//'.ROOT.'/environment/@user')) {
				$enviromnetAttributes{'user'}			= $test_str->findnodes('//'.ROOT.'/environment/@user');	
			}

			if ($test_str->findnodes('//'.ROOT.'/environment/@user-domain')) {
				$enviromnetAttributes{'userdomain'}		= $test_str->findnodes('//'.ROOT.'/environment/@user-domain');	
			}
		}
			
		if ($test_str->findnodes('//'.ROOT.'/culture-info')) {
		
			if ($test_str->findnodes('//'.ROOT.'/culture-info/@current-uiculture')) {
				$cultureInfoAttributes{'currentuiculture'} 	= $test_str->findnodes('//'.ROOT.'/culture-info/@current-uiculture');	
			}
			
			if ($test_str->findnodes('//'.ROOT.'/culture-info/@current-culture')) {
				$cultureInfoAttributes{'currentculture'} 	=  $test_str->findnodes('//'.ROOT.'/culture-info/@current-culture')."\n";	
			}
		}
		
		
		
		my $index = 0;
		

		
		while ($test_str->hasChildNodes()) {
		
			$node = $test_str->firstChild;
				
		
		
		}	
		
		
		
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
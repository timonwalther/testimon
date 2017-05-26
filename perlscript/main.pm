use strict;
use warnings;

use constant UPLOADDIR  => "newUploads";
use constant UPLOADFILE => "uploadlog.json";

require "dependency.pm";
use 	Switch;

#** @file main.pl 
#
#*

	my  $dir 				=  dir(UPLOADDIR);
	my  $uploadfile     	=  "";
	my  $json_hash 			=  "";
	
	my  @files     			= ();
	my 	%fileContent; 		
	
	opendir (DIR, $dir) or die ("There exist no UPLOADDIR!\n");
	
	#fill the array with file names
	while (my $file = readdir(DIR)) {   
			if (!(-e $file) and $file ne UPLOADFILE) { 			#file exist    
				push @files, $file; 
			}	
        }
	closedir(DIR);
	
    if (-e $dir->file(UPLOADFILE)) {
		$uploadfile = $dir->file(UPLOADFILE);
		$json_hash  = json_file_to_perl($uploadfile) or die ("Isn't valid!\n");	
	}
	else {
		die("Exist no upload log file, can\n");
	} 
	 
	#get out of the json file the name of testframework (to know what's require) 
	my $framework =   $json_hash->{testframework};
	 
    switch ($framework) {       		   
		    case "boosttest" 
				{ 
				require "boosttest.pm";	
				} 
				
			case "junit" 
				{ 
				require "junit.pm";
				} 	
			case "catch"
				{
				require "catch.pm";
				}
			case "Jasmine"
				{
				require "jasmine.pl";
				}
			case "GoogleTest"
				{
				require "googletest.pm";
				}
			else 
				{		
				print "Nothing is correct, damn!";
				}
								
		}
			
	my $content 	= "";
	
	foreach my $fil (@files) {
			$content = $dir->file($fil)->slurp(); #it works only with this temp 
			$fileContent {$fil} =  $content			
	}	
	#this implemented the method in depends 
	Worker (\%fileContent);
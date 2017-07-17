package StringHelper; 
#use bytes;
 
	#delete whitespaces of a value
	sub withoutWhitespaces  {

		my $value 		= shift;
		while ($value 	=~ s/\s+//) {}
		return $value;
	}
	
	#delete keywords
	sub withoutCheckedPassed {
	
		my $value		= withoutWhitespaces (shift);
		
		$value 			=~ s/check//;
		$value 			=~ s/haspassed//;	
	
		return $value;
	}
	
	sub getBranch {
	
		my $value 	= 	withoutWhitespaces (shift);
		$value 		=~ 	s/TestSuite//;
		return $value;
	}

	sub replaceSign {
	
		#print "There\n";
	
		my $word 		= shift;
		my $oldSign 	= shift;
		my $newSign 	= shift;
	
		for (my $i = 0; $i < length($word); $i++) {
			
			if (substr($word, $i, $i ) eq $oldSign ) {
				substr($word, $i, $i ) = $newSign; 
				print $word."\n";
			} 
		}#end for
	return $word;
	}
	
1;	
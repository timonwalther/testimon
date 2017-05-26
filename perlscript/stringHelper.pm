package StringHelper; 
 
	#delete whitespaces of a value
	sub withoutWhitespaces  {

		my $value 		= shift;
		while ($value 	=~ s/\s+//) {}
		return $value;
	}
	
	#delete keywords
	sub withoutCheckedPassed {
	
		my $value		= shift;
		
		$value 			=~ s/check//;
		$value 			=~ s/haspassed//;	
	
		return $value;
	}
	
1;	
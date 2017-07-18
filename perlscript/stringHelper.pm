package StringHelper; 
#use bytes;
 
	#delete whitespaces of a value
	sub withoutWhitespaces  {

		my $value 		= shift;
		while ($value 	=~ s/\s+//) {}
		return $value;
	}
	
	#replace a special sign trough an another one
	sub replaceSign {
	
		my $word 		= shift;
		my $oldSign 	= shift;
		my $newSign 	= shift;
	  
		for (my $i = 0; $i < length($word); $i++) {	
			
			if (substr($word, $i, $i + 1 ) =~ s/$oldSign// ) {
				substr($word, $i, $i + 1 ) = $newSign; 
			}
		}#end for
	return $word;
	}
	
1;	
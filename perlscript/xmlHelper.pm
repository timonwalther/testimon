use Switch;

package XMLHelper;

	#build an attribute with value and name 
	sub buildAttribute {

		my $attrName 		= shift();
		my $attrValue		= shift();
		
	return $attrName.'="'.$attrValue.'"';  	
	}#end buildAttribute
	
	#build special element for open and closed tags
	sub getFileElement {  

		my $result 		= shift();
		my $type 		= shift();
		
		if ($result =~ /.xml/) {
			#delete dot and suffix
			$result =~ s/.xml//;
			
			if ($type eq "close") {
				return '</'.$result.'>';	
			}
			
			if ($type eq "open") {
				return '<'.$result.' type="file">';
			}
		}		
	}#end getFileElement
	
	#get only the value without any quotes 
	sub getOnlyValueOfAttr {

		my $attrName 		= shift;
		my $attrValue 		= shift;
 
		$attrValue 			=~ s/$attrName=//; 			#delete attributename	
		while ($attrValue 	=~ s/"//) {} 				#delete  "" 
		$attrValue 			=~ s/\s//;					#delete  whitespaces
	
		return $attrValue ;
	}# getOnlyValueOfAttr
	
	#method which sends 
	sub getXPathQueryBoosttest {

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
	}#end getXPathQueryBoosttest	
1;	
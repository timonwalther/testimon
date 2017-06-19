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
	
	
	#this function returns which is 
	sub WhoIS {
	
		my $type		= shift->nodeType;
	
		switch ($type) {
			case 1 {
				return XML_ELEMENT_NODE;
			}
			case 2 {
				return XML_ATTRIBUTE_NODE;	
			}
			case 3 {
				return XML_TEXT_NODE;
			}
			case 4 {
				return XML_CDATA_SECTION_NODE;
			}
			case 5 {
				return XML_ENTITY_REF_NODE; 
			}
			case 6 {
				return XML_ENTITY_NODE;
			}
			case 7 {
				return XML_PI_NODE;
			}
			case 8 {
				return XML_COMMENT_NODE;
			}
			case 9 {
				return XML_DOCUMENT_NODE;
			}
			case 10 {
				return XML_DOCUMENT_TYPE_NODE;
			}
			case 11 {
				return XML_DOCUMENT_FRAG_NODE;
			}
			case 12 {
				return XML_NOTATION_NODE;
			}
			case 13 {
				return XML_HTML_DOCUMENT_NODE;
			}
			case 14 {
				return XML_DTD_NODE;
			}
			case 15 {
				return XML_ELEMENT_DECL;
			}
			case 16 {
				return XML_ATTRIBUTE_DECL;
			}
			case 17 {
				return XML_ENTITY_DECL;
			}
			case 18 {
				return XML_NAMESPACE_DECL;
			}
			case 19 {
				return XML_XINCLUDE_START;
			}
			case 20 {
				return XML_XINCLUDE_END;
			}		
		}
			
	} #end WhoIs
	
	sub getStructWithAttributes () {
	
	
	
	}
	
	
	
1;	
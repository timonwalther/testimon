use strict;
use warnings;

use Switch;
use XML::DOM;
use XML::DOM::NodeList;

require "dependency.pm";


package XMLHelper;

	my %attributeList;

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
	
	#https://stackoverflow.com/questions/8733808/perl-parsing-using-sax
	
	
	sub allAttributes {
	
	my $elem 	= shift;
	my @attributes;	

	 #first attribute	
	 if (WhoIS($elem) eq 'XML_ELEMENT_NODE' ) {

		if ($elem->hasAttributes()) {  
			@attributes = $elem->attributes();
			#print $attributes[0]->value."\n";
			return @attributes;
		}

	 }
	 return undef $elem;
	}#end all attributes sub
	
	
	#sub Wrap the nextNodeRek function
	sub nextNode {
		my $node = shift;
		if (WhoIS($node) eq 'XML_DOCUMENT_NODE' and  $node->firstChild) {
			$node = $node->firstChild;
		}
		return nextNodeRek ($node, $node);
	}
	
	#get node in xml tree
	#get all first 
	sub nextNodeRek {
	
	my $node 		= shift;
	my $parentNode 	= shift;
	
		#abortion condition
		if (WhoIS($node) eq 'XML_ELEMENT_NODE' and not ($node->isEqual($parentNode))) {
					return $node;
		}	
	
		if (WhoIS($node) ne 'XML_ELEMENT_NODE' or $node->isEqual($parentNode)) {
			
			if ($node->hasChildNodes() || $node->nextSibling()) {
			
				if ($node->nextSibling() and not $node->firstChild){
					return nextNodeRek($node->nextSibling(), $node->getParentNode());  
				}	
			
				if ($node->firstChild) {
					return nextNodeRek($node->firstChild, $node);	
				} 
				
				if (WhoIS($node) eq 'XML_ELEMENT_NODE') {
					return $node;
				}		
			}#end if
		}#end if started with document node
		
		#if there is no node at all 
		if (WhoIS($node) ne defined ){

					if ($node->parentNode->nextSibling() and $parentNode->parentNode) {
						return nextNodeRek($node->parentNode->nextSibling(), $parentNode); 	
					}
					
					if ($parentNode->parentNode->nextSibling()) {
						return nextNodeRek($parentNode->parentNode->nextSibling(), $parentNode->parentNode->parentNode); 
					} 
					else {
						return undef $node;
					}
		}	
	}#end sub nextNode
	
	
	#this function returns which is 
	sub WhoIS {
	
		my $type		= shift;
		
		if ($type) {	
			
			$type		= $type->nodeType;
			
			switch ($type) {
				case 1 {
					return 'XML_ELEMENT_NODE';
				}
				case 2 {
					return 'XML_ATTRIBUTE_NODE';	
				}
				case 3 {
					return 'XML_TEXT_NODE';
				}
				case 4 {
					return 'XML_CDATA_SECTION_NODE';
				}
				case 5 {
					return 'XML_ENTITY_REF_NODE'; 
				}
				case 6 {
					return 'XML_ENTITY_NODE';
				}
				case 7 {
					return 'XML_PI_NODE';
				}
				case 8 {
					return 'XML_COMMENT_NODE';
				}
				case 9 {
					return 'XML_DOCUMENT_NODE';
				}
				case 10 {
					return 'XML_DOCUMENT_TYPE_NODE';
				}
				case 11 {
					return 'XML_DOCUMENT_FRAG_NODE';
				}
				case 12 {
					return 'XML_NOTATION_NODE';
				}
				case 13 {
					return 'XML_HTML_DOCUMENT_NODE';
				}
				case 14 {
					return 'XML_DTD_NODE';
				}
				case 15 {
					return 'XML_ELEMENT_DECL';
				}
				case 16 {
					return 'XML_ATTRIBUTE_DECL';
				}
				case 17 {
					return 'XML_ENTITY_DECL';
				}
				case 18 {
					return 'XML_NAMESPACE_DECL';
				}
				case 19 {
					return 'XML_XINCLUDE_START';
				}
				case 20 {
					return 'XML_XINCLUDE_END';
				}	
				else {	
					return undef $type;
				}
			}
		}		
	} #end WhoIs
	
	sub getStructWithAttributes () {
	
	}
	
	
	
	
1;	
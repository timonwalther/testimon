	//used in   ->   "mixedlibs/bootstrap-fileinput/js/fileinput.js"
	

	//addendum M&W
    var Iterator, GUIUpTest, TESTTree;

    Iterator  = function () {

    this.makeIterator = function (array){
            var nextIndex = 0;
            return {
                next: function(){
                    return nextIndex < array.length ?
                        {value: array[nextIndex++], done: false} :
                        {done: true};
                        }
                    }
            } //end makeIterator
    }//Iterator 

    TESTTree = new function () {

        this.topInfos           =   []; 
        this.caseInfos          =   [];    //is a struct which is composed of (1) testingTime (2) caseName (3) caseLine
        this.Infos              =   [];
		
		
		this.ToggleScriptOne	 	= '$("a").click(function (eventObject ) { var elem = $(this); if (elem.attr("href")';
		this.ToggleScriptDefault 	= 'eventObject.preventDefault();';	

        this.buildFirstLevel = function (root, itemsLen) {

            //arrays
            var cases, infos;               

            //single vars
            var nodeFile, nodeCase, parent, content, caseName, fileName, passed, id, tablehead;

             tablehead              = '<thead><tr><th>Message</th><th>Line</th></tr></thead><tbody>';	
            nodeFile                = '';  
            nodeCase                = '';
            content                 = '';
            fileName                = '';  
			id 						= '';
            parent                  = root;
            passed                  = true;
            

            cases                   = [];
            infos                   = [];

            for (var i=0; i < itemsLen; i++ ) {

                    nodeFile			    = root.childNodes[i];  

                    if (nodeFile.hasAttributes) {   
    
                        if (nodeFile.parentNode != parent.nodeName) {
                            parent = nodeFile;     

                         }   
                            //for every file element look for the testcases and testcaseinfos
                            for (var j= 0; j < nodeFile.childNodes.length; j++) {

                                nodeCase    =  nodeFile.childNodes[j]; 
                                fileName    =  nodeFile.nodeName;

                                if (nodeCase.hasAttributes) {
                          
                                   if (caseName != nodeCase.getAttribute("case")) {

                                        //new caseName and not the first one, then close table element
                                        j > 0 ?  content += '</tbody></table>': content = content;  

                                        caseName = nodeCase.getAttribute("case");

                                        //fill the array of testcases        
                                        cases.push ({name: caseName, testingTime: nodeCase.getAttribute("testingTime"), line: nodeCase.getAttribute("caseline") }); 

										id 		= 	fileName + caseName;

                                        content     += '<a href="' + id + '">';
                                        content     += '<strong>Test-Case:</strong> ' + caseName + '- with time ' + nodeCase.getAttribute("testingTime") + 'ms -  in line ' 
												    + nodeCase.getAttribute("caseline") + '</a><br/>';  
												
                                        content     += '<script>' + TESTTree.ToggleScriptOne + '.match(/'+ id +'/)) {' + TESTTree.ToggleScriptDefault 
                                                    + 'if ($("#tab'+ id +'").is(":visible")) { $("#tab'+ id +'").hide();}'
                                                    + 'else { $("#tab'+ id +'").show();}   }}); </script>'
                                                    + '<table id="tab'+ id +'" class="table" hidden>' + tablehead; 
                                    }

                                    //fill the array of elements whose are maybe "test-case-passed" or "test-case-not-passed"    
                                    infos.push ({info: nodeCase.nodeName});    
                                    nodeCase.nodeName != "test-case-passed" ? passed = false : passed = passed; 

                                    if (passed)      
                                        content      += '<tr class="success"><td>' + nodeCase.childNodes[0].nodeValue + '</td> <td>'+ nodeCase.getAttribute("line") +'</td></tr>';    
                                    else 
                                        content     +=  '<tr class="danger"><td>' + nodeCase.childNodes[0].nodeValue + '</td> <td>'+ nodeCase.getAttribute("line") +'</td></tr>';             
                                
                                }   
                            }//end inner for

                            content += '</tbody></table>';
                            TESTTree.Infos.push ({name: nodeFile.nodeName, case: cases, info: infos, con: content, error: false, pass: passed});
                    } //end if

                    //unset the content var 
                    content = '';

			    } //end for
        }//end buildFirstLevel      

    } //end TESTTree object 

	GUIUpTest = new function () {
				
				//path to perl generate format.xml file			
				this.formatFilePath     = 'uploadfiles/newformats/format.xml';
				
				//view div containers
				this.firstUploadDiv 	= '#uploadContainer';	
				this.secondUploadDiv	= '#processUpload';
				
				this.testFrameworkName 	= ''; 
				this.testResult 		= ''; 
				
				//default badge values
				this.badgeSubject 		= '<SUBJECT';
				this.badgeStatus		= '<STATUS>';
				this.badgeColor			= '<COLOR>';
				this.firstBadgePart 	= '<img src="https://img.shields.io/badge/';
                this.lastBadgePart      = '.svg" alt="test shield" />';
				
				//view elements
				this.headline			= ''; 
				this.appendment			= ''; 
				

                this.getColor           = function (endLen, wholeLen) {

                    var quot, proof;
                    
                    quot            = (wholeLen / endLen) * 100;   
                    proof           = (quot == 100);

                    switch (proof) {

                            case true : return "red" ;

                            case false : proof = (quot < 100 && quot >= 60);

                            case true: return "orange";

                            case false: proof =  (quot < 60 && quot >= 30 );

                            case true: return "yellow";

                            case false: proof = (quot < 30 && quot >= 10 );

                            case true: return "yellowgreen";        

                            default: return "green";
                    }
                } //getColor


                //build the badge shield     
				this.buildBadge 		= function (array) {
					
                   var passedLength, tmp;

                        passedLength = array.length;

                        while (passedLength > 0 && array.pass != false) 
                                passedLength--; 

                         GUIUpTest.badgeSubject 	    = "test";           

                            //every case is successfully passed
					        if (passedLength == 0) {       
						
						        GUIUpTest.badgeStatus  	    = "passed";
						        GUIUpTest.badgeColor		= "brightgreen";
                                GUIUpTest.lastBadgePart     = '.svg" alt="test passed shield" />';     
                            }
                            //some cases are not passed	
                            else {
                                GUIUpTest.badgeStatus  	    = "not passed";    
                                GUIUpTest.badgeColor        = GUIUpTest.getColor(passedLength, array.length);      
                                GUIUpTest.lastBadgePart     = '.svg" alt="test not passed shield" />';      
                            }

                            //build badge
					        tmp =   GUIUpTest.firstBadgePart 
						    + 			GUIUpTest.badgeSubject 
							+ '-' + 	GUIUpTest.badgeStatus 
							+ '-' + 	GUIUpTest.badgeColor
						    +           GUIUpTest.lastBadgePart;	
					
					    return tmp;
				}
				

				//http://stackoverflow.com/questions/4249030/load-javascript-async-then-check-dom-loaded-before-executing-callback
				this.readXmlFormatFile = function ()
				{
					
					var rawFile,xmlDoc, parser;

					rawFile = new XMLHttpRequest();
					
					//false -> synchron request  - true asynchron request
                    //https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/Synchronous_and_Asynchronous_Requests
					rawFile.open("GET", this.formatFilePath, false);
					rawFile.onreadystatechange = function (e)
					{
						
						if(rawFile.readyState === 4 && (rawFile.status === 200 || rawFile.status == 0))
						{		

								if (window.DOMParser)
								{
									parser 				= new DOMParser();
									xmlDoc 				= parser.parseFromString(rawFile.responseText, "text/xml");	
    
								}
								else // Internet Explorer
								{
									xmlDoc 				= new ActiveXObject("Microsoft.XMLDOM");
									xmlDoc.async 		= true;
									xmlDoc.loadXML(rawFile.responseText);
								}
                                    
									var temp, id;
									temp = ''; 
									id = '';
                                    //name of the testframework
                                    GUIUpTest.testFrameworkName	        = xmlDoc.getElementsByTagName("test-framework")[0].getAttribute("name");                        
                                    
                                    //got first element
                                    TESTTree.buildFirstLevel(xmlDoc.getElementsByTagName("test-framework")[0],xmlDoc.getElementsByTagName("test-framework")[0].childNodes.length);
                                           
									  for (var i = 0; i < TESTTree.Infos.length; i++) {
									
                                        temp += '<h4> File: ' + TESTTree.Infos[i].name + '</h4>'+ TESTTree.Infos[i].con +'<br/>';   	
									} 	      
										   
									GUIUpTest.testResult    += '<div style="background-color: #F5F5F5;"><table class="table"><thead>'	
																+'<tr><th>BUILD </th>'
																+'<th> BRANCH </th>' 
																+'<th> SUCCESS</th>'
																+'<th> COVERAGE </th>'
																+'<th> COMMIT </th>'
																+'<th> TESTFRAMEWORK</th>'
																+'<th> TYPE   </th>'
																+'<th> DATE </th>'
																+'<th> VIA </th></tr></thead>';
																
																
									GUIUpTest.testResult 	+= '<tbody><tr><td></td>'
																+ '<td></td>'
																+ '<td>' + GUIUpTest.buildBadge(TESTTree.Infos)  + '</td>'  //produce a shield  
																+ '<td></td>'
																+ '<td></td>'
																+ '<td> Framework: ' + GUIUpTest.testFrameworkName +'</td>'
																+ '<td> push </td>'
																+ '<td>'+new Date()+'</td>'
																+ '<td class="danger">Upload - Dirty</td></tr></tbody></table>';
																                                  
									id = "id";

        
                                    GUIUpTest.testResult    +=  '<script>'+ TESTTree.ToggleScriptOne + '.match(/'+ id +'/)) {' + TESTTree.ToggleScriptDefault  
															+   'if ( $("#di'+ id +'").is(":visible")) { $("#di'+ id +'").hide();}'
															+   'else { $("#di'+ id +'").show();}}}); </script>'
															+   '<a href="#'+ id +'">+</a> More Information <div id="di'+ id +'" hidden>' + temp + '</div></div>';  

						}
                        else {
                                    console.error(rawFile.statusText);          
                        }
					};
                    rawFile.onerror = function (e) {
                        console.error(rawFile.statusText);
                    };    

					rawFile.send(null);
				}//end readXmlFormatFile
				
			
				this.showUploadResult = function()  { 
						
                    //read format xml file
					this.readXmlFormatFile();    
					this.headline           = '<h3>Show your test result</h3>';	
						
					//change view divs	
					$(this.firstUploadDiv).hide();
					$(this.secondUploadDiv).show();
				
					//build the appendment	
				    this.appendment 		+=  this.headline +	this.testResult;
					
					//append result to view
					$(this.secondUploadDiv).append(this.appendment);
				}

	};
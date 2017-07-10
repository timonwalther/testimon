	//used in   ->   "mixedlibs/bootstrap-fileinput/js/fileinput.js"
	
	//addendum M&W
    var Iterator, GUIUpTest, TESTTree, ToggleScriptBuilder;

    ToggleScriptBuilder = new function () {

        this.ToggleScriptOne	 	= '$("a").click(function (eventObject ) { var elem = $(this); if (elem.attr("href")';
	    this.ToggleScriptDefault 	= 'eventObject.preventDefault();';	    

        this.makeScript = function (id, type)  { 

        return  '<script>'          + ToggleScriptBuilder.ToggleScriptOne 
                                    + '.match(/'+ id +'/)) {' 
                                    + ToggleScriptBuilder.ToggleScriptDefault 
                                    + 'if ($("#'+ type + id +'").is(":visible")) { $("#'+ type+ id +'").hide();}'
                                    + 'else { $("#'+ type + id +'").show();}   }}); </script>';                                                         
        } // makeScript method    
    } //ToggleScriptBuilder


    Iterator  = new function () {

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

	
	TESTTree1  = new function () {
		
		
		
		
		
		
	}

	
	
    TESTTree = new function () {

        this.topInfos           =   []; 
        this.caseInfos          =   [];    //is a struct which is composed of (1) testingTime (2) caseName (3) caseLine
        this.Infos              =   [];
		
        //constants
		this.ToggleScriptOne	 	= '$("a").click(function (eventObject ) { var elem = $(this); if (elem.attr("href")';
		this.ToggleScriptDefault 	= 'eventObject.preventDefault();';	
        this.InfoTableHead          = '<thead><tr><th>Message</th><th>Line</th></tr></thead><tbody>';

        this.buildCaseRow           = function (id ,caseName, testingTime, caseline ) {

            if (typeof(id) != undefined && typeof (caseName) != undefined && typeof(testingTime) != undefined && typeof(caseline) != undefined) {
                return '<div style="margin-left:50px;"><a href="' + id + '"><strong>Test-Case:</strong>' 
                        + caseName      + ' - with time ' 
                        + testingTime   + ' ms -  in line ' 
				        + caseline      + '</a></div>';     
            }
            else 
                return 'UNDEFINED TEST CASE VALUES';   
        }//end buildCaseRow

        this.buildView              = function (root, itemsLen) {

            //arrays
            var cases, infos;               

            //single vars
            var nodeFile, nodeCase, parent, ViewContent, caseName, fileName, passed, id;
	
            nodeFile                = '';  
            nodeCase                = '';
            ViewContent             = '';
            fileName                = '';  
			id 						= '';
            parent                  = root;
            passed                  = true;
            
            cases                   = [];
            infos                   = [];

            for (var i=0; i < itemsLen; i++ ) {

                    nodeCase	    = root.childNodes[i]; 

                    if (nodeCase.hasAttributes) {
     
                        infos.push ({info: nodeCase.nodeName});    
                        nodeCase.getAttribute("result") != "success" ? passed = false : passed = passed; 

                                    if (passed) {
                                        ViewContent         += '<tr class="success"><td>' + nodeCase.getAttribute("name") + '</td> <td>'+ nodeCase.getAttribute("line") +'</td></tr>'; 
                                    }         
                                    else {
                                        ViewContent         += '<tr class="danger"><td>' + nodeCase.getAttribute("name") + '</td> <td>'+ nodeCase.getAttribute("line") +'</td></tr>';             
                                    }
                          

                            content += '</tbody></table>';
                            TESTTree.Infos.push ({name: nodeCase.getAttribute("name"), case: cases, info: infos, view: ViewContent, error: false, pass: passed});
                    } //end if
                    //unset the ViewContent var 
                    ViewContent = '';
                }//end for            
        }//end buildFirstLevel      

    } //end TESTTree object 

	GUIUpTest = new function () {

                //constants
                this.TestOutputTableHead= '<div style="background-color: #F5F5F5;"><table class="table"><thead>'	
										+'<tr><th>BUILD </th>'
										+'<th> BRANCH </th>' 
										+'<th> SUCCESS</th>'
										+'<th> COVERAGE </th>'
										+'<th> COMMIT </th>'
										+'<th> TESTFRAMEWORK</th>'
										+'<th> TYPE   </th>'
										+'<th> DATE </th>'
										+'<th> VIA </th></tr></thead>';

				
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
			

                this.browserCheckXML   = function (rawFile) {

                    var parser, xmlDoc;    

                    if (window.DOMParser)   {
									parser 				= new DOMParser();
									xmlDoc 				= parser.parseFromString(rawFile.responseText, "text/xml");	
					}
					else                    {  // Internet Explorer
									xmlDoc 				= new ActiveXObject("Microsoft.XMLDOM");  
									xmlDoc.async 		= true;
									xmlDoc.loadXML(rawFile.responseText);
					}            

                   return xmlDoc;         
                }//end browserCheckXML

                this.getColor           = function (endLen, wholeLen) {

                    var quot, proof;
                    
                    quot            = (endLen * 1.0 / wholeLen) * 100;   
                    proof           = (quot == 0);

                    switch (proof) {

                            case true : return "red" ;
                            case false : proof = (quot >= 10 && quot < 30);
                            case true: return "orange";
                            case false: proof =  (quot < 60 && quot >= 30 );
                            case true: return "yellow";
                            case false: proof = (quot > 60  && quot <= 95 );
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
				this.readXmlFormatFile  = function ()
				{
					
					var rawFile, xmlDoc;

					rawFile             = new XMLHttpRequest();
					
					//false -> synchron request  - true asynchron request
                    //https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/Synchronous_and_Asynchronous_Requests
					rawFile.open("GET", this.formatFilePath, false);
					rawFile.onreadystatechange = function (e)
					{
						
						if(rawFile.readyState === 4 && (rawFile.status === 200 || rawFile.status == 0))
						{		
                                    xmlDoc              = GUIUpTest.browserCheckXML(rawFile); 

									var temp, id, infoIterator, currentElem;
									temp                = ''; 
									id                  = '';
                                    //name of the testframework
                                    GUIUpTest.testFrameworkName	        = xmlDoc.getElementsByTagName("test-framework")[0].getAttribute("name");                        
                                    
                                    //got first element
                                    TESTTree.buildView(xmlDoc.getElementsByTagName("test-framework")[0], xmlDoc.getElementsByTagName("test-framework")[0].childNodes.length);

                                    infoIterator = Iterator.makeIterator(TESTTree.Infos);
                                    currentElem  = infoIterator.next();

                                        while (!currentElem.done) {
                                            alert(currentElem.value);
                                            temp        += '<h4 style="margin-left:15px;"> Test-case: ' + currentElem.value.name + '</h4>'+ currentElem.value.view +'<br/>';
                                            currentElem = infoIterator.next();
                                        }

                                    infoIterator = null;
                            				   
									GUIUpTest.testResult    += GUIUpTest.TestOutputTableHead;
																								
									GUIUpTest.testResult 	+= '<tbody><tr><td></td>'
																+ '<td></td>'
																+ '<td>'                +   GUIUpTest.buildBadge(TESTTree.Infos)  + '</td>'  //produce a shield  
																+ '<td></td>'
																+ '<td></td>'
																+ '<td> Framework: '    +   GUIUpTest.testFrameworkName +'</td>'
																+ '<td> push </td>'
																+ '<td>'                +   new Date()  +   '</td>'
																+ '<td class="danger">Upload - Dirty</td></tr></tbody></table>';
																                                  
									id = "id"; //this is only for testing "id" isn't the final solution
        
                                    GUIUpTest.testResult    +=  ToggleScriptBuilder.makeScript(id, 'di') 
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



var junitReporter = new jasmineReporters.JUnitXmlReporter({
    savePath: 'TestReport',
    consolidateAll: false
});

jasmine.getEnv().addReporter(junitReporter);

describe("GUIUpTest", function() {
    //var guitest;
 
    //This will be called before running each spec
    //beforeEach(function() {
    //    guitest = GUIUpTest;
    //});
	
	//http://stackoverflow.com/questions/28580540/how-to-spy-on-anonymous-function-using-jasmine
 
    describe("perform different methods to build new gui", function(){
         
        //Spec for sum operation
        it("getColor method is able to get the right color", function() {
           
            //arguments endLen, wholeLen
            expect(GUIUpTest.getColor(0,52)).toEqual("orange");

            expect(GUIUpTest.getColor(52,52)).toEqual("red");

        }); 
    });
});


/*
describe("GUIUpTest", function() {
    //var guitest;
 
    //This will be called before running each spec
    //beforeEach(function() {
    //    guitest = GUIUpTest;
    //});
	
	//http://stackoverflow.com/questions/28580540/how-to-spy-on-anonymous-function-using-jasmine
 
    describe("perform different methods to build new gui", function(){
         
        //Spec for sum operation
        it("should be able to get the right color", function() {
           
            
            expect(GUIUpTest.getColor(52,0)).toEqual("orange");

            expect(GUIUpTest.getColor(0,0)).toEqual("orange");

        }); 
    });
});

*/
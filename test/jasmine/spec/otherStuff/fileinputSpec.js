describe("GUIUpTest", function() {
    //var guitest;
 
    //This will be called before running each spec
    beforeEach(function() {
        guitest = GUIUpTest;
    });
	
	//http://stackoverflow.com/questions/28580540/how-to-spy-on-anonymous-function-using-jasmine
 
    describe("perform different methods to build new gui", function(){
         
		function (factory)  
		 
		 
        //Spec for sum operation
        it("should be able to get the right color", function() {
            expect(GUIUpTest.getColor(52,0)).toEqual("red");
        }).toThrowError(Error);;
         
    });
});
<!DOCTYPE html>
<html lang="en" ng-app="myApp">
  <head>
    <meta charset="utf-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width,initial-scale=1">
          <title>Testosteron</title>
          <!-- Bootstrap -->
		  
			<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">

			<!-- Optional theme -->
			<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">
		  
			<!--link href="css/bootstrap.min.css" rel="stylesheet"-->
            <link href="css/custom.css" rel="stylesheet">
			<link href="css/toaster.css" rel="stylesheet">
			  
			<link href="mixedlibs/bootstrap-fileinput/css/fileinput.min.css" rel="stylesheet">
			<link href="mixedlibs/bootstrap-fileinput/themes/explorer/theme.css" rel="stylesheet">
			  
                <style>
                  a {
                  color: orange;
                  }
                </style>
                <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
                <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
                <!--[if lt IE 9]><link href= "css/bootstrap-theme.css"rel= "stylesheet" >

				<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
				<script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
				<![endif]-->
              </head>

		<body ng-cloak="">
			<div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
				<div class="container">
					<div class="row">
						<div class="navbar-header col-md-8">
							<button type="button" class="navbar-toggle" toggle="collapse" target=".navbar-ex1-collapse">
							<span class="sr-only">Toggle navigation</span>
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
							</button>
							<a class="navbar-brand" rel="home" title="Testosteron" href="#/">Testosteron</a>
						</div>
		  
					<div class="navbar-collapse collapse">
						<ul class="nav navbar-nav">
						<li><a href="#/opensource">OpenSource</a></li>
						<li><a href="#/business">Business</a></li>
						<li><a href="#/login">Sign in</a></li>
						<li><a href="#/signup">Sign up</a></li>
						</ul>
					</div>
				</div>
			</div>
		</div>
    <div >
      <div class="container" style="margin-top:20px;">
	    <span ng-model="test"></span>
        <div data-ng-view="" id="ng-view" class="slide-animation"></div>

      </div>
    
	<div><p>
	<?php
	 ini_set('display_errors', 'On');
	 error_reporting(E_ALL | E_STRICT);	
	?>
	</p></div>
	
	</body>
	
  <toaster-container toaster-options="{'time-out': 3000}"></toaster-container>
  <!-- Libs -->
  <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
  
  <script src="js/angular.min.js"></script>
  <script src="js/angular-route.min.js"></script>
  <script src="js/angular-animate.min.js" ></script>
  
  <!-- for file upload -->
  <script src="mixedlibs/bootstrap-fileinput/js/plugins/canvas-to-blob.min.js"></script>
  <script src="mixedlibs/bootstrap-fileinput/js/plugins/sortable.min.js"></script>
  <script src="mixedlibs/bootstrap-fileinput/js/plugins/purify.min.js"></script>
  <script src="mixedlibs/bootstrap-fileinput/js/fileinput.js"></script>
  <script src="mixedlibs/bootstrap-fileinput/themes/explorer/theme.js"></script>
  
  <script src="js/angular-sanitize.js"></script> 
  <script src="js/toaster.js"></script>
  <script src="app/app.js"></script>
  <script src="app/data.js"></script>
  <script src="app/directives.js"></script>
  <script src="app/authCtrl.js"></script>
</html>


app.controller('authCtrl', function ($scope, $rootScope, $routeParams, $location, $http, $sce, Data) {
    //initially set those objects to null to avoid undefined error
    $scope.login = {};
    $scope.signup = {};
	$scope.test = {};
    $scope.doLogin = function (customer) {
        Data.post('login', {
            customer: customer
        }).then(function (results) {
            Data.toast(results);
            if (results.status == "success") {
                $location.path('dashboard');
            }
        });
    };
	
	
	$scope.loginWithGithub = function (customer) {
        Data.get('loginWithGithub', { 
			customer: customer
		}).then(function (results) {
			$rootScope.test = Data.myself(results); //$sce.trustAsHtml(Data.myself(results));
            //Data.toast(results);
			//if (results.status == "success") {
            $location.path('githublogin');
            //}
			
        });
    };
	
    $scope.signup = {email:'',password:'',name:'',phone:'',address:''};
    $scope.signUp = function (customer) {
        Data.post('signUp', {
            customer: customer
        }).then(function (results) {
            Data.toast(results);
            if (results.status == "success") {
                $location.path('dashboard');
            }
        });
    };
    $scope.logout = function () {
        Data.get('logout').then(function (results) {
            Data.toast(results);
            $location.path('login');
        });
    }
});
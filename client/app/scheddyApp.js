angular.module('Scheddy.LandingPage', []);

angular.module('Scheddy', ['ui.router', 'Scheddy.LandingPage'])
	.config(['$stateProvider', '$urlRouterProvider',
		function($stateProvider, $urlRouterProvider){
			$urlRouterProvider.otherwise("/");

			$stateProvider
		    .state('landingPage', {
		      url: "/",
		      controller: 'LandingPageController',
		      templateUrl: 'app/langingPage/langingPage.html'
		    })
		}
	])
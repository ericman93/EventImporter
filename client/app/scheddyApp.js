angular.module('Scheddy.Core', ['directive.g+signin']);
angular.module('Scheddy.LandingPage', []);
angular.module('Scheddy.User', []);

angular.module('Scheddy', ['ui.router', 'Scheddy.LandingPage', 'Scheddy.User', 'Scheddy.Core'])
	.config(['$stateProvider', '$urlRouterProvider',
		function($stateProvider, $urlRouterProvider){
			$urlRouterProvider.otherwise("/");

			$stateProvider
		    .state('landingPage', {
		      url: "/",
		      controller: 'LandingPageController',
		      templateUrl: 'app/langingPage/langingPage.html'
		    })
		    .state('user', {
		      url: '/user/:userId',
		      controller: 'UserController',
		      templateUrl: 'app/user/user.html'
		    })
		}
	])
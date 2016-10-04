angular.module('Scheddy.Core.Navbar', []);
angular.module('Scheddy.Core', ['directive.g+signin', 'Scheddy.Core.Navbar']);
angular.module('Scheddy.LandingPage', []);
angular.module('Scheddy.Business', []);
angular.module('Scheddy.Businesses', []);
angular.module('Scheddy.User', []);

angular.module('Scheddy', ['ngMaterial', 'ui.router', 'Scheddy.LandingPage', 'Scheddy.Business', 'Scheddy.Businesses', 'Scheddy.User', 'Scheddy.Core'])
	.config(['$stateProvider', '$urlRouterProvider',
		function($stateProvider, $urlRouterProvider){
			$urlRouterProvider.otherwise("/");

			$stateProvider
		    .state('landingPage', {
		      url: "/lading",
		      controller: 'LandingPageController',
		      templateUrl: 'app/langingPage/langingPage.html'
		    })
			.state('businesses', {
				url: "/",
				controller: 'BusinessesController',
				templateUrl: 'app/businesses/businesses.html'
			})
			.state('business', {
				url: '/business/:businessId',
				controller: 'BusinessController',
				templateUrl: 'app/business/business.html'
			})
		    .state('user', {
		      url: '/user/:userId',
		      controller: 'UserController',
		      templateUrl: 'app/user/user.html'
		    })
		}
	]);
angular.module('Scheddy.User')
	.controller('UserController',
		['$scope', '$stateParams',
			function($scope, $stateParams){
				var userId = $stateParams.userId;
				$scope.name = userId
			}
		]
	)
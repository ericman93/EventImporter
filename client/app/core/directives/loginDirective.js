angular.module('Scheddy.Core')
	.directive('loginPanel', ['$state', '$http', 'Auth',
		function ($state, $http, Auth){
			return {
				template: '<google-plus-signin clientid="1058234090303-derenhna8oi3h32bf47j77rqtrfalrcd.apps.googleusercontent.com"></google-plus-signin>',
				restrict: 'EA',
				controller: function ($scope, $element) {
					$scope.$on('event:google-plus-signin-success', function (event, authResult) {
			    		userHasSignId('google', authResult.id_token)
			  		});

			  		function userHasSignId(providerName, providerId){
		  				Auth.getUserId(providerName, providerId);
	  					$state.go('user', {userId: 6})
			  		}

        		}
			}
		}
	])
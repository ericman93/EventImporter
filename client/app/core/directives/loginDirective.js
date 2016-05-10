angular.module('Scheddy.Core')
	.directive('loginPanel', [
		function (){
			return {
				template: '<google-plus-signin clientid="1058234090303-derenhna8oi3h32bf47j77rqtrfalrcd.apps.googleusercontent.com"></google-plus-signin>',
				restrict: 'EA',
				controller: function ($scope, $element) {
					$scope.$on('event:google-plus-signin-success', function (event,authResult) {
			    		console.log(authResult)
			  		});
        		}
			}
		}
	])
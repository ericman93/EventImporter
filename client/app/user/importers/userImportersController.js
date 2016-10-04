angular.module('Scheddy.User')
	.directive('eventsImporters', ['$http', 'SERVER',
		function ($http, SERVER){
			return {
				template: '<div><a href="http://localhost:5000/oauth/google/calendar">google</a></div>',
				restrict: 'EA',
				controller: ['$scope', function($scope){
					$scope.google = function(name){
						$http.get(SERVER+'/oauth/google/calendar')
						.success(function(data){
							console.log(data)
						})
						.error(function (data, status, headers, config) {
							console.error(data);
						});
					}
				}]
			}
		}
	]
)
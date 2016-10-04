angular.module('Scheddy.Core')
	.factory('Auth', ['$http', '$log', 'SERVER',
		function($http, $log, SERVER){
			function getUserId(providerName, providerToken){
				$http.post(SERVER + '/user/',{
					provider: providerName,
					id: providerToken	
				})
				.success(function(data){
					$log.log(data)
				})
				.error(function (data, status, headers, config) {
					$log.error(data);
				});
			}

			return {
				getUserId: getUserId
			};
		}
	])
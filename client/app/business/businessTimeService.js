angular.module('Scheddy.Business')
    .factory('businessTime', ['$http', '$q', 
        function($http, $q) {
            function getBusinessFreeTime(date, duration){
                var deferred = $q.defer();

                deferred.resolve([{
                    from: '10:00',
                    to: '18:00'
                },
                {
                    from: '08:00',
                    to: '09:00'
                }])

                return deferred.promise;
            }

            return {
                getBusinessFreeTime: getBusinessFreeTime
            }
        }
    ]);
    
angular.module('Scheddy.Business')
    .controller('BusinessController',
        ['$scope', '$stateParams',
            function($scope, $stateParams){
                $scope.selectedService = undefined;

                function getBusiness(){
                    return {
                        name: 'YaYa',
                        location: 'Binyamina',
                        coordinates: [],
                        desc: 'מספרה',
                        services: [
                            {
                                id: 1,
                                name:'תספורת גבר',
                                duration: 60,
                                price: 60
                            },
                            {
                                id: 2,
                                name:'תספורת אישה',
                                duration: 120,
                                price: 100
                            }
                        ]
                    }
                }

                function init(){
                    $scope.business = getBusiness($stateParams.businessId)
                }

                function getFreeTime(duration){
                    return {
                        0: [{   
                            from: '10:00',
                            to: '18:00'
                        }],
                        2: [{
                            from: '10:00',
                            to: '18:00'
                        },
                        {
                            from: '08:00',
                            to: '09:00'
                        }]
                    }
                }

                $scope.serviceSelected = function(serviceId) {
                    $scope.selectedService =  $scope.business.services.filter(function(serivce) {
                       return serivce.id == serviceId
                    })[0]

                    $scope.freeSlots = getFreeTime($scope.selectedService['duration'])
                }

                init();
            }
        ]
    );
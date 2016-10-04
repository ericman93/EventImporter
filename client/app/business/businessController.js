angular.module('Scheddy.Business')
    .controller('BusinessController',
        ['$scope', '$stateParams',
            function($scope, $stateParams){
                $scope.selected = {
                    service: undefined
                };
                $scope.selectedStep = 0;

                function getBusiness(){
                    return {
                        name: 'YaYa',
                        location: 'בנימינה הדקל 7',
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

                $scope.seleteSlot = function(timing) {
                    $scope.selected.time = timing;
                }

                $scope.serviceSelected = function(serviceId) {
                    $scope.selected.service =  $scope.business.services.filter(function(serivce) {
                       return serivce.id == serviceId
                    })[0]

                    $scope.freeSlots = getFreeTime($scope.selected.service['duration'])
                    $scope.selectedStep += 1;
                }

                init();
            }
        ]
    );
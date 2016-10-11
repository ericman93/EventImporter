angular.module('Scheddy.Business')
    .controller('BusinessController',
        ['$scope', '$stateParams', 'businessTime',
            function($scope, $stateParams, businessTime){
                $scope.selected = {};
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

                function getFreeTime(date, duration){
                    businessTime.getBusinessFreeTime(date, duration).then(function(times) {
                        $scope.freeSlots = times;
                    })
                }

                $scope.seleteSlot = function(timing) {
                    $scope.selected.time = timing;
                }

                $scope.serviceSelected = function(serviceId) {
                    $scope.selected.service =  $scope.business.services.filter(function(serivce) {
                       return serivce.id == serviceId
                    })[0]

                    $scope.selectedStep += 1;
                }

                $scope.$watch('selected.date', function(newVal, oldVal) {
                    if(oldVal != newVal){
                        getFreeTime(newVal, $scope.selected.service['duration'])
                        $scope.selected.time = undefined
                    }
                })

                init();
            }
        ]
    );
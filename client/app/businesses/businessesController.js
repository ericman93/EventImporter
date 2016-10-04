angular.module('Scheddy.Businesses')
    .controller('BusinessesController',
        ['$scope',
            function($scope){
                function getDummyBusinesses(){
                    $scope.businesses = [
                        {
                            name: 'Yaya',
                            type: 'haircut',
                            location: 'Binyemina'
                        }
                    ]
                }

                getDummyBusinesses();
            }
        ]
    );
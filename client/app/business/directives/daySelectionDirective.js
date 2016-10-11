angular.module('Scheddy.Business')
    .directive('daySelection', [function() { 
        return {
            templateUrl: '/app/business/directives/daySelectionTemplate.html',
            restrict: 'EA',
            scope: {
                date: '=',
                startDate: '=?'
            },
            controller: ['$scope', function($scope){
                function init(){
                    $scope.startDate = $scope.startDate || new Date();
                    
                    initDates();
                }

                function initDates(){
                    $scope.nextDays = [
                        {
                            name: 'היום',
                            date: $scope.startDate
                        },
                        {
                            name: 'מחר', 
                            date: addDaysToDaye($scope.startDate, 1)
                        },
                        {
                            name: "מחרותיים",
                            date: addDaysToDaye($scope.startDate, 2)
                        },
                        {
                            name: "שבוע הבא",
                            date: addDaysToDaye($scope.startDate, 7)
                        }
                    ]
                }

                function addDaysToDaye(date, days) {
                    var other = new Date(date);
                    other.setDate(date.getDate() + days)
                    return other
                }

                $scope.dateChanged = function(date) {
                    $scope.date = date;
                    //fireEvent('dateChanged');
                }

                init();
            }]
        }
    }
])
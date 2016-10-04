angular.module('Scheddy.Core.Navbar')
    .directive('navbar', ['$state',
        function ($state){
            return {
                templateUrl: 'app/core/directives/navbar/navbar.html',
                restrict: 'EA',
                controller: function ($scope, $element) {
                }
            }
        }
    ]);
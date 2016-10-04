angular.module('Scheddy.Business')
    .directive('duration', [function() { 
        return {
            template: '<div>מ{{from}} עד {{to}}</hello>',
            restrict: 'EA',
            scope: {
                from: '=',
                to: '='
            }
        }
    }
])
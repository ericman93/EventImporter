angular.module('Scheddy.Core')
    .filter('weekDayName', [function() {
        var days = ['ראשון', 'שני', 'שלישי', 'רביעי', 'חמישי', 'שישי', 'שבת']
        
        return function(dayNumber) {
            return days[dayNumber];
        }
    }
])
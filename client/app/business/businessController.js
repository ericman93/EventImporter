angular.module('Scheddy.Business')
    .controller('BusinessController',
        ['$scope', '$stateParams', 'businessTime',
            function($scope, $stateParams, businessTime){
                $scope.selected = {};
                $scope.selectedStep = 0;

                $scope.isDayFull = function(day){
                    // return wether the day is full.
                    // if the day is full, day could not be selected
                    // use md-datepicker md-date-filter	property
                    return true
                }

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
                    $scope.business = getBusiness($stateParams.businessId);
                    $scope.today = new Date();
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
    )
    .config(function($mdDateLocaleProvider) {
        $mdDateLocaleProvider.months = ['ינואר', 'פברואר', 'מרץ', 'אפריל', 'מאי', 'יוני', 'יולי','אוגוסט','ספטמבר', 'אוקטובר','נובמבר','דצמבר'];
        $mdDateLocaleProvider.shortMonths = ['ינו', 'פבר', 'מרץ', 'אפר', 'מאי', 'יוני', 'יולי','אוג','ספט', 'אוק','נוב','דצמ'];
        $mdDateLocaleProvider.days = ['ראשון', 'שני', 'שלישי', 'רביעי', 'חמישי', 'שישי', 'שבת'];
        $mdDateLocaleProvider.shortDays = ['א', 'ב', 'ג', 'ד','ה', 'ו', 'ש'];
        $mdDateLocaleProvider.firstDayOfWeek = 0;
        
        $mdDateLocaleProvider.formatDate = function(date) {
            var m = moment(date);
            return date && m.isValid() ? m.format('L') : '';       
        };
    });
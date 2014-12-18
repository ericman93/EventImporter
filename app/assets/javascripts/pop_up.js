$(function () {
    $("div#backgroundPopup").click(function () {
        disablePopup();  // function close pop up
    });

    $("div.close").click(function () {
        disablePopup();  // function close pop up
    });
});

var popupStatus = 0; // set value

function loadPopup() {
    if (popupStatus == 0) { // if value is 0, show popup
        closeloading(); // fadeout loading
        $("#toPopup").fadeIn(0500); // fadein popup div
        showBackground();
        popupStatus = 1; // and set value to 1
    }
}

function showBackground(){
    $("#backgroundPopup").css("opacity", "0.7"); // css opacity, supports IE7, IE8
    $("#backgroundPopup").fadeIn(0001);
}

function disablePopup(callback) {
    if (popupStatus == 1) { // if value is 1, close popup
        //$("#toPopup").fadeOut("normal", function(){
        //    if(callback != undefined){
        //        callback();
        //    }
        //});
        $("#toPopup").fadeOut("normal");
        $("#loadingPopup").fadeOut("normal");

        $("#backgroundPopup").fadeOut("normal");
        popupStatus = 0;  // and set value to 0
    }
}
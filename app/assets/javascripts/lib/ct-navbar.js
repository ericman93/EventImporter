searchVisible = 0;
transparent = true;
hasTransparent = false;
pageScrollFrom = 0;

$(document).ready(function(){
   if($('nav[role="navigation"]').hasClass('navbar-transparent')){
        hasTransparent = true;
   }
   $('[data-toggle="search"]').click(function(){
        if(searchVisible == 0){
            searchVisible = 1;
            $(this).parent().addClass('active');
            $(this).children('p').html('Close');
            $('.navbar-search-form').fadeIn(function(){
                $('.navbar-search-form input').focus();
            });
        } else {
            searchVisible = 0;
            $(this).parent().removeClass('active');
            $(this).children('p').html('Search');
            $(this).blur();
            $('.navbar-search-form').fadeOut(function(){
                $('.navbar-search-form input').blur();
            });
        } 
    });
    
    if(pageScrollFrom == 0){
        showScroll();
    }
});

$(document).scroll(function() {
   if(hasTransparent && pageScrollFrom != 0){
        if( $(this).scrollTop() > pageScrollFrom) {
            if(transparent) {
                transparent = false;
                $('nav[role="navigation"]').removeClass('navbar-transparent');
            }
        } 
        else {
            if( !transparent ) {
                transparent = true;
                $('nav[role="navigation"]').addClass('navbar-transparent');
            }
        }
    }
});

function showScroll(){
    $('nav[role="navigation"]').removeClass('navbar-transparent');
}












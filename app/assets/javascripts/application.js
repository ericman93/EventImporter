$(function () {
    set_request_count()
    $(".alert").alert();
});

function setEmailInputs(){
    $('input[type=email]').on('blur', function() {
      $(this).mailcheck({
        suggested: function(element, suggestion) {
            if(!element.next().hasClass("email_suggestion")){
                element.after(create_emai_suggestion_link(element, suggestion))
            }      
        },
        empty: function(element) {
          // callback code
        }
      });
    });
}

function create_emai_suggestion_link(element, suggestion){
    return $("<a/>",{
        html: "Did you mean: <strong>"+suggestion.full+"</strong>",
        style: "display: block",
        class: "email_suggestion"
    })
    .click(function(){
        $(element).val(suggestion.full)
        this.remove();
    })
}

function set_request_count(){
    $.ajax({
        url: "/requests/count",
        type: "get",
        success: function(data){
            $('#request_count').html(data)
        },
        error:function(data){
            console.log(data)
        }
    });
}

function get_partial_data(url, content_to, http_method, callback){
    $.ajax({
        url: url,
        type: http_method,
        beforeSend: function(xhr) {
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        },
        success: function(data){
            $(content_to).html(data)
        },
        error:function(data, res){
            $(content_to).html(data)
            console.log(data)
        },
        complete: function(data){
            if(callback != undefined){
                callback();
            }
        }
    });
}

function popupLoading() {
    $('#loadingModal').modal('show'); 
}

function closeLoading() {
    $('#loadingModal').modal('hide'); 
}

function showError(errorMessage){
    $('#error-content').html(errorMessage)
    $('#error-modal').modal('show'); 
}

function showPopup(title, content, titleClass){
    clearPopup();

    if(titleClass != undefined){
        $('#popup-header').addClass(titleClass)
    }

    $('#popup-title').html(title);
    $('#popup-content').html(content);
    $('#popup-modal').modal('show'); 
}

function clearPopup(){
    $('#popup-title').html('');
    $('#popup-content').html('');
    $('#popup-header').attr('class', 'modal-header')
}

function getErrorFromData(data){
    var error_text = ""
    switch(data.status){
        case 400:
            error_text = data.responseText
            break;
        case 500:
            error_text = "Something went wrong"
            break;
        default:
            error_text = 'An error as occurred'
    }

    return error_text;
}
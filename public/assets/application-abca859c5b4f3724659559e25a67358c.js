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

$(function () {
    set_request_count()
    $(".alert").alert();
});

function set_request_count(){
    $.ajax({
        url: "/requests/count",
        type: "get",
        success: function(data){
            $('#request_count').html("Requests ("+data+")")
        },
        error:function(data){
            console.log(data)
        }
    });
}

function getPartialData(url, content_to, http_method, callback){
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
;

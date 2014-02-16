function openInput () {
   $('input[type=file]:first').trigger('click');
};

function readURL (input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();

    reader.onload = function (e) {
        $('.dynamicpicture')
            .attr('src', e.target.result);
    };

    reader.readAsDataURL(input.files[0]);
  }
};

$(window).scroll(function(e){
  parallax();
});
function parallax(){
  var scrolled = $(window).scrollTop();
  $('.bg').css('top',-(scrolled*0.5)+'px');
};


var previousScroll = 0,
    headerOrgOffset = 120;

$('#header-wrap').height($('#header').height());

$(window).scroll(function () {
    var currentScroll = $(this).scrollTop();
    if (currentScroll > headerOrgOffset) {
        if (currentScroll > previousScroll) {
            $('#header-wrap').fadeOut();
        } else {
            $('#header-wrap').fadeIn();
        }
    }
    previousScroll = currentScroll;
});



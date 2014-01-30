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



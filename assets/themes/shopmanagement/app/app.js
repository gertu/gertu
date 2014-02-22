var App = (function(){

  var map;
  var marker;

  function placeMarker(location) {
      if ( marker ) {
          marker.setPosition(location);
      } else {
          marker = new google.maps.Marker({
            position: location,
            map: map,
            title: 'Tu tienda'
          });
      }
    }

  var initializeMap = function(mapContainerId, latitude, longitude, latitudeBox, longitudeBox) {

    var mapOptions = {
      zoom: 8,
      center: new google.maps.LatLng(latitude, longitude)
    };

    map = new google.maps.Map(document.getElementById(mapContainerId),
        mapOptions);

    placeMarker(new google.maps.LatLng(latitude, longitude));

    google.maps.event.addListener(map, 'click', function(event) {
        placeMarker(event.latLng);
        document.getElementById(latitudeBox).value = event.latLng.lat();
        document.getElementById(longitudeBox).value = event.latLng.lng();
    });
  }

  var verifyFieldsMatch = function (firstFieldId, secondFieldId){
    var doMatch = (document.getElementById(firstFieldId).value == document.getElementById(secondFieldId).value);

    if (!doMatch)
    {
      showAlert('Las contraseñas no coinciden');
      return false;
    }
    else
    {
      return true;
    }
  };

  var syncronizeGertuPriceBoxes = function (normalPriceBoxId, gertuPriceBoxId, discountBoxId){

    $(normalPriceBoxId).on('spinchange', function(){

      var normalPrice = parseFloat($(normalPriceBoxId).spinner('value'));
      var gertuPrice = parseFloat($(gertuPriceBoxId).spinner('value'));

      console.log(normalPrice);
      console.log(gertuPrice);

      var discount = 100 - (100 * (normalPrice > 0 ?
                       gertuPrice / normalPrice :
                       0));

      discount = discount.toFixed(2);

      console.log(discount);

      $(discountBoxId).spinner('value' ,discount);
    });

    $(gertuPriceBoxId).on('spinchange', function(){

      var normalPrice = parseFloat($(normalPriceBoxId).spinner('value'));
      var gertuPrice = parseFloat($(gertuPriceBoxId).spinner('value'));

      var discount = 100 - (100 * (normalPrice > 0 ?
                       gertuPrice / normalPrice :
                       0));

      discount = discount.toFixed(2);

      $(discountBoxId).spinner('value', discount);
    });

    $(discountBoxId).on('spinchange', function(){

      var normalPrice = parseFloat($(normalPriceBoxId).spinner('value'));
      var discount = parseFloat($(discountBoxId).spinner('value'));

      var gertuPrice = normalPrice - (normalPrice * discount) / 100;

      gertuPrice = gertuPrice.toFixed(2);

      $(gertuPriceBoxId).spinner('value', gertuPrice);
    });

  };

  var showAlert = function(outputMessage){

    var dialogHtml = '<div class="custom-dialog-modal" title="Alerta"></div>';

    $('body .custom-dialog-modal').remove();

    $('body').append(dialogHtml);
    $('body .custom-dialog-modal').html('<p>' + outputMessage + '</p>')
    $('body .custom-dialog-modal').dialog({
      height: 140,
      modal: true
    });

  };

  var showConfirm = function(outputMessage){

    return confirm(outputMessage);

  };

  return {
    initializeMap: initializeMap,
    verifyFieldsMatch: verifyFieldsMatch,
    syncronizeGertuPriceBoxes: syncronizeGertuPriceBoxes,
    showAlert: showAlert,
    showConfirm: showConfirm
  }
})();
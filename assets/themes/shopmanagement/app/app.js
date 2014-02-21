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
      alert('Las contraseñas no coinciden');
      return false;
    }
    else
    {
      return true;
    }
  };

  var syncronizeGertuPriceBoxes = function (normalPriceBoxId, gertuPriceBoxId, discountBoxId){

    document.getElementById(normalPriceBoxId).onchange = function(){

      var normalPrice = parseFloat((document.getElementById(normalPriceBoxId).value + '').replace(',', '.'));
      var gertuPrice = parseFloat((document.getElementById(gertuPriceBoxId).value + '').replace(',', '.'));
      
      var discount = 100 - (100 * (normalPrice > 0 ? 
                       gertuPrice / normalPrice :
                       0));

      discount = discount.toFixed(2);
   
      document.getElementById(discountBoxId).value = discount;
    };

    document.getElementById(gertuPriceBoxId).onchange = function(){

      var normalPrice = parseFloat(document.getElementById(normalPriceBoxId).value.replace(',', '.'));
      var gertuPrice = parseFloat(document.getElementById(gertuPriceBoxId).value.replace(',', '.'));
      
      var discount = 100 - (100 * (normalPrice > 0 ? 
                       gertuPrice / normalPrice :
                       0));

      discount = discount.toFixed(2);

      document.getElementById(discountBoxId).value = discount;
    };

    document.getElementById(discountBoxId).onchange = function(){

      var normalPrice = parseFloat(document.getElementById(normalPriceBoxId).value.replace(',', '.'));
      var discount = parseFloat(document.getElementById(discountBoxId).value.replace(',', '.'));
      
      var gertuPrice = normalPrice - (normalPrice * discount) / 100;

      gertuPrice = gertuPrice.toFixed(2);

      document.getElementById(gertuPriceBoxId).value = gertuPrice;
    };
  };

  var showAlert = function(outputMessage){

    alert(outputMessage);

  };

  return {
    initializeMap: initializeMap,
    verifyFieldsMatch: verifyFieldsMatch,
    syncronizeGertuPriceBoxes: syncronizeGertuPriceBoxes,
    showAlert: showAlert

  }
})();
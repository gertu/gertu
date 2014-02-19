var App = (function(){

  var map;

  var initializeMap = function(mapContainerId, latitude, longitude) {

    var mapOptions = {
      zoom: 8,
      center: new google.maps.LatLng(latitude, longitude)
    };

    map = new google.maps.Map(document.getElementById(mapContainerId),
        mapOptions);
  }

  var verifyFieldsMatch = function (firstFieldId, secondFieldId){
    var doMatch = (document.getElementById(firstFieldId).value == document.getElementById(secondFieldId).value);

    debugger;
    
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

      var normalPrice = document.getElementById(normalPriceBoxId).value;
      var gertuPrice = document.getElementById(gertuPriceBoxId).value;
      
      var discount = 100 - (100 * (normalPrice > 0 ? 
                       gertuPrice / normalPrice :
                       0));

      discount = discount.toFixed(2);
      
      document.getElementById(discountBoxId).value = discount;
    };

    document.getElementById(gertuPriceBoxId).onchange = function(){

      var normalPrice = document.getElementById(normalPriceBoxId).value;
      var gertuPrice = document.getElementById(gertuPriceBoxId).value;
      
      var discount = 100 - (100 * (normalPrice > 0 ? 
                       gertuPrice / normalPrice :
                       0));

      discount = discount.toFixed(2);

      document.getElementById(discountBoxId).value = discount;
    };

    document.getElementById(discountBoxId).onchange = function(){

      var normalPrice = document.getElementById(normalPriceBoxId).value;
      var discount = document.getElementById(discountBoxId).value;
      
      var gertuPrice = normalPrice - (normalPrice * discount) / 100;

      gertuPrice = gertuPrice.toFixed(2);

      document.getElementById(gertuPriceBoxId).value = gertuPrice;
    };
  };

  return {
    initializeMap: initializeMap,
    verifyFieldsMatch: verifyFieldsMatch,
    syncronizeGertuPriceBoxes: syncronizeGertuPriceBoxes

  }
})();
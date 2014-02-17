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

	return {
		initializeMap: initializeMap,
		verifyFieldsMatch: verifyFieldsMatch
	}
})();
var App = (function(){

	var map;

	function initializeMap(mapContainerId, latitude, longitude) {
	  var mapOptions = {
	    zoom: 8,
	    center: new google.maps.LatLng(latitude, longitude)
	  };
	  console.log(document.getElementById(mapContainerId));
	  map = new google.maps.Map(document.getElementById(mapContainerId),
	      mapOptions);
	}

	return {
		initializeMap: initializeMap
	}
})();
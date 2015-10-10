var curr_location = null;
var nearby_container = null;
var nearby_types = [];

function get_nearby_places(lat, long, types, container) {
  curr_location = new google.maps.LatLng(lat, long);
  nearby_container = container
  nearby_types = types
  var request = {
    location: curr_location,
    radius: 4000,
    types: types
  };
  service = new google.maps.places.PlacesService(document.getElementById('nearby-places'));
  service.nearbySearch(request, nearby_callback);
}

function nearby_callback(results, status) {
  console.log(results);
  if (status == google.maps.places.PlacesServiceStatus.OK) {
    if ( results.length < 1 ) {
      $(nearby_container+">.info>center").html("Unfortunately we were not able to find any results");
      return;
    }
    var distance = 0;
    var html_str = "";
    var count_until = 10;
    var type_to_show = "";
    reaults = results.sort(function(a, b){return google.maps.geometry.spherical.computeDistanceBetween(curr_location, a.geometry.location)-google.maps.geometry.spherical.computeDistanceBetween(curr_location, b.geometry.location)});
    if(results.length < 10)
      count_until = results.length;

    for (var i = 0; i < count_until; i++) {
      distance = google.maps.geometry.spherical.computeDistanceBetween(curr_location, results[i].geometry.location) / 1000;
      for(var j = 0; j < results[i].types.length; j++) {
        if (nearby_types.indexOf(results[i].types[j]) > -1) {
          type_to_show = results[i].types[j]
          break;
        }
      }
      html_str = "<div class='nearby-result'><div class='nearby-type'>"+humanize(type_to_show)+"</div><div class='nearby-info'>"+humanize(results[i].name)+"<br/>"+distance.toFixed(1)+" km</div><div class='clearfix'></div></div>";
      if($(nearby_container+">.info>center").length > 0) {
        $(nearby_container+">.info").html(html_str);
      } else {
        $(nearby_container+">.info").append(html_str);
      }
    }
  }
  else {
    $(nearby_container+">.info>center").html("Unfortunately we were not able to find any results");
  }
}

function humanize(str) {
  var frags = str.split('_');
  for (i=0; i<frags.length; i++) {
    frags[i] = frags[i].charAt(0).toUpperCase() + frags[i].slice(1);
  }
  return frags.join(' ');
}
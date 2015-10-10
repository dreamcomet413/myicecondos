//= require jquery
//= require jquery_ujs
//= require jquery.geocomplete.min
var formSubmit = false;

$(function() {

  $(".auto-field").geocomplete({
    details: ".autocomplete_form"
  }).bind("geocode:result", function(event, result){
    if(formSubmit == true)
      submitLandingForm();
  });

  $(document).on("click", ".landing-submit", function(e){
    e.preventDefault();
    if($("input[name=route]").val() != "")
      submitLandingForm();
    else
      formSubmit = true;
  });

  $(".auto-field").keydown(function(e) {
    if(e.which == 13)
      $(".landing-submit").trigger("click");
  });

  $(document).on("click", ".refresh_page", function(e){
    e.preventDefault();
    location.reload();
  });

  $(document).on("click", "#submit_home_value_btn", function(e){
    if ( $.trim($("#home_value_lead_form input[name=full_name]").val()) == "" || $.trim($("#home_value_lead_form input[name=phone]").val()) == "" || $.trim($("#home_value_lead_form input[name=email]").val()) == "" || !IsEmail($("#home_value_lead_form input[name=email]").val()) ) {
      e.preventDefault();
      alert("Please fill out all the fields properly");
    }
    else {
      $("#submit_home_value_btn").prop('disabled', true);
      $("#home_value_lead_form").submit();
    }
  });

  $(document).on("click", "#explore_properties", function(e){
    e.preventDefault();
    window.location = "/listings?autocomplete_form=true&locality="+$("[name=locality]").val()+"&administrative_area_level_1="+$("[name=administrative_area_level_1]").val();
  });
});

function submitLandingForm() {
  switch($(".autocomplete_form").prop("id")) {
    case "landing_search_form":
      $(".autocomplete_form").submit();
      break;
    case "home_value_search_form":
      home_value_form();
      break;
  }
}

function home_value_form() {
  $(".home_value_search").hide();
  if($("input[name=lat]").val() != "") {
    $(".home_value_step1").show();
    var lat = $("input[name=lat]").val();
    var long = $("input[name=lng]").val();
    $('#map_container').html("<img src='https://api.tiles.mapbox.com/v4/"+mapbox_map+"/pin-l+ff6f20("+long+","+lat+")/"+long+","+lat+",16/600x600.png?access_token="+mapbox_token+"' class='img-responsive w100' onerror='this.onerror=null;this.src=\'/missing-location.png\';'/>");
  }
  else
    $(".home_value_no_results").show();
}

function IsEmail(email) {
  var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
  return regex.test(email);
}
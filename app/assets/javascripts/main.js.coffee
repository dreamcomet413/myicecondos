window.chunk = (arr, size) ->
  newArr = []
  i = 0
  while i < arr.length
    newArr.push arr.slice(i, i + size)
    i += size
  newArr

window.map = null
window.markers = null

# window.load_info_box = (e) ->
#   id = e.target.options.id
#   lat = e.target.options.lat
#   long = e.target.options.long
#   L.popup().setLatLng([lat, long]).setContent("<img src='/orange_loading.gif'/>").openOn(map)
#   $.ajax
#     url: '/listings?ids=' + id
#     type: 'GET'
#     dataType: "json"
#     success: (data, status, response) ->
#       if($("body").data("signed-in") == false && data[0].visibility == 'vow')
#         wrap_clas = 'media blur'
#       else
#         wrap_clas = 'media'
#
#       html_str = "<div class='property-box'><div class='imagebox'><img src='http://icecondos.s3.amazonaws.com/listing_photos/listing_"+id+"_0.jpg' onerror='this.onerror=null;this.src=\"/missing-image.png\";'></div><div class='place'>"+data[0].municipality+"</div><div class='address'>"+data[0].addr+"</div><div class='property-carousel'><div class='owl-carousel'><div class='item'><img src='/icon-bed.png' /><span class='title'>Beds</span><span class='numbers'>"+(data[0].br || '--')+"</span></div><div class='item'><img src='/icon-baths.png' /><span class='title'>Baths</span><span class='numbers'>"+(data[0].bath_tot || '--')+"</span></div><div class='item'><img src='/icon-square-feets.png' /><span class='title'>Sq. Ft.</span><span class='numbers'>"+(data[0].sqft || '--')+"</span></div></div></div><div class='btn-container'><a target='_self' href='/listings/"+id+"' class='btn'>View Property</a></div></div>"
#       if($("body").data("signed-in") == false && data[0].visibility == 'vow')
#         html_str += "<div class='overlay'><a href='#modal-login' data-toggle='modal'>Sign in to view</a></div>"
#       $('.leaflet-popup-content').first().html html_str
#       $('.leaflet-popup-content')
#       $('.leaflet-popup-content .owl-carousel').owlCarousel({
#         itemsCustom: [[0, 3], [450, 3], [600, 3], [700, 3], [1000, 3]],
#         pagination: false
#       });
#     error: ->
#       $('.leaflet-popup-content').first().html "Something went wrong"

# window.load_map_data = () ->
  # unless localStorage.getItem('fully_loaded_map_data') == "true"
  #   a = 1
#    results_to_store = get_paginated_results([], 1)

# window.get_paginated_results = (all_results, page) ->
#   $.ajax
#     url: '/listings/map_data?per_page=1000&page=' + page
#     type: 'GET'
#     dataType: "json"
#     success: (data, status, response) ->
#       for d in data
#         all_results.push d
#       if data.length == 1000
#         get_paginated_results(all_results, page+1)
#       else
#         store_data all_results
#     error: ->
#       localStorage.setItem('fully_loaded_map_data', 'false')
#
# window.store_data = (results) ->
#   localStorage.setItem('full_map_data', JSON.stringify(results))
#   localStorage.setItem('fully_loaded_map_data', 'true')

# window.setByWidthHeight = ->
#   $('.banner').height $(window).height() - 186
#   $('#menu-scroll').height $(window).height() - 110
#   return
#
# $ ->
#   # $(".home-autocomplete-field").geocomplete(details: "#home_detail_fields")
#   # $(".advanced-search-autocomplete-field").geocomplete(details: "#advanced_search_detail_fields")
#   # $(".search-filters-autocomplete-field").geocomplete(details: "#search_filters_details_fields")
#   # $(".prospect-match-autocomplete-field").geocomplete(details: "#prospect_match_detail_fields")
#
#   # $(window).on "scroll", ->
#   #   if($(window).scrollTop() + $(window).height() >= $(document).height() - 200)
#   #     $(window).unbind('scroll')
#   #     $("#load_more_search_results").trigger("click")
#
#   $(".navbar-autocomplete-field").geocomplete(details: "#navbar_detail_fields").bind "geocode:result", ->
#     $("#navbar_detail_fields").submit()
#   $(document).on 'click', '.custom_select', (e)->
#     e.preventDefault()
#     $($(this).data('target-field')).val($(this).data('target-value'))
#     $($(this).data('target-btn')).html($(this).text())
#
#   $(document).on 'click', '.radio_buttons_item', (e)->
#     e.preventDefault()
#     $(this).siblings('.active').removeClass('active')
#     $(this).addClass('active')
#     $($(this).data('target')).val($(this).data('value'))
#     $($(this).data('target')).trigger('input')
#
#   setByWidthHeight()
#   $(window).resize ->
#     setByWidthHeight()
#     return
#   $('.scroll-down').click (e) ->
#     $('body,html').animate { scrollTop: $('#explore').offset().top - 66 }, 700
#     e.preventDefault()
#     return
#   $('.slow-scroll').click (e) ->
#     $('body,html').animate { scrollTop: $($(this).data("target")).offset().top - 100 }, 700
#     e.preventDefault()
#     return
#   $('.menu-toggle').click (e) ->
#     if $(this).hasClass('active')
#       $('.nav-menu').removeClass 'show'
#       $('body').removeClass 'nav-open'
#       $(this).removeClass 'active'
#     else
#       $(this).addClass 'active'
#       $('body').addClass 'nav-open'
#       $('.nav-menu').addClass 'show'
#     e.preventDefault()
#     return
#   $('#menu-scroll').nanoScroller sliderMaxHeight: 50
#   $('[data-toggle="signup"]').click (e) ->
#     $('#modal-login').modal 'hide'
#     setTimeout (->
#       $('#modal-signup').modal 'show'
#       return
#     ), 350
#     e.preventDefault()
#     return
#   $('[data-toggle="login"]').click (e) ->
#     $('#modal-signup').modal 'hide'
#     setTimeout (->
#       $('#modal-login').modal 'show'
#       return
#     ), 350
#     e.preventDefault()
#     return
#   return
#
# $ ->
#
#   $('.selectpicker').selectpicker
#     width: 150
#   $('.selectpicker100').selectpicker
#     width: 90
#
#   $(".even-height").each ->
#     $(this).height($(this).parent().height())
#
#   $('[data-toggle="tooltip"]').tooltip()
#
#   $('.dropdown-toggle[data-id="search_beds_select"] .filter-option').html("Beds")
#   $('.dropdown-toggle[data-id="search_baths_select"] .filter-option').html("Baths")
#
#   $('.price-range-menu input, .price-range-menu li').on "click", (e)->
#     e.stopPropagation()
#
#   $('.min_price_list_item').on "click", ->
#     $("#min_price_input").val $(this).data("price-value")
#
#   $('.max_price_list_item').on "click", ->
#     $("#max_price_input").val $(this).data("price-value")
#
#   $(document).on 'click', '.mortgage_btn', ->
#     $(this).siblings(".active").removeClass("active")
#     $(this).addClass("active")
#
#   $(document).on 'click', '.resort_link', ->
#     $(".homepage_categories .geolocation_link.active").removeClass('active')
#     $(this).parent().find('.active').removeClass('active')
#     $(this).addClass('active')
#
#   $(document).on 'click', '.geolocation_link', ->
#     $('.homepage_categories .active').removeClass('active')
#     $(this).addClass('active')
#
$(document).on 'click', '.request-info-link', ->
  $("#request-info-modal .modal-title").html($(this).data('modal-title'))
  $("#request-info-modal input[type=submit]").val($(this).data('modal-btn'))
  $("#request-info-modal #listing_modal_details").val($(this).data('modal-details'))
  $("#request-info-modal #listing_modal_source").val($(this).data('modal-source'))
#
#   $("#home_detail_fields").on "submit", (e)->
#     if $("#home_detail_fields .home-autocomplete-field").val() == ""
#       e.preventDefault()
#       $("#home_detail_fields .home-autocomplete-field").css("border", "2px solid rgb(255, 181, 188)")
#       $("#home_detail_fields .home-autocomplete-field").css("background", "rgb(255, 239, 242)")
#       $("#home_detail_fields .home-autocomplete-field").prop("placeholder", "Please specify the location")
#
#   $("#advanced_search_detail_fields").on "submit", (e)->
#     if $("#advanced_search_detail_fields .advanced-search-autocomplete-field").val() == ""
#       e.preventDefault()
#       $("#advanced_search_detail_fields .advanced-search-autocomplete-field").css("border", "2px solid rgb(255, 181, 188)")
#       $("#advanced_search_detail_fields .advanced-search-autocomplete-field").css("background", "rgb(255, 239, 242)")
#       $("#advanced_search_detail_fields .advanced-search-autocomplete-field").prop("placeholder", "Please specify the location")
#
#   $("#search_filters_details_fields").on "submit", (e)->
#     if $("#search_filters_details_fields .search-filters-autocomplete-field").val() == ""
#       e.preventDefault()
#       $("#search_filters_details_fields .search-filters-autocomplete-field").css("border", "2px solid rgb(255, 181, 188)")
#       $("#search_filters_details_fields .search-filters-autocomplete-field").css("background", "rgb(255, 239, 242)")
#       $("#search_filters_details_fields .search-filters-autocomplete-field").prop("placeholder", "Please specify the location")
#     else
#       $("#search_filters_details_fields .search-filters-autocomplete-field").css("border", "1px solid #ccc")
#       $("#search_filters_details_fields .search-filters-autocomplete-field").css("background", "#fff")
#
#
# $(document).ready ->
#
#   ###======Navigation=====================================###
#
#   if $(window).width() > 769
#     $('.navbar .dropdown').hover (->
#       $(this).addClass('open').find('.dropdown-menu').first().stop(true, true).show()
#       return
#     ), ->
#       $(this).removeClass('open').find('.dropdown-menu').first().stop(true, true).hide()
#       return
#     $('.navbar .dropdown > a').click ->
#       location.href = @href
#       return
#
#   ###===Owl Carousel===========================================================###
#   $('.owl-carousel').each ->
#     $this = $(this)
#     $this.owlCarousel
#       itemsCustom: [
#         [
#           0
#           3
#         ]
#         [
#           450
#           3
#         ]
#         [
#           600
#           3
#         ]
#         [
#           700
#           3
#         ]
#         [
#           1000
#           3
#         ]
#       ]
#       pagination: false
#     # Custom Navigation Events
#     $this.parent().find('.next').click ->
#       $this.trigger 'owl.next'
#       return
#     $this.parent().find('.prev').click ->
#       $this.trigger 'owl.prev'
#       return
#     return
#   return

$ ->
  $('a.page-scroll').bind 'click', (event) ->
    $anchor = $(this)
    $('html, body').stop().animate { scrollTop: $($anchor.attr('href')).offset().top - 50 }, 1250, 'easeInOutExpo'
    event.preventDefault()
    return
  # Closes the Responsive Menu on Menu Item Click
  $('.navbar-collapse ul li a').click ->
    $('.navbar-toggle:visible').click()
    return
  # Fit Text Plugin for Main Header
  #$("h1").fitText(
  #    1.2, {
  #        minFontSize: '35px',
  #        maxFontSize: '65px'
  #    }
  #);
  # Offset for Main Navigation
  $('#mainNav').affix offset: top: 100
  # Scrollify
  #$.scrollify({
  #    section: "section",
  #    offset: -40
  #});
  #var paxman = new Paxman();
  #// Initialize WOW.js Scrolling Animations
  #new WOW().init();
  # Animations
  $('#fullpage').fullpage
    'verticalCentered': false
    'css3': true
    scrollOverflow: true
    paddingTop: '40px'
    paddingBottom: '42px'
    'navigation': true
    'navigationPosition': 'left'
    'navigationTooltips': [
      'Welcome'
      'Cool'
      'Design'
      'Amenities'
      'Welcome'
    ]
    'afterLoad': (anchorLink, index) ->
      if index == 1
        $('section#about .building').addClass 'active'
      return
    'onLeave': (index, nextIndex, direction) ->
      if index == 1 and direction == 'down'
        $('section#about .building').addClass 'active'
      else if index == 2
        $('section#about .building').removeClass 'active'
      else if index == 3 and direction == 'down'
        $('.section').eq(index - 1).removeClass('moveDown').addClass 'moveUp'
      else if index == 3 and direction == 'up'
        $('section#about .building').addClass 'active'
        $('.section').eq(index - 1).removeClass('moveUp').addClass 'moveDown'
      $('#staticImg').toggleClass 'active', index == 2 and direction == 'down' or index == 4 and direction == 'up'
      $('#staticImg').toggleClass 'moveDown', nextIndex == 4
      $('#staticImg').toggleClass 'moveUp', index == 4 and direction == 'up'
      return
  $('#scroll-page-top').click (e) ->
    e.preventDefault()
    $.fn.fullpage.moveTo 1
    return
  $('#scroll-page-down').click (e) ->
    e.preventDefault()
    $.fn.fullpage.moveSectionDown()
    return
  return

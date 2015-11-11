app = angular.module("IceCondos", ["ngResource", "ngtimeago", "numberFilter"])

app.filter 'makeRange', ->
  (input) ->
    lowBound = undefined
    highBound = undefined
    switch input.length
      when 1
        lowBound = 0
        highBound = parseInt(input[0]) - 1
      when 2
        lowBound = parseInt(input[0])
        highBound = parseInt(input[1])
      else
        return input
    result = []
    i = lowBound
    while i <= highBound
      result.push i
      i++
    result

app.factory "Listing", ["$resource", ($resource) ->
  $resource("/listings/:id/:action.json", {id: "@id"}, {request_info: {method: "POST", params: {action: "request_info"}, isArray: false}, create_lead: {method: "POST", params: {action: "create_lead"}, isArray: false}, email_friend: {method: "POST", params: {action: "email_friend"}, isArray: false}})
]

app.factory "Favourite", ["$resource", ($resource) ->
  $resource("/favourites/:id.json", {id: "@id"})
]

app.controller 'ListingsCtrl', ['$scope', '$http', 'Listing', 'Favourite', ($scope, $http, Listing, Favourite) ->
  $scope.Math = window.Math

  $scope.submit_request_form = ->
    $("#request_info_form").addClass('hide')
    $("#request_info_spinner").removeClass('hide')
    $scope.request_info.details = $("#listing_modal_details").val()
    $scope.request_info.source = $("#listing_modal_source").val()
    Listing.request_info({id: $scope.listing.id, request: $scope.request_info}).$promise.then ((data) ->
      $("#request_info_spinner").addClass('hide')
      $("#request_info_success").removeClass('hide')
      return
    ), (error) ->
      $("#request_info_spinner").addClass('hide')
      $("#request_info_error").removeClass('hide')
      return

  $scope.basic_mortgage = ->
    $scope.mortgage = {
      home_price: 500000
      down_payment: 20
      down_payment_type: "percent"
      down_payment_calculated: 500000 * 0.2
      rate: 2.5
      amortization: 25
      amount: 500000 - (500000 * 0.2)
      maintenance: 0
      taxes: 0
      payment: (500000 - (500000 * 0.2)) * ((2.5 / 12 / 100) * Math.pow(1+(2.5 / 12 / 100), 12*25)) / (Math.pow(1+(2.5 / 12 / 100), 12*25)-1)
      full_payment: 0
    }

  $scope.submit_email_friend = ->
    $("#email_friend_form").addClass('hide')
    $("#email_friend_spinner").removeClass('hide')
    console.log $scope.email_friend
    Listing.email_friend({id: $scope.listing.id, email_friend: $scope.email_friend}).$promise.then ((data) ->
      $("#email_friend_spinner").addClass('hide')
      $("#email_friend_success").removeClass('hide')
      return
    ), (error) ->
      $("#email_friend_spinner").addClass('hide')
      $("#email_friend_error").removeClass('hide')
      return

  $scope.submit_new_lead_form = ->
    $("#create_lead_form").addClass('hide')
    $("#create_lead_spinner").removeClass('hide')
    Listing.create_lead({lead: $scope.lead}).$promise.then ((data) ->
      $("#create_lead_spinner").addClass('hide')
      $("#create_lead_success").removeClass('hide')
      return
    ), (error) ->
      $("#create_lead_spinner").addClass('hide')
      $("#create_lead_error").removeClass('hide')
      return

  $scope.loadListing = (id) ->
    $scope.listing = Listing.get({id:id}, ->
      $scope.related_listings = Listing.query({city: $scope.listing.city, listing_type: $scope.listing.listing_type, sample: 12, paginate: 0, notrack: 1}, ->
        $scope.related_listings.pop()
      )
      $scope.current_page = 1
      if $scope.listing.latitude
        $.getJSON '/listings/walkscore?&lat='+$scope.listing.latitude+'&lon='+$scope.listing.longitude, (data) ->
          if data.status == 1
            $scope.current_walkscore = data.walkscore
            $scope.walkscore_howto = data.help_link
            $scope.$apply()

      $scope.cash_back = $scope.listing.lp_dol * 0.025 * 0.15

      $scope.mortgage = {
        home_price: $scope.listing.lp_dol
        down_payment: 20
        down_payment_type: "percent"
        down_payment_calculated: $scope.listing.lp_dol * 0.2
        rate: 2.1
        amortization: 25
        amount: $scope.listing.lp_dol - ($scope.listing.lp_dol * 0.2)
        down_payment_calculated: $scope.listing.lp_dol * 0.2
        maintenance: ($scope.listing.maint || 0) / 12
        taxes: ($scope.listing.taxes || 0) / 12
        payment: 0
        full_payment: 0
      }
      fi = $scope.mortgage.rate / 12 / 100
      $scope.mortgage.payment = $scope.mortgage.amount * (fi * Math.pow(1+fi, 12*$scope.mortgage.amortization)) / (Math.pow(1+fi, 12*$scope.mortgage.amortization)-1)
      $scope.mortgage.full_payment = $scope.mortgage.payment + $scope.mortgage.taxes + $scope.mortgage.maintenance
    )

  $scope.go_to_listing = (id) ->
    window.location = "/listings/"+id

  $scope.load_nearby = (l, types, container) ->
    if( $(container+">.info>center").html() == "Loading..." )
      get_nearby_places(l.latitude, l.longitude, types, container)

  $scope.change_down_payment = (t) ->
    $scope.mortgage.down_payment_type = t
    if t == "dol"
      $scope.mortgage.down_payment = $scope.listing.lp_dol * $scope.mortgage.down_payment / 100
    else
      $scope.mortgage.down_payment = $scope.mortgage.down_payment / $scope.listing.lp_dol * 100

  $scope.recalculate_mortgage = ->
    if $scope.mortgage.down_payment_type == "dol"
      $scope.mortgage.down_payment_calculated = $scope.mortgage.down_payment
    else
      $scope.mortgage.down_payment_calculated = $scope.mortgage.down_payment / 100 * $scope.mortgage.home_price
    $scope.mortgage.amount = $scope.mortgage.home_price - $scope.mortgage.down_payment_calculated
    fi = $scope.mortgage.rate / 12 / 100
    $scope.mortgage.payment = $scope.mortgage.amount * (fi * Math.pow(1+fi, 12*$scope.mortgage.amortization)) / (Math.pow(1+fi, 12*$scope.mortgage.amortization)-1)
    $scope.mortgage.full_payment = $scope.mortgage.payment + $scope.mortgage.taxes + $scope.mortgage.maintenance

  $scope.load_related_listings = (page_num) ->
    if page_num > 0 && page_num < (($scope.listing.city_listing_count / 12) + 1)
      $scope.related_listings = Listing.query({city: $scope.listing.city, page: page_num, notrack: 1}, ->
        $scope.related_listings.pop()
      )
      $scope.current_page = page_num

  $scope.load_search_page = (search) ->
    $scope.search_results_loading = true
    if $scope.search_filters
      search = $scope.search_filters
    else
      search = JSON.parse search
    search["page"] = 1
    search["paginate"] = 1
    search["sort_field"] = $scope.current_sort if $scope.current_sort
    $scope.results = Listing.query(search, ->
      $scope.results_count = $scope.results.pop().count
      $scope.current_page = 1
      $scope.listings = $scope.results
      $scope.search_results_loading = false
      $(window).unbind('scroll')
      $(window).on "scroll", ->
        if($(window).scrollTop() + $(window).height() >= $(document).height() - 400)
          $(window).unbind('scroll')
          $("#load_more_search_results").trigger("click")
    )

  $scope.resort_search_results = (search, sort) ->
    $scope.search_results_loading = true
    if $scope.search_filters
      search = $scope.search_filters
    else
      search = JSON.parse search
    search["page"] = 1
    search["notrack"] = 1
    search["sort_field"] = sort
    $scope.current_sort = sort
    $scope.results = Listing.query(search, ->
      $scope.results_count = $scope.results.pop().count
      $scope.current_page = 1
      $scope.listings = $scope.results
      $scope.search_results_loading = false
      $(window).unbind('scroll')
      $(window).on "scroll", ->
        if($(window).scrollTop() + $(window).height() >= $(document).height() - 400)
          $(window).unbind('scroll')
          $("#load_more_search_results").trigger("click")
    )

  $scope.load_featured_search_listings = (search) ->
    $scope.search_results_loading = true
    if $scope.search_filters
      search = $scope.search_filters
    else
      search = JSON.parse search
    search["page"] = 1
    search["notrack"] = 1
    search["custom_search"]["featured"] = true
    $scope.search_filters.custom_search.featured = true
    $scope.results = Listing.query(search, ->
      $scope.results_count = $scope.results.pop().count
      $scope.current_page = 1
      $scope.listings = $scope.results
      $scope.search_results_loading = false
      $(window).unbind('scroll')
      $(window).on "scroll", ->
        if($(window).scrollTop() + $(window).height() >= $(document).height() - 400)
          $(window).unbind('scroll')
          $("#load_more_search_results").trigger("click")
    )

  $scope.load_search_listings = (page_num, results_count, search) ->
    if page_num > 0 && page_num < ((results_count / 12) + 1)
      $scope.search_results_loading = true
      if $scope.search_filters
        search = $scope.search_filters
      else
        search = JSON.parse search
      search["page"] = page_num
      search["sort_field"] = $scope.current_sort if $scope.current_sort
      search["notrack"] = 1
      $scope.results = Listing.query(search, ->
        $scope.results_count = $scope.results.pop().count
        $scope.current_page = page_num
        $scope.listings = $scope.results
        $scope.search_results_loading = false
        $(window).unbind('scroll')
        $(window).on "scroll", ->
          if($(window).scrollTop() + $(window).height() >= $(document).height() - 400)
            $(window).unbind('scroll')
            $("#load_more_search_results").trigger("click")
      )

  $scope.add_favourite = (listing_id) ->
    $scope.favourite = new Favourite()
    $scope.favourite.favouriteable_type = "Listing"
    $scope.favourite.favouriteable_id = listing_id
    Favourite.save $scope.favourite, ->
      $("#favourite").html("SAVED")
      $("#favourite").attr("disabled", "disabled")
    , ->
      alert "Something went wrong! Please try again later."

  $scope.load_favourites = ->
    $scope.favourites = Favourite.query({}, ->
      $scope.listings = chunk($scope.favourites, 4)
    )

  $scope.toggle_search_results = (api_key, search) ->
    if $scope.map_displayed
      $("#map_results").hide()
      $("#search_results").show()
      $scope.map_displayed = false
      $scope.search_filters["ids_only"] = 0
      $scope.search_filters["paginate"] = 1
      $scope.results = Listing.query($scope.search_filters, ->
        $scope.results_count = $scope.results.pop().count
        $scope.current_page = 1
        $scope.listings = $scope.results
        $scope.search_results_loading = false
        $(window).unbind('scroll')
        $(window).on "scroll", ->
          if($(window).scrollTop() + $(window).height() >= $(document).height() - 400)
            $(window).unbind('scroll')
            $("#load_more_search_results").trigger("click")
      )
    else
      $scope.map_loading = true
      $("#search_results").hide()
      $("#map_results").show()
      unless $scope.full_json_set
        L.mapbox.accessToken = 'pk.eyJ1IjoidHp1YnlhayIsImEiOiIxNmI5OTMzYzM0NTdhZjc3MDJiNGQ5YjI0NWQ2MTg0YSJ9.xA_OjQLoZREbHhOX-XW0jQ'
        window.map = L.mapbox.map('map', 'tzubyak.m8nb9c8d')
        $.getJSON '/map_data/full_data.json', (data) ->
          $scope.full_json_set = data
          if $scope.search_filters
            search = $scope.search_filters
          else
            search = JSON.parse search
          console.log search
          search["notrack"] = 1
          load_map_results(search, $scope.full_json_set)
      else
        if $scope.search_filters
          search = $scope.search_filters
        else
          search = JSON.parse search
        search["notrack"] = 1
        load_map_results(search, $scope.full_json_set)
      $('.map-container').height($(window).height() - 90)
      $scope.map_displayed = true

  load_map_results = (search, local_storage_map_data) ->
    search["paginate"] = 0
    search["ids_only"] = 1
    $scope.all_results = []
    Listing.query(search).$promise.then ((data1) ->
      data1.map (d) ->
        $scope.all_results.push local_storage_map_data[d.id] if local_storage_map_data[d.id]?
      if window.markers
        window.markers.clearLayers()
      window.markers = new (L.MarkerClusterGroup)
      for d in $scope.all_results
        if d.latitude
          marker = L.marker(new (L.LatLng)(d.latitude, d.longitude),{ id: d.id, lat: d.latitude, long: d.longitude }).on 'click', (e)->
            load_info_box(e)
          window.markers.addLayer marker
      $scope.map_loading = false
      map.addLayer window.markers
      map.fitBounds(window.markers.getBounds());
      return
    ), (error) ->
      alert "Something went wrong. Please reload the page."
      return

  reset_results = ->
    $scope.map_results_list = []
    $scope.map_results_loading = true
    $scope.map_loading = true
    $scope.$apply()

  update_pin_listings = ->
    $scope.map_results_loading = true
    if !$scope.$$phase
      $scope.$apply()
    $scope.results_to_show = []
    bounds = map.getBounds()
    for res in $scope.all_results
      if res.latitude
        $scope.results_to_show.push(res) if bounds.contains(new (L.LatLng)(res.latitude, res.longitude))
    $scope.map_results_page = 1
    c_ids = []
    for el in $scope.results_to_show[0..11]
      c_ids.push el.id

    if c_ids.length > 0
      $scope.map_results_list = Listing.query({"ids[]": c_ids}, ->
        $scope.map_results_loading = false
      )
    else
      $scope.map_results_list = []
      $scope.map_results_loading = false

    $scope.map_loading = false
    if !$scope.$$phase
      $scope.$apply()

  $scope.next_map_page = ->
    if ($scope.map_results_page * 12 < $scope.results_to_show.length)
      $scope.map_results_list = []
      $scope.map_results_loading = true
      $scope.map_results_page += 1
      c_ids = []
      for el in $scope.results_to_show[(($scope.map_results_page-1)*12)..(($scope.map_results_page*12)-1)]
        c_ids.push el.id
      $scope.map_results_list = Listing.query({"ids[]": c_ids}, ->
        $scope.map_results_loading = false
      )

  $scope.prev_map_page = ->
    if $scope.map_results_page > 1
      $scope.map_results_list = []
      $scope.map_results_loading = true
      $scope.map_results_page -= 1
      c_ids = []
      for el in $scope.results_to_show[(($scope.map_results_page-1)*12)..(($scope.map_results_page*12)-1)]
        c_ids.push el.id
      $scope.map_results_list = Listing.query({"ids[]": c_ids}, ->
        $scope.map_results_loading = false
      )

  $scope.load_listing_items = (listing_type) ->
    $scope.search_results_loading = true
    search = {}
    search["notrack"] = 1
    search["sample"] = 4
    search["paginate"] = 0

    navigator.geolocation.getCurrentPosition ( (data) ->
      search["geolocation"] = true
      search["latitude"] = data.coords.latitude
      search["longitude"] = data.coords.longitude
      $scope.results = Listing.query(search, ->
        $scope.results.pop()
        $scope.listings = $scope.results
        $scope.search_results_loading = false
      )
    )
    setTimeout (->
      if !search["latitude"]
        search["custom_search"] = {}
        search["custom_search"]["featured"] = true

        $scope.results = Listing.query(search, ->
          $scope.results.pop()
          $scope.listings = $scope.results
          $scope.search_results_loading = false
        )
    ), 3000

  $scope.refine_search_results = ->
    if $scope.map_displayed
      $scope.map_loading = true
    $("#modal-search-filters").modal('hide')
    $scope.search_filters.query = $(".search-filters-autocomplete-field").val()
    $scope.search_filters.locality = $("#refine-locality").val()
    $scope.search_filters.route = $("#refine-route").val()
    $scope.search_filters.lat = $("#refine-lat").val()
    $scope.search_filters.lng = $("#refine-lng").val()
    $scope.search_filters.administrative_area_level_1 = $("#refine-administrative_area_level_1").val()
    $scope.search_results_loading = true
    $scope.search_filters["page"] = 1
    $scope.search_filters["ids_only"] = 0
    $scope.search_filters["notrack"] = 0
    $scope.search_filters["sort_field"] = $scope.current_sort if $scope.current_sort
    if $scope.map_displayed
      load_map_results($scope.search_filters, $scope.full_json_set)
      $scope.search_results_loading = false
      $scope.map_loading = false
    else
      $scope.results = Listing.query($scope.search_filters, ->
        $scope.results_count = $scope.results.pop().count
        $scope.current_page = 1
        $scope.listings = $scope.results
        $scope.search_results_loading = false
        $(window).unbind('scroll')
        $(window).on "scroll", ->
          if($(window).scrollTop() + $(window).height() >= $(document).height() - 400)
            $(window).unbind('scroll')
            $("#load_more_search_results").trigger("click")
      )

  $scope.map_paging = ->
    if ($scope.map_results_page * 12 < $scope.results_to_show.length)
      $scope.map_results_page += 1
      c_ids = []
      for el in $scope.results_to_show[(($scope.map_results_page-1)*12)..(($scope.map_results_page*12)-1)]
        c_ids.push el.id
      new_listings = Listing.query({"ids[]": c_ids}, ->
        $scope.map_results_list = $scope.map_results_list.concat(new_listings)
      )

  $scope.search_paging = (search) ->
    if $scope.current_page * 12 < $scope.results_count
      $scope.search_results_loading = true
      if $scope.search_filters
        $scope.search_filters["ids_only"] = 0
        $scope.search_filters["paginate"] = 1
        search = $scope.search_filters
      else
        search = JSON.parse search
      search["page"] = $scope.current_page + 1
      search["sort_field"] = $scope.current_sort if $scope.current_sort
      search["notrack"] = 1
      new_results = Listing.query(search, ->
        $scope.results = $scope.results.concat(new_results)
        $scope.results_count = $scope.results.pop().count
        $scope.current_page = $scope.current_page + 1
        $scope.listings = $scope.results
        $scope.search_results_loading = false
        $(window).unbind('scroll')
        $(window).on "scroll", ->
          if($(window).scrollTop() + $(window).height() >= $(document).height() - 400)
            $(window).unbind('scroll')
            $("#load_more_search_results").trigger("click")
      )
]

// (function () {
//
//   var _defaults = {
//       debug              : false,
//       pinTypeName        : 'pin_clusterer pin',
//       clusterTypeName    : 'pin_clusterer cluster',
//       pinHeight            : 40,
//       pinWidth            : 28,
//       extendMapBoundsBy  : 2,
//       gridSize          : 100,
//       maxZoom            : 16,
//       clickToZoom        : true,
//       onClusterToMap    : null
//     },
//
//     // Minimum zoom level before bounds dissappear
//     MIN_ZOOM = 2,
//
//     // Alias for Microsoft.Maps
//     mm = null;
//
//     window.infobox = null;
//
//     var current_data_object = null;
//
//   /*
//    *   @param { Microsoft.Maps.Map } map: the map to be show the clusters on
//    *   @param { Object } options: support the following options:
//    *     gridSize      : (number) The grid size of a cluster in pixels.
//    *    maxZoom        : (number) The maximum zoom level that a pin can be part of a cluster.
//    *    onClusterToMap: a function that accepts a parameter pointing at the center of each cluster.
//    *      It gets called before the cluster is added to the map, so you can change the all options
//    *      by calling center.setOptions(Microsoft.Maps.PushpinOptions)
//    *      where center is an instance of Microsoft.Maps.Pushpin
//    *
//    *   @properties:
//    *    layer      : (Microsoft.Maps.Layer) the layer holding the clusters
//    *     options    : (Array)   a copy of the options passed
//    *    gridSize  : (number)   the actual grid size used
//    *    maxZoom    : (number)  the actual maximum zoom used
//    *
//    */
//
//   var PinClusterer = window.PinClusterer = function (map, options) {
//     this.map       = map;
//     this.options    = options;
//     this.layer      = null;
//
//     this.setOptions(this.options);
//     this.doClickToZoom = _defaults.clickToZoom;
//
//     if (Microsoft && Microsoft.Maps && (map instanceof Microsoft.Maps.Map))  {
//
//       // Create a shortcut
//       mm = Microsoft.Maps;
//
//       this.layer = new mm.EntityCollection();
//       this.map.entities.push(this.layer);
//       this.loaded = true;
//
//       var infoboxLayer = new mm.EntityCollection();
//       this.map.entities.push(infoboxLayer);
//
//       infobox = new mm.Infobox(new mm.Location(0, 0), { visible: false, offset: new Microsoft.Maps.Point(0, 20) });
//       infoboxLayer.push(infobox);
//     }
//   };
//
//   PinClusterer.prototype = {
//
//     cluster: function (latlongs) {
//       if (!this.loaded) return;
//       if (!latlongs) {
//         if (!this._latlongs) return;
//       } else {
//         this._latlongs = latlongs;
//       }
//       var self = this;
//       if (this._viewchangeendHandler) {
//         this._redraw();
//       } else {
//         this._viewchangeendHandler = mm.Events.addHandler(this.map, 'viewchangeend', function() { self._redraw(); });
//       }
//     },
//
//     _redraw: function () {
//       if (_defaults.debug) var started = new Date();
//       if (!this._latlongs) return;
//       this._metersPerPixel  = this.map.getMetersPerPixel();
//       this._bounds           = this.getExpandedBounds(this.map.getBounds(), _defaults.extendMapBoundsBy);
//       this._zoom             = this.map.getZoom();
//       this._clusters         = [];
//       this.doClickToZoom     = true;
//       this.layer.clear();
//       this.each(this._latlongs, this._addToClosestCluster);
//       this.toMap();
//       if (_defaults.debug && started) _log((new Date()) - started);
//     },
//
//     _addToClosestCluster: function (latlong) {
//       current_data_object = latlong;
//       var distance       = 40000,
//         location         = new mm.Location(latlong.latitude, latlong.longitude),
//         clusterToAddTo   = null,
//         d;
//       if (this._zoom > MIN_ZOOM && !this._bounds.contains(location)) return;
//
//       if (this._zoom >= _defaults.maxZoom) {
//         this.doClickToZoom = false;
//         this._createCluster(location, latlong);
//         return;
//       }
//
//       this.each(this._clusters, function (cluster) {
//         d = this._distanceToPixel(cluster.center.location, location);
//         if (d < distance) {
//           distance = d;
//           clusterToAddTo = cluster;
//         }
//       });
//
//       if (clusterToAddTo && clusterToAddTo.containsWithinBorders(location)) {
//         clusterToAddTo.add(location, latlong);
//       } else {
//         this._createCluster(location, latlong);
//       }
//     },
//
//     _createCluster: function (location, data_object) {
//       var cluster = new Cluster(this);
//       cluster.add(location, data_object);
//       this._clusters.push(cluster);
//     },
//
//     setOptions: function (options) {
//       for (var opt in options)
//         if (typeof _defaults[opt] !== 'undefined') _defaults[opt] = options[opt];
//     },
//
//     toMap: function () {
//       this.each(this._clusters, function (cluster) {
//         cluster.toMap();
//       });
//     },
//
//     getExpandedBounds: function (bounds, gridFactor) {
//       var northWest = this.map.tryLocationToPixel(bounds.getNorthwest()),
//         southEast    = this.map.tryLocationToPixel(bounds.getSoutheast()),
//         size         = gridFactor ? _defaults.gridSize * gridFactor : _defaults.gridSize / 2;
//       if (northWest && southEast) {
//         northWest = this.map.tryPixelToLocation(new mm.Point(northWest.x - size, northWest.y - size));
//         southEast = this.map.tryPixelToLocation(new mm.Point(southEast.x + size, southEast.y + size));
//         if (northWest && southEast) {
//           bounds = mm.LocationRect.fromCorners(northWest, southEast);
//         }
//       }
//       return bounds;
//     },
//
//     _distanceToPixel: function (l1, l2) {
//       return PinClusterer.distance(l1, l2) * 1000 / this._metersPerPixel;
//     },
//
//     each: function (items, fn) {
//       if (!items.length) return;
//       for (var i = 0, item; item = items[i]; i++) {
//         var rslt = fn.apply(this, [item, i]);
//         if (rslt === false) break;
//       }
//     }
//
//   };
//
//   PinClusterer.distance = function(p1, p2) {
//     if (!p1 || !p2) return 0;
//     var R    = 6371, // Radius of the Earth in km
//       pi180 = Math.PI / 180;
//       dLat   = (p2.latitude - p1.latitude) * pi180,
//       dLon   = (p2.longitude - p1.longitude) * pi180,
//       a      = Math.sin(dLat / 2) * Math.sin(dLat / 2)
//                + Math.cos(p1.latitude * pi180) * Math.cos(p2.latitude * pi180) *
//                Math.sin(dLon / 2) * Math.sin(dLon / 2),
//       c     = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a)),
//       d     = R * c;
//     return d;
//   };
//
//   var Cluster = function (pinClusterer) {
//     this._pinClusterer   = pinClusterer;
//     this.locations       = [];
//     this.center          = null;
//     this._bounds        = null;
//     this.length          = 0;
//     this.doClickToZoom  = null;
//   };
//
//   Cluster.prototype = {
//     add: function (location, data_object) {
//       if (this._alreadyAdded(location)) return;
//       this.locations.push(location);
//       this.length += 1;
//       if (!this.center) {
//         this.center = new Pin(location, this, {id: "pin_" + data_object.class_name + "_" + data_object.id });
//         this._calculateBounds();
//       }
//     },
//
//     containsWithinBorders: function (location) {
//       if (this._bounds) return this._bounds.contains(location);
//       return false;
//     },
//
//     zoom: function () {
//       this._pinClusterer.map.setView({ center: this.center.location, zoom: _defaults.maxZoom });
//     },
//
//     _alreadyAdded: function (location) {
//       if (this.locations.indexOf) {
//         return this.locations.indexOf(location) > -1;
//       } else {
//         for (var i = 0, l; l = this.locations[i]; i++) {
//           if (l === location) return true;
//         }
//       }
//       return false;
//     },
//
//     _calculateBounds: function () {
//       var bounds = mm.LocationRect.fromLocations(this.center.location);
//       this._bounds = this._pinClusterer.getExpandedBounds(bounds);
//     },
//
//     toMap: function () {
//       this._updateCenter();
//       this.center.toMap(this._pinClusterer.layer);
//       if (!_defaults.debug) return;
//       var north = this._bounds.getNorth(),
//         east    = this._bounds.getEast(),
//         west    = this._bounds.getWest(),
//         south    = this._bounds.getSouth(),
//         nw       = new mm.Location(north, west),
//         se       = new mm.Location(south, east),
//         ne       = new mm.Location(north, east)
//         sw       = new mm.Location(south, west),
//         color   = new mm.Color(100, 100, 0, 100),
//         poly     = new mm.Polygon([nw, ne, se, sw], { fillColor: color, strokeColor: color, strokeThickness: 1 });
//       this._pinClusterer.layer.push(poly);
//     },
//
//     _updateCenter: function () {
//       var count   = this.locations.length,
//         text       = '',
//         typeName   = _defaults.pinTypeName;
//       if (count > 1) {
//         text += count;
//         typeName = _defaults.clusterTypeName;
//       }
//       this.center.pushpin.setOptions({
//         text      : text,
//         typeName  : typeName
//       });
//       if (_defaults.onClusterToMap) {
//         _defaults.onClusterToMap.apply(this._pinClusterer, [this.center.pushpin, this]);
//       }
//     }
//   };
//
//   var Pin = function (location, cluster, options) {
//     this.location = location;
//     this._cluster = cluster;
//
//     // The default options of the pushpin showing at the centre of the cluster
//     // Override within onClusterToMap function
//
//     this._options             = options || {};
//     this._options.typeName     = this._options.typeName || _defaults.pinTypeName;
//     this._options.height       = _defaults.pinHeight;
//     this._options.width       = _defaults.pinWidth;
//     this._options.anchor       = new mm.Point(_defaults.pinWidth / 2, _defaults.pinHeight / 2);
//     this._options.textOffset   = new mm.Point(0, 2);
//     this._create();
//   };
//
//   Pin.prototype = {
//     _create: function () {
//       this.pushpin  = new mm.Pushpin(this.location, this._options);
//       pin_id = this._options.id;
//       boxes_html[this._options.id] = "<div class='custom-infobox'><a class='infobox-close' href='#' onclick='infobox.setOptions({visible:false});return false;'>x</a><div class='media'><div class='media-left'><img src='http://zumin.s3.amazonaws.com/listing_photos/"+current_data_object._type+"_"+current_data_object.id+"_0.jpg' onerror='this.onerror=null;this.src=\"/missing-image.png\";'></div><div class='media-body'><h4><a target='_self' href='/listings/"+ current_data_object.id +"'>"+current_data_object.addr+", "+current_data_object.municipality+"</a></h4><p>$"+numberWithCommas(current_data_object.lp_dol)+"<br>"+current_data_object.br+" beds, "+current_data_object.bath_tot+" baths</p><div></div></div></div></div>"
//
//       if (this._cluster.doClickToZoom) {
//         var self = this;
//         mm.Events.addHandler(this.pushpin, 'mouseup', function () { self._cluster.zoom(); });
//       }
//       mm.Events.addHandler(this.pushpin, 'click', function(e){
//         if (e.targetType == 'pushpin') {
//           infobox.setLocation(e.target.getLocation());
//           infobox.setOptions({ visible: true, htmlContent: boxes_html[e.target._id] });
//         }
//       });
//     },
//
//     toMap: function (layer) {
//       layer.push(this.pushpin);
//     }
//   };
//
//
//   var _log = function (msg) {
//     if (console && console.log) console.log(msg);
//   };
//
// })();
//
function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

$(function(){
  Microsoft.Maps.registerModule('clusterModule', '/V7ClientSideClustering.js');
  Microsoft.Maps.loadModule('clusterModule', {});
});

function clusterLoaded(map) {
  window.greenLayer = new ClusteredEntityCollection(map, {
    singlePinCallback: createPin,
    clusteredPinCallback: createClusteredpin
  });
  window.infobox = null;

  var infoboxLayer = new Microsoft.Maps.EntityCollection();
  map.entities.push(infoboxLayer);

  infobox = new Microsoft.Maps.Infobox(new Microsoft.Maps.Location(0, 0), { visible: false, offset: new Microsoft.Maps.Point(0, 20) });
  infoboxLayer.push(infobox);
}

function createClusteredpin(cluster, latlong)
{
  var pin = new Microsoft.Maps.Pushpin(latlong, {
    icon: '/icon-location-group.png',
    anchor: new Microsoft.Maps.Point(20, 20),
    width: 40,
    height:40,
    text: "" + cluster.length,
    textOffset: new Microsoft.Maps.Point(0, 13),
  });
  pin.pin_id = cluster[0].id;
  var boxes_html = "<div class='custom-infobox'><a class='infobox-close' href='#' onclick='infobox.setOptions({visible:false});return false;'>x</a><div class='media'><center><img src='/orange_loading.gif' style='width:75px;height:75px;'/></center></div></div>"
  Microsoft.Maps.Events.addHandler(pin, 'click', function(e){
    if (e.targetType == 'pushpin') {
      displayInfoBox(cluster[0]._LatLong, boxes_html);
      load_info_box(cluster[0].id);
      window.blah = e.target;
    }
  });
  return pin;
}

function createPin(data)
{
  var pin = new Microsoft.Maps.Pushpin(data._LatLong, {
    icon: '/icon-location.png',
    width: 28
  });
  pin.pin_id = data.id
  var boxes_html = "<div class='custom-infobox'><a class='infobox-close' href='#' onclick='infobox.setOptions({visible:false});return false;'>x</a><div class='media'><center><img src='/orange_loading.gif' style='width:75px;height:75px;'/></center></div></div>"
  Microsoft.Maps.Events.addHandler(pin, 'click', function(e){
    if (e.targetType == 'pushpin') {
      displayInfoBox(data._LatLong, boxes_html);
      load_info_box(data.id);
      window.blah = e.target;
    }
  });
  return pin;
}

function displayInfoBox(loc, html_str) {
  infobox.setLocation(loc);
  infobox.setOptions({visible: true, htmlContent: html_str});
}
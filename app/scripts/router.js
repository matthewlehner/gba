define([
  // Application.
  'app',
  'collections/buildings',
  'views/map'
],

function(app, buildingCollection, mapView) {

  // Defining the application router, you can attach sub routers here.
  var Router = Backbone.Router.extend({
    routes: {
      "": "index"
    },

    index: function() {
      var items = new buildingCollection();
      app.items = items;

      app.useLayout('map_panel').setViews({
        '.controls': new mapView.controls({
          items: items
        }),
        '.tiles'   : new mapView.tiles({
          items: items
        })
      }).render();

      items.fetch({dataType: 'jsonp', reset: true});
    }
  });

  return Router;

});

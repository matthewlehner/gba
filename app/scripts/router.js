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
      var sites = new buildingCollection();

      app.useLayout('map_panel').setViews({
        '.controls': new mapView.controls({
          collection: sites
        }),
        '.tiles'   : new mapView.tiles({
          collection: sites
        })
      }).render();

    }
  });

  return Router;

});

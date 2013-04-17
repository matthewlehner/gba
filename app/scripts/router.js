define([
  // Application.
  'app',
  'collections/items',
  'views/map'
],

function(app, itemCollection, mapView) {

  // Defining the application router, you can attach sub routers here.
  var Router = Backbone.Router.extend({
    routes: {
      "": "index"
    },

    index: function() {
      var items = new itemCollection();
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

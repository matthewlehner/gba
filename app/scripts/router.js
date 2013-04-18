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
          el: false,
          items: items
        }),
        '.tiles'   : new mapView.tiles({
          collection: items
        }),
        '.item-container' : new mapView.items({
          el: false,
          collection: items
        })
      }).render();

      items.fetch({dataType: 'jsonp', reset: true});

    }
  });

  return Router;

});

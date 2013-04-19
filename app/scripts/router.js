'use strict';
define([
  // Application.
  'app',
  'collections/items',
  'views/map'
],

function(app, ItemCollection, mapView) {

  // Defining the application router, you can attach sub routers here.
  var Router = Backbone.Router.extend({
    routes: {
      '': 'index'
    },

    index: function() {
      var items = new ItemCollection();
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

      app.layout.listenTo(items, 'open', function () {
        app.layout.$el.find('.item-container').css('height', $('body').height()+'px').addClass('open');
      });

      app.layout.listenTo(items, 'close', function() {
        app.layout.$el.find('.item-container').css('height', '').removeClass('open');
      });

      items.fetch({reset: true});

    }
  });

  return Router;

});

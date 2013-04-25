'use strict';
define([
  // Application.
  'app',
  'collections/items',
  'views/map_tiles',
  'views/controls',
  'views/items'
],

function(app, ItemCollection, MapTiles, ControlsView, ItemsView) {

  // Defining the application router, you can attach sub routers here.
  var Router = Backbone.Router.extend({
    routes: {
      '': 'index'
    },

    index: function() {
      var items = new ItemCollection();
      app.items = items;

      app.useLayout('map_panel').setViews({
        '.controls': new ControlsView({
          el: false,
          collection: items
        }),
        '.tiles'   : new MapTiles({
          el: false,
          collection: items
        }),
        '.item-container' : new ItemsView({
          el: false,
          collection: items
        })
      }).render();

      app.layout.listenTo(items, 'open', function () {
        this.$el.find('.item-container').
          height($('#main').height()).
        end().
        addClass('open-item');
      });

      app.layout.listenTo(items, 'close', function() {
        this.$el.find('.item-container').
          css('height', '').
        end().
        removeClass('open-item');
      });

      items.fetch({reset: true});

    }
  });

  return Router;

});

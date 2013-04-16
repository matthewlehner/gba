define([
  // Application.
  'app',
  'collections/buildings',
  'views/main'
],

function(app, buildingCollection, mainView) {

  // Defining the application router, you can attach sub routers here.
  var Router = Backbone.Router.extend({
    routes: {
      "": "index"
    },

    index: function() {
      var collection = new buildingCollection();

      app.useLayout('main').setViews({
        '.bar': new mainView({
          collection: collection
        })
      }).render();

    }
  });

  return Router;

});

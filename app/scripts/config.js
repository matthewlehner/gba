/*global require*/
'use strict';

require.config({
  deps: ["main"],

  paths: {
    jquery: '../components/jquery/jquery',
    leaflet: '../components/leaflet/dist/leaflet-src',
    backbone: '../components/backbone/backbone',
    lodash: '../components/lodash/dist/lodash.underscore',
    'backbone.layoutmanager': '../components/layoutmanager/backbone.layoutmanager',
    'FastClick': '../components/fastclick/lib/fastclick'
  },

  map: {
    // Ensure Lo-Dash is used instead of underscore.
    "*": { "underscore": "lodash" }
  },

  shim: {
    backbone: {
      deps: [
          'underscore',
          'jquery'
      ],
      exports: 'Backbone'
    },
    "backbone.layoutmanager": {
      deps: [ 'backbone' ],
      exports: "Backbone.Layout"
    }
  }
});

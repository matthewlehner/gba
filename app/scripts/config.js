/*global require*/
'use strict';

require.config({
  deps: ['main'],

  paths: {
    jquery                   : '../components/jquery/jquery',
    leaflet                  : '../components/leaflet/dist/leaflet-src',
    'leaflet.markercluster'  : '../components/leaflet.markerclusterer/dist/leaflet.markercluster',
    backbone                 : '../components/backbone/backbone',
    lodash                   : '../components/lodash/dist/lodash.underscore',
    'backbone.layoutmanager' : '../components/layoutmanager/backbone.layoutmanager',
    'FastClick'              : '../components/fastclick/lib/fastclick',
    'spin'                   : '../components/spin.js/spin',
    'jquery.spinner'         : '../components/spin.js/jquery.spin',
    'jquery.lazyload'        : '../components/jquery.lazyload/jquery.lazyload',
    'domReady'               : '../components/requirejs-domready/domready'
  },

  map: {
    // Ensure Lo-Dash is used instead of underscore.
    '*': { 'underscore': 'lodash' }
  },

  shim: {
    backbone: {
      deps: [
        'underscore',
        'jquery'
      ],
      exports: 'Backbone'
    },
    'backbone.layoutmanager': {
      deps: [ 'backbone' ],
      exports: 'Backbone.Layout'
    },
    'leaflet.markercluster': {
      deps: [ 'leaflet' ]
    },
    'jquery.lazyload': {
      deps: [ 'jquery' ]
    }
  }
});

define [
  'app'
], (app) ->
  class ControlsView extends Backbone.Layout
    template: 'map/controls'

    initialize: ->
      @listenTo @collection,
        'searching'        : @searching
        'searchSuccessful' : @searchSuccess

      @listenTo app,
        'locationfound'    : @geoFinish
        'locationError'    : @geoError

    events:
      'submit #search'     : 'search'
      'click .view-toggle' : 'viewToggle'
      'click .filters'     : 'filters'
      'click .geo-locate'  : 'geo'
      'click .info'        : 'info'

    search: (e) =>
      e.preventDefault()
      e.stopImmediatePropagation()
      params = $(e.target)
        .find('input[name=q]')
          .blur()
        .end()
        .serialize()

      @collection.search(params)

    viewToggle: (e) =>
      app.trigger 'viewToggle'

    filters: (e) =>
      alert 'filters dialogue should be triggered'

    geo: (e) =>
      app.trigger 'geoLocate'
      @$el.find('.geo-locate').addClass 'active-geo'

    geoFinish: =>
      @$el.find('.geo-locate').removeClass 'active-geo'

    geoError: =>
      alert 'Location service is off. The Green Building App needs access to your location to find green buildings nearby. Please turn on Location Services in your device settings.'
      @geoFinish()


    info: (e) =>
      alert 'Information about the Green Building App.'

    searching: ->
      @$el.find('.search-label').spin('small').addClass 'active-search'

    searchSuccess: ->
      @$el.find('.search-label').spin(false).removeClass 'active-search'

  return ControlsView

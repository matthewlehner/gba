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
        'locationfound locationError': @geoFinish

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
      @$el.find('.geo-locate').spin('small').addClass 'active-geo'

    geoFinish: =>
      @$el.find('.geo-locate').spin(false).removeClass 'active-geo'

    info: (e) =>
      alert 'Information about the Green Building App.'

    searching: ->
      @$el.find('.search-label').spin('small').addClass 'active-search'

    searchSuccess: ->
      @$el.find('.search-label').spin(false).removeClass 'active-search'

  return ControlsView

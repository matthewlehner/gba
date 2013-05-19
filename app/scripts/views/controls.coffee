define [
  'app'
  'views/info'
  'views/filter'
], (app, InfoView, FilterView) ->
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
      new FilterView
        collection: @collection

    geo: (e) =>
      app.trigger 'geoLocate'
      @$el.find('.geo-locate').addClass 'active-geo'

    geoFinish: =>
      @$el.find('.geo-locate').removeClass 'active-geo'

    geoError: =>
      # TODO refactor this into a helper function.

      view = new InfoView
        className: 'modal-wrapper fade'
        header: 'Location service is off'
        content: 'The Green Building App needs access to your location to find green buildings nearby. Please turn on Location Services in your device settings.'

      view.render()

      $('#main').append(view.$el)

      setTimeout =>
        view.$el.removeClass 'fade'
      , 1

      @geoFinish()

    info: (e) =>
      # TODO refactor this into a helper function.

      view = new InfoView
        className: 'modal-wrapper fade'
        content: 'Info copy about GBA.'
      view.render()

      $('#main').append(view.$el)

      setTimeout =>
        view.$el.removeClass 'fade'
      , 1

    searching: ->
      @$el.find('.search-label').spin('small').addClass 'active-search'

    searchSuccess: ->
      @$el.find('.search-label').spin(false).removeClass 'active-search'

  return ControlsView

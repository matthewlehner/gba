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
      'keyup #q'           : 'showOrHideClearControl'
      'click .search-clear': 'clearSearch'
      'click .view-toggle' : 'viewToggle'
      'click .filters'     : 'filters'
      'click .geo-locate'  : 'geo'
      'click .info'        : 'info'

    search: (e) =>
      e.preventDefault()
      e.stopImmediatePropagation()
      app.searchMode = true
      params = $(e.target)
        .find('input[name=q]')
          .blur()
        .end()
        .serialize()

      @collection.search(params)

    showOrHideClearControl: (e) =>
      if _.isEmpty $('#q').val()
        $('.search-clear').hide()
      else
        $('.search-clear').show()

    clearSearch: (e) =>
      $('#q').val('')

      @showOrHideClearControl()
      @collection.fetch
        data:
          latlng: app.mapControl.currentLatLng

      app.searchMode = false
      if $('#main').hasClass('list')
        @viewToggle()

    viewToggle: (e) =>
      if app.searchMode is true
        app.trigger 'map:fitmarkers'
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
      new InfoView
        header: 'Location service is off'
        content: 'The Green Building App needs access to your location to find green buildings nearby. Please turn on Location Services in your device settings.'

      @geoFinish()

    info: (e) =>
      new InfoView
        content: 'A project of the Open Green Building Society with support from the City of Vancouver, the Canada and Cascadia Green Building Councils.'

    searching: ->
      @$el.find('.search-label').spin('small').addClass 'active-search'

    searchSuccess: ->
      @$el.find('.search-label').spin(false).removeClass 'active-search'
      if @collection.length is 0
        @searchNoResults()

    searchNoResults: ->
      new InfoView
        content: "Your search for '#{$('#q').val()}' hasn't returned any results."

  return ControlsView

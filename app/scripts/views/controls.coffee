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
        className: 'modal-wrapper fade'
        content: "<p>A project of the <a href='http://opengreenbuilding.org/'>Open Green Building Society</a> with support from the <a hrev='http://vancouver.ca/green-vancouver/a-bright-green-future.aspx'>City of Vancouver</a>, the Canada and Cascadia Green Building Councils.</p>\n<p>For more information on the app, please visit <a href='http://greenbuildingapp.com/'>greenbuildingapp.com</a>.</p>\n<p>Data is loaded from the <a href='http://greenbuildignbrain.org/'>Green Building Brain</a>, please submit fixes and ehancements there.</p>\n<p>Audio Tours provided by <a href='http://greenbuildingaudiotours.com'>Green Building Audio Tours</a>. Get an audio tour for your building today!</p>"

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

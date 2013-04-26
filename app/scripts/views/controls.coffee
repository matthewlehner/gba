define [
  'app'
], (app) ->
  class ControlsView extends Backbone.Layout
    template: 'map/controls'

    events:
      'submit form'        : 'search'
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

    info: (e) =>
      alert 'Information about the Green Building App.'

  return ControlsView

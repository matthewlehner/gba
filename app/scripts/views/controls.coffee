define [
  'app'
], (app) ->
  class ControlsView extends Backbone.Layout
    template: 'map/controls'

    events:
      'submit form'        : 'search'
      'click .view-toggle' : 'listView'
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

    cool: (e) ->
      e.preventDefault()
      e.stopImmediatePropagation()
      alert "#{e.currentTarget.className}, #{e.originalEvent}"

    listView: (e) =>
      @cool(e)

    filters: (e) =>
      @cool(e)

    geo: (e) =>
      app.trigger 'geoLocate'

    info: (e) =>
      @cool(e)

  return ControlsView

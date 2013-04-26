define [
  'app'
], (app) ->

  class ResultsPanel extends Backbone.Layout
    initialize: ->
      @listenTo @collection,
        'searchSuccessful' : @addResults
        'mapSelect'        : @preview

      @addResults(@collection, false)

    addResults: (collection, render) =>
      @collection.each (item) =>
        @insertView new ResultItem
          id: "item-#{item.id}"
          className: "item"
          model: item

      unless render is false
        @render()

  class ResultItem extends Backbone.Layout
    template: 'item'

    events:
      'click header' : 'selectItem'

    serialize: ->
      @model.toJSON()

    selectItem: =>
      @model.trigger 'selectResult', @model
      app.trigger 'viewToggle'


  return ResultsPanel

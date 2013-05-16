define [
  'app'
], (app) ->

  class ResultsPanel extends Backbone.Layout
    initialize: ->
      @listenTo @collection,
        'searchSuccessful' : @addResults
        'mapSelect'        : @preview

      @addResults(@collection, false)
      @on 'afterRender', @lazyLoadImages

    addResults: (collection, render) =>
      @collection.each (item) =>
        @insertView new ResultItem
          id: "item-#{item.id}"
          className: "item"
          model: item

      unless render is false
        @render()

    lazyLoadImages: =>
      container = @$el.parent()
      @$el.find('img.lazy').lazyload
        effect: 'fadeIn'
        container: container

      container.trigger 'scroll'

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

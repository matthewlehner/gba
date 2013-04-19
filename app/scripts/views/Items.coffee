define [
  'app'
], (app) ->
  class ItemsView extends Backbone.Layout
    initialize: ->
      @listenTo @collection,
        'markersAdded': @addItems
        'mapSelect': @selectItem

    selectItem: (item) ->
      selectedView = @getView
        model: item

      if @currentView is selectedView
        @$el.parent().addClass('hidden')
        @currentView = null
      else
        @currentView = selectedView
        @currentView.$el.siblings()
          .removeClass('current')
        .end()
        .addClass('current')

        @$el.parent().removeClass('hidden')

    addItems: (collection, render) =>
      @collection.each (item) =>
        @insertView new Item
          className: "item id-#{item.id}"
          model: item

      unless render is false
        @render()

  class Item extends Backbone.Layout
    template: 'item'

    events:
      'click': 'openItem'
      'click .arrow': 'closeItem'

    initialize: ->
      @listenTo @model, 'mapSelect', @changeDistance

    openItem: =>
      return if @open

      @open = true
      @model.trigger 'open', @model

    closeItem: =>
      return unless @open

      @model.trigger 'close', @model
      @open = false

    serialize: ->
      @model.toJSON()

    changeDistance: () =>
      distance = @model.get('distance')
      @$el.find('.distance').html(distance)

  return ItemsView

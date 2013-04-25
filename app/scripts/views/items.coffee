define [
  'app'
], (app) ->

  class ItemsPanel extends Backbone.Layout
    initialize: ->
      @listenTo @collection,
        'markersAdded'     : @addItems
        'mapSelect'        : @preview
        'open'             : @openPanel
        'close'            : @closePanel

      @listenTo app,
        'map:Interaction' : @hidePreview

    addItems: (collection, render) =>
      @collection.each (item) =>
        @insertView new Item
          id: "item-#{item.id}"
          className: "item"
          model: item

      unless render is false
        @render()

    preview: (item) ->
      selectedItem = @getView
        model: item

      if @currentView is selectedItem
        @hidePreview();
      else
        @currentView = selectedItem
        @showPreview();

    hidePreview: ->
      @$el.css 'top', ''
      @currentView = null

    showPreview: ->
      @previewHeight = window.innerHeight - @currentView.$el.innerHeight()
      @$el.css 'top', @previewHeight
      @currentView.$el.siblings()
        .removeClass('current')
        .end()
        .addClass('current')

    openPanel: ->
      @$el.css 'top', '0'

    closePanel: ->
      @$el.css 'top', @previewHeight

  class Item extends Backbone.Layout
    template: 'item'

    events:
      'click header': 'openItem'
      'click .arrow': 'closeItem'

    initialize: ->
      @listenTo @model,
        'open', @changeDistance

    openItem: (event) =>
      return if @openView?

      @openView = @insertView(new ItemDetails
        model: @model
        tagName: 'article'
      ).render().view
      @model.trigger 'open', @model
      @$el.addClass 'current'
      @openView.$el.height(
        $('#main').height() - @$el.find('header').innerHeight()
      )

      event.stopImmediatePropagation()

    closeItem: (event) =>
      return unless @openView?

      @model.trigger 'close', @model
      @removeView @openView
      delete @openView

      event.stopImmediatePropagation()

    serialize: ->
      @model.toJSON()

    changeDistance: () =>
      @$el.find('.distance')
      .html @model.get('distance')

  class ItemDetails extends Backbone.Layout
    className: 'item-details'
    template: 'item_details'

    serialize: ->
      @model.toJSON()

  return ItemsPanel

define [
  'app',
  'lib/jquery.touchtouch'
], (app) ->

  class ItemsPanel extends Backbone.Layout
    initialize: ->
      @listenTo @collection,
        'markersAdded'           : @addItems
        'mapSelect selectResult' : @preview
        'open'                   : @openPanel
        'close'                  : @closePanel
        'add'                    : @addItem

      @listenTo app,
        'map:Interaction' : @hidePreview

    itemLayout: (item) ->
      new Item
        id: "item-#{item.id}"
        className: "item"
        model: item

    addItems: (collection, render) =>
      @collection.each (item) =>
        @insertView @itemLayout(item)

      unless render is false
        @render()

    addItem: (item) =>
      @insertView(@itemLayout item).render()

    preview: (item) ->
      selectedItem = @getView
        model: item

      if @currentView is selectedItem
        @hidePreview();
      else
        if @currentView
          $(@currentView.model.marker._icon).removeClass 'active'

        @currentView = selectedItem
        item.fetch();
        @showPreview();

    hidePreview: ->
      @$el.css 'top', window.innerHeight + 5
      $(@currentView.model.marker._icon).removeClass 'active'
      @currentView = null

    showPreview: ->
      @previewHeight = window.innerHeight - @currentView.$el.innerHeight()
      $(@currentView.model.marker._icon).addClass 'active'
      @$el.css 'top', @previewHeight

      @currentView.$el
        .siblings()
          .removeClass('current')
        .end()
        .addClass('current')
        .find('.lazy').trigger 'appear'

    openPanel: ->
      @$el.css 'top', '0'

    closePanel: ->
      @$el.css 'top', @previewHeight

  class Item extends Backbone.Layout
    template: 'item'

    events:
      'click header': 'openItem'
      'click .open-toggle': 'closeItem'

    initialize: ->
      @listenTo @model,
        'change:distance', @changeDistance

      @on 'afterRender', @imageLazyLoader

    imageLazyLoader: =>
      @$el.find('.lazy').lazyload
        effect: 'fadeIn'

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
      @$el.one "transitionend webkitTransitionEnd oTransitionEnd MSTransitionEnd", =>
        @removeView @openView
        @openView = null

      event.stopImmediatePropagation()

    serialize: ->
      @model.toJSON()

    changeDistance: () =>
      @$el.find('.distance')
      .html @model.get('distance')

  class ItemDetails extends Backbone.Layout
    className: 'item-details'
    template: 'item_details'

    initialize: ->
      @listenTo @model, 'change', @render
      @on 'afterRender', @initImageBrowser

    initImageBrowser: (e) ->
      @$el.find('.pictures a').touchTouch()

    serialize: ->
      @model.toJSON()

  return ItemsPanel

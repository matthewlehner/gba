define [
  'app'
  'lib/photo_gallery'
], (app, PhotoGallery) ->

  class ItemsPanel extends Backbone.Layout
    initialize: ->
      @listenTo @collection,
        'mapSelect selectResult' : @preview
        'open'                   : @openPanel
        'close'                  : @closePanel

      @listenTo app,
        'map:Interaction' : @hidePreview

    itemLayout: (item) ->
      new Item
        id: "item-#{item.id}"
        className: "item"
        model: item

    addItems: (collection, render) =>
      # @collection.each (item) =>
      #   @insertView @itemLayout(item)

      unless render is false
        @render()

    addItem: (item) ->
      @insertView(@itemLayout item)

    preview: (item) ->
      selectedItem = @getView
        model: item

      if @selectedModel is item
        @hidePreview();
      else
        if @currentView
          oldView = @currentView
          $(oldView.model?.marker?._icon).removeClass 'active'

        else
          $(window).on 'resize.preview', @setPreviewHeight

        @currentView = @addItem(item)
        item.fetch()
        item.trigger 'fetching'
        @showPreview(oldView)

    hidePreview: ->
      return unless @currentView?
      @$el.css 'top', ''
      $(@currentView.model.marker._icon).removeClass 'active'
      @currentView.remove()
      @currentView = null
      $(window).off 'resize.preview', @setPreviewHeight

    showPreview: (oldView) ->
      @currentView.render().then =>
        $(@currentView.model.marker._icon).addClass 'active'

        @currentView.$el.addClass('current')

        oldView?.$el.removeClass('current')
        oldView?.remove()
        @setPreviewHeight()

    setPreviewHeight: =>
      @headerHeight ?= @currentView.$el.find('header').innerHeight()
      @previewHeight = window.innerHeight - @headerHeight
      @$el.css 'top', @previewHeight

    openPanel: ->
      $(window).off 'resize.preview', @setPreviewHeight
      @$el.css 'top', '0'

    closePanel: ->
      @setPreviewHeight()
      $(window).on 'resize.preview', @setPreviewHeight

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
        container: @$el
      .removeClass 'lazy'

      setTimeout =>
        @$el.trigger 'scroll'
      , 1

    openItem: (event) =>
      return if @openView?

      event.stopImmediatePropagation()

      @openView = @insertView(new ItemDetails
        model: @model
        tagName: 'article'
      ).render().view

      @model.trigger 'open', @model
      @$el.addClass 'current'
      @setHeight()
      $(window).on 'resize.itemdetails', @setHeight

    setHeight: =>
      @openView.$el.height(
        $('#main').height() - @$el.find('header').innerHeight() - 10 # for pad
      )

    closeItem: (event) =>
      return unless @openView?

      @model.trigger 'close', @model
      $(window).off 'resize.itemdetails'
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
      @on 'afterRender', @spin

    spin: ->
      unless @model.fetched()
        @$el.spin
          hwaccel: true
          top: '50%'

    initImageBrowser: (e) ->
      if @model.get('pictures')?
        @gallery = new PhotoGallery(@$el.find('.pictures a'))

    serialize: ->
      @model.toJSON()

    cleanup: ->
      @gallery?.remove()

  return ItemsPanel

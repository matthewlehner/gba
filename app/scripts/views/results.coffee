define [
  'app'
], (app) ->

  class ResultsPanel extends Backbone.Layout
    template: 'results'

    initialize: ->
      @page = 0
      @prevScrollY = 0

      @listenTo @collection,
        'searchSuccessful' : @addResults

      @on 'afterRender', @addResults

    events:
      'scroll' : 'loadNextResults'

    addResults: =>
      begin = @page * 40
      end = begin + 39
      @page += 1

      for item in @collection.slice(begin, end)
        resultLayout = new ResultItem
          id: "item-#{item.id}"
          className: "item"
          model: item

        @insertView('.results-container', resultLayout).render()

      @lazyLoadImages()

    lazyLoadImages: =>
      @$el.find('img.lazy')
      .lazyload
        effect: 'fadeIn'
        container: @$el
      .removeClass 'lazy'

      @$el.trigger 'scroll'

    loadNextResults: =>
      scrollY = @$el.scrollTop() + @$el.height()
      @docHeight = @page * 40 * 57 #page number times 40 items per page, times 57px per item

      if ( scrollY >= @docHeight - 1140 ) and @prevScrollY <= scrollY
        @addResults()

      @prevScrollY = scrollY

  class ResultItem extends Backbone.Layout
    template: 'item_result'

    events:
      'click header' : 'selectItem'

    serialize: ->
      @model.toJSON()

    selectItem: =>
      @model.trigger 'selectResult', @model
      app.trigger 'viewToggle'


  return ResultsPanel

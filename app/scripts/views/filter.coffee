define [
  'app'
], (app) ->
  class FilterView extends Backbone.Layout
    template: 'info_window'
    className: 'modal-wrapper fade'

    events:
      'click footer': 'dismiss'

    initialize: ->
      $content = $('<form>')

      for type, shown of @collection.filterTypes()
        $content.append("<div><label for='#{type}'>#{type} <input type='checkbox' id='#{type}' name='#{type}' checked='#{shown}'/></label></div>")

      @render()
      @$el.find('.content').append $content

      $('#main').append(@$el)

      setTimeout =>
        @$el.removeClass 'fade'
      , 1

    dismiss: =>
      @$el.one "transitionend webkitTransitionEnd oTransitionEnd MSTransitionEnd", =>
        @remove()
        delete this

      @$el.addClass 'fade'

    serialize: ->
      attrs = 
        'header': 'Filter Map Markers'
        'content': ' '

      return attrs

  return FilterView


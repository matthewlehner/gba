define [
  'app'
], (app) ->
  class FilterView extends Backbone.Layout
    template: 'info_window'
    className: 'modal-wrapper fade'

    events:
      'click footer': 'dismiss'
      'change input': 'filterType'

    serialize: ->
      'content': ' '

    initialize: ->
      @listenTo @collection, 'reset', @render
      @on 'beforeRender', @createTemplate
      @on 'afterRender', @addToDom
      @render()

    addToDom: ->
      @$el.find('.content').append @$content

      $('#main').append(@$el)

      setTimeout =>
        @$el.removeClass 'fade'
      , 1

    createTemplate: ->
      @$content = $("<form class='filter-form'>")

      for type, shown of @collection.filterTypes()
        checked = if shown then 'checked' else ''
        @$content.append "<label for='#{type}'>#{type}<input type='checkbox' id='#{type}' name='#{type}' #{checked}/><div class='checkbox-indicator'></div></label>"

    dismiss: ->
      @$el.one "transitionend webkitTransitionEnd oTransitionEnd MSTransitionEnd", =>
        @remove()
        delete this
        @collection.trigger 'refilter'

      @$el.addClass 'fade'

    filterType: (e) ->
      $checkbox = $(e.target)
      type = $checkbox.attr('id')
      @collection.typesFilter[type] = $checkbox.prop('checked')

  return FilterView


define [
  'app'
], (app) ->
  class FilterView extends Backbone.Layout
    template: 'info_window'
    className: 'modal-wrapper fade'

    events:
      'click footer': 'dismiss'
      'click li': 'filterType'

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
      @$content = $("<ul class='filter-form'>")

      for type, shown of @collection.filterTypes()
        checked = if shown then 'checked' else ''
        @$content.append @templateEl(type, checked)

    templateEl: (type, checked) ->
      "<li class='filter-type #{checked}' data-type='#{type}'>#{type}</label>"

    dismiss: ->
      @$el.one "transitionend webkitTransitionEnd oTransitionEnd MSTransitionEnd", =>
        @remove()
        delete this
        @collection.trigger 'refilter'

      @$el.addClass 'fade'

    filterType: (e) ->
      $li = $(e.target)
      $li.toggleClass('checked')
      type = $li.data('type')
      @collection.typesFilter[type] = $li.hasClass('checked')

  return FilterView


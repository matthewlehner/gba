define [
  'app'
], (app) ->
  class InfoView extends Backbone.Layout
    template: 'info_window'
    className: 'modal-wrapper fade'

    events:
      'click footer': 'dismiss'

    initialize: ->
      @render()
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
      attrs = {}

      if @options.content?
        _.extend attrs,
          content: @options.content

      if @options.header?
        _.extend attrs,
          header: @options.header

      return attrs

  return InfoView

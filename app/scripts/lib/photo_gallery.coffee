define [
  'app'
], (app) ->
  
  class PhotoGallery
    constructor: (@items) ->
      @index = 0

      @createDomElements()
      @addListeners()

    addListeners: ->
      @sliderListener()
      @items.on 'click', @displayImage

    remove: ->
      @items.off 'click'
      @overlay.remove()

    displayImage: (e) =>
      e.preventDefault()

      # Find the position of this image in the collection
      index = @items.index(e.currentTarget)
      @showOverlay(index)
      @showImage(index)

      # // Preload the previous and next images
      @preload index+1
      @preload index-1

    showOverlay: (index) ->
      return false if @overlayVisible

      @overlay.show();

      setTimeout =>
        # Trigger the opacity CSS transition
        @overlay.addClass 'visible'
      , 1

      # Move the slider to the correct image
      @offsetSlider(index);

      @overlayVisible = true;

    hideOverlay: ->
      return false if !@overlayVisible

      @overlay.hide().removeClass('visible');
      @overlayVisible = false;

      # # Clear preloaded items
      # $('.placeholder').empty();

    showImage: (index) ->
      # If the index is outside the bonds of the array
      if (index < 0 || index >= @items.length)
        return false;
      
      src = @items.eq(index).attr('href')

      # Call the load function with the href attribute of the item
      @loadImage index, src

    loadImage: (index, src) ->
      placeholder = @placeholders.eq(index)
      unless placeholder.data('img-loaded') is true

        placeholder.spin(
          width: 5
          color: '#eee'
          hwaccel: true
        )

        img = $('<img>').on 'load', ->
          placeholder.data('img-loaded', true).spin(false).html img

        img.attr('src',src);

    preload: (index) ->
      setTimeout =>
        @showImage(index);
      , 500

    offsetSlider: (index) ->
      # This will trigger a smooth css transition
      @slider.css('left',(-index*100)+'%');

    createDomElements: ->
      @placeholders = $ []
      @overlay     = $('<div id="galleryOverlay">')
      @slider      = $('<div id="gallerySlider">')
      prevArrow    = $('<a id="prevArrow"></a>')
      nextArrow    = $('<a id="nextArrow"></a>')

      @overlayVisible = false
      @overlay.hide().appendTo('body');
      @slider.appendTo(@overlay);

      @items.each =>
        @placeholders = @placeholders.add $('<div class="placeholder">')

      # Hide the gallery if the background is touched / clicked
      @slider.append(@placeholders).on 'click', (e) =>
        if !$(e.target).is('img') 
          @hideOverlay();

    sliderListener: ->
      # Listen for touch events on the body and check if they
      # originated in #gallerySlider img - the images in the slider.
      $('body').on('touchstart', '#gallerySlider img', (e) =>

        touch = e.originalEvent
        startX = touch.changedTouches[0].pageX

        @slider.on 'touchmove', (e) =>
          e.preventDefault();
          touch = e.originalEvent.touches[0] or e.originalEvent.changedTouches[0]

          if touch.pageX - startX > 10
            @slider.off('touchmove');
            @showPrevious();

          else if touch.pageX - startX < -10
            @slider.off('touchmove');
            @showNext();

        return false;

      ).on 'touchend', () =>
        @slider.off('touchmove')

    hideOverlay: ->
      if !@overlayVisible
        return false;

      # Hide the overlay
      @overlay.hide().removeClass('visible');
      @overlayVisible = false;

      # Clear preloaded items
      # $('.placeholder').empty();

    showNext: =>
      # If this is not the last image
      if @index+1 < @items.length
        @index++
        @offsetSlider @index
        @preload @index+1

      else
        # Trigger the spring animation
        @slider.addClass('rightSpring')

        setTimeout =>
          @slider.removeClass('rightSpring')
        , 500

    showPrevious: =>
      # If this is not the first image
      if @index>0
        @index--
        @offsetSlider @index
        @preload @index-1

      else
        # Trigger the spring animation
        @slider.addClass('leftSpring')

        setTimeout =>
          @slider.removeClass('leftSpring')
        , 500

  return PhotoGallery

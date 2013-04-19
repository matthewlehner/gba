define ->

  class HumanDistance
    constructor: (@value) ->
      
    humanize: ->
      if @value < 999

        # meters
        "#{parseInt(@value)} m"

      else if @value >= 1000

        #kilometers
        "#{parseInt(@value / 1000)} km"

  return HumanDistance

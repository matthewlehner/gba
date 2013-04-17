define [ 
  'app'
  'models/building'
], (app, buildingModel) ->

  class buildingCollection extends Backbone.Collection
    model: buildingModel

  return buildingCollection

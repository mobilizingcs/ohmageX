@Ohmage.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Loading extends Entities.Model
    defaults:
      message: 'Now Loading...'
    loadShow: (message = false) ->
      if message isnt false then @set('message', message)
      @trigger 'loading:show'
    loadHide: ->
      @set 'message', 'Now Loading...'
      @trigger 'loading:hide'
    loadUpdate: (message) ->
      @set 'message', message
      @trigger 'loading:update', message

  API =
    getLoading: (message) ->
      new Entities.Loading message: message

  App.reqres.setHandler "loading:entities", ->
    API.getLoading()

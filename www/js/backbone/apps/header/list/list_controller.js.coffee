@Ohmage.module "HeaderApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Application

    initialize: (options) ->
      { navs } = options
      @layout = @getLayoutView navs

      @listenTo @layout, "show", =>
        @listRegion navs

      @listenTo navs, "change:chosen", (model) =>
        # this event fires every time all instances of the
        # `chosen` attribute within the model are changed.
        # So only render the buttonRegion when our model is "chosen"
        if model.isChosen() then @buttonRegion(navs)

      @show @layout

    listRegion: (navs) ->
      listView = @getListView navs

      @show listView, region: @layout.listRegion

    buttonRegion: (navs) ->
      buttonView = App.request "navbuttons:view", navs
      if buttonView is false
        @layout.buttonRegion.reset()
      else
        @show buttonView, region: @layout.buttonRegion

    getListView: (navs) ->
      new List.Header
        collection: navs

    getLayoutView: (navs) ->
      new List.Layout
        collection: navs

@Ohmage.module "SurveysApp.List", (List, App, Backbone, Marionette, $, _) ->

  # Surveys List currently renders a list of ALL available surveys
  # for a user, retrieved from the server.

  class List.Controller extends App.Controllers.Application

    initialize: (options) ->
      if options.campaign_id
        surveys = App.request "surveys:saved:campaign", options.campaign_id
      else
        surveys = App.request "surveys:saved"

      selector = App.request "surveys:selector:entities", options.campaign_id

      @layout = @getLayoutView selector

      @listenTo selector, "change:chosen", (model) =>
        # this event fires every time all instances of the
        # `chosen` attribute within the model are changed.
        # So only activate when our model is "chosen"
        if model.isChosen() then App.vent.trigger("survey:list:campaign:selected", model)

      @listenTo @layout, "show", =>
        console.log "show list layout"
        @selectorRegion selector
        @surveysRegion surveys
        @logoutRegion()

      @show @layout, loading: false

    infobuttonRegion: (selector) ->
      infoView = @getInfoButtonView selector

      @show infoView, region: @layout.infobuttonRegion

    selectorRegion: (selector) ->
      selectorView = @getSelectorView selector

      @show selectorView, region: @layout.selectorRegion

    surveysRegion: (surveys) ->
      surveysView = @getSurveysView surveys

      @listenTo surveysView, "childview:running:clicked", (child, args) ->
        console.log 'childview:running:clicked args', args.model
        App.vent.trigger "survey:list:running:clicked", args.model

      @listenTo surveysView, "childview:stopped:clicked", (child, args) ->
        console.log 'childview:stopped:clicked args', args.model
        App.vent.trigger "survey:list:stopped:clicked", args.model

      @show surveysView, region: @layout.listRegion

    logoutRegion: ->
      logoutView = @getLogoutView()

      @listenTo logoutView, "logout:clicked", ->
        console.log 'logout clicked'
        App.vent.trigger "survey:list:logout:clicked"

      @show logoutView, region: @layout.logoutRegion

    getLogoutView: ->
      new List.Logout

    getInfoButtonView: (selector) ->
      new List.CampaignInfoButton
        collection: selector

    getSelectorView: (selector) ->
      new List.CampaignsSelector
        collection: selector

    getSurveysView: (surveys) ->
      new List.Surveys
        collection: surveys

    getLayoutView: (selector) ->
      new List.Layout
        collection: selector

@Ohmage.module "SurveysApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Logout extends App.Views.ItemView
    template: "surveys/list/logout"
    triggers:
      "click button": "logout:clicked"

  class List.Survey extends App.Views.ItemView
    initialize: ->
      @listenTo @model, 'change', @render
    tagName: 'li'
    getTemplate: ->
      if @model.get('status') is 'running' then "surveys/list/_item_running" else "surveys/list/_item_stopped"
    triggers:
      "click .stopped-survey": "stopped:clicked"
      "click .running-survey": "running:clicked"

  class List.SelectorItem extends App.Views.ItemView
    tagName: "option"
    template: "surveys/list/_selector_item"
    attributes: ->
      options = {}
      options['value'] = @model.get 'id'
      if @model.isChosen() then options['selected'] = 'selected'
      options

  class List.CampaignsSelector extends App.Views.CollectionView
    initialize: ->
      @listenTo @, "campaign:selected", (-> @collection.chooseById @$el.val())
    tagName: "select"
    childView: List.SelectorItem
    triggers: ->
      "change": "campaign:selected"

  class List.CampaignInfoButton extends App.Views.ItemView
    initialize: ->
      @model = @collection.findWhere(chosen: true)
      @listenTo @collection, 'change:chosen', @chosenRender
    chosenRender: (model) ->
      if model.isChosen()
        @model = model
        @render
    tagName: "button"
    template: "surveys/list/info_button"
    attributes: ->
      if @collection.findWhere(chosen: true).get('name') is 'All'
        return {
          class: "hidden"
        }
    triggers:
      "click": "info:clicked"
    serializeData: ->
      data = @model.toJSON()
      data

  class List.SurveysEmpty extends App.Views.ItemView
    template: "surveys/list/_surveys_empty"

  class List.Surveys extends App.Views.CompositeView
    template: "surveys/list/surveys"
    childView: List.Survey
    childViewContainer: ".surveys"
    emptyView: List.SurveysEmpty

  class List.Layout extends App.Views.Layout
    template: "surveys/list/list_layout"
    regions:
      infoRegion: "#info-region"
      infobuttonRegion: "#infobutton-region"
      selectorRegion: "#selector-region"
      listRegion: "#list-region"
      logoutRegion: "#logout-region"
    serializeData: ->
      data = @collection.findWhere(chosen: true).toJSON()
      data
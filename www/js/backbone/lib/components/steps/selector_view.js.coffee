@Ohmage.module "Components.Steps", (Steps, App, Backbone, Marionette, $, _) ->

  class Steps.Intro extends App.Views.ItemView
    template: "steps/intro"
    serializeData: ->
      data = @model.toJSON()
      console.log 'Steps.Intro data', data
      data

  class Steps.Message extends App.Views.ItemView
    template: "steps/message"
    serializeData: ->
      data = @model.toJSON()
      console.log 'Steps.Message data', data
      data

  class Steps.BeforeSubmission extends App.Views.ItemView
    template: "steps/beforesubmission"
    serializeData: ->
      data = @model.toJSON()
      console.log 'Steps.BeforeSubmission data', data
      data.completeTitle = 'Survey Submit'
      data

  class Steps.AfterSubmission extends App.Views.ItemView
    template: "steps/aftersubmission"
    serializeData: ->
      data = @model.toJSON()
      console.log 'Steps.AfterSubmission data', data
      data.completeTitle = 'Survey Complete'
      data.summary = "Survey submitted."
      data

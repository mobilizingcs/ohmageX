@Ohmage.module "ProfileApp", (ProfileApp, App, Backbone, Marionette, $, _) ->

  class ProfileApp.Router extends Marionette.AppRouter
    before: ->
      if !App.request("credentials:isloggedin")
        App.navigate Routes.default_route(), trigger: true
        return false
    appRoutes:
      "profile": "show"

  API =
    show: (id) ->
      App.vent.trigger "nav:choose", "profile"
      console.log 'ProfileApp show'
      new ProfileApp.Show.Controller

  App.addInitializer ->
    new ProfileApp.Router
      controller: API

  App.vent.on "profile:password:clicked", ->
    App.vent.trigger "blocker:password:change",
      successListener: ->
        App.execute "dialog:show", "Password successfully changed."

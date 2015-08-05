@Ohmage.module "DashboardeQISApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Notice extends App.Views.ItemView
    template: "dashboard_eqis/show/notice"
    className: "notice-nopop"

  class Show.Artifact extends App.Views.ItemView
    tagName: "li"
    className: "text-container"
    template: "dashboard_eqis/show/artifact"

  class Show.Layout extends App.Views.Layout
    template: "dashboard_eqis/show/show_layout"
    regions:
      artifactsRegion: "#artifacts-region"

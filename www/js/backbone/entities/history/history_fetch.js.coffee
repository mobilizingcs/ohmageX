@Ohmage.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  # The HistoryFetch entity manages fetching data
  # for history items that are not part of the original history
  # entry request.

  API =
    fetchURL: (history_response, context) ->

      myData =
        client: App.client_string
        id: history_response.get 'prompt_response'

      myData = _.extend(myData, App.request("credentials:upload:params"))

      myURL = "#{App.request("serverpath:current")}/app/#{context}/read?#{$.param(myData)}"

      App.vent.trigger "history:response:fetch:#{context}:url", myURL, history_response

      myURL


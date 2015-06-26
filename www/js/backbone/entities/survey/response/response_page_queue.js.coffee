@Ohmage.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  # This queue handles all responses on a given page.

  currentDeferred = []
  currentIndices = []
  errorCount = 0

  API =

    itemError: (itemId) ->
      errorCount++
      myIndex = currentIndices.indexOf(itemId)
      console.log 'itemError itemId', itemId
      currentDeferred[myIndex].resolve()

    itemSuccess: (itemId) ->
      myIndex = currentIndices.indexOf(itemId)
      console.log 'itemSuccess itemId', itemId
      currentDeferred[myIndex].resolve()


@Ohmage.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  # The Flow Entity contains data related to the flow
  # of the Steps within a Survey.
  # This module contains the Page handlers for Flow for survey multi-prompt display.

  # References the current Flow StepCollection object, defined in flow_init.js.coffee
  # via the interface "flow:current"

  API =
    getStartingStepIndex: (flow, currentPage) ->
      if currentPage is 1
        # a fresh survey with NO assigned pages
        return 0
      else
        # get the first step in the survey with an unassigned page

        myIndex = -1
        result = flow.find (step) =>
          myIndex++
          step.get('page') is false
        return myIndex

    assignNewPage: (flow, currentPage) ->
      loopThroughSteps = true
      myStepIndex = @getStartingStepIndex flow, currentPage

      # This assumes that beforeSurveySubmit is always followed by afterSurveySubmit.
      # In the situation where a beforeSurveySubmit flow step is evaluated with a "false" page,
      # and yet, it's the first step on the new page, its page should be set to the
      # currentPage. However, if it wasn't the first step evaluated on the current page,
      # that means we should bump it to the next page. This bump starts at 0.
      # When a prompt is displayed on the current step, the bump is set to 1 to ensure
      # the beforeSurveySubmit and afterSurveySubmit steps are bumped to separate pages.
      lastPageBump = 0

      while loopThroughSteps and myStepIndex < flow.length
        currentStep = flow.at myStepIndex

        if currentStep.get('page') is false
          # a page hasn't been assigned to this step yet.

          switch currentStep.get('type')
            when "intro"
              if currentStep.get('status') is "displayed"
                currentStep.set 'page', 1
                # the intro step gets a page all to itself, if displayed
                loopThroughSteps = false
            when "beforeSurveySubmit"
              currentStep.set 'page', currentPage + lastPageBump
            when "afterSurveySubmit"
              currentStep.set 'page', currentPage + 1 + lastPageBump
            else
              # it's a prompt

              if App.request("flow:condition:invalid:future:reference", currentStep.get('condition'))
                # stop, we've hit something that has an invalid reference.
                loopThroughSteps = false
              else
                stepWasSkipped = currentStep.get('status') is 'skipped'
                # Condition check also sets the status of the prompt to either "displaying"
                # or "not_displayed"
                isPassed = App.request "flow:condition:check", currentStep.get('id')
                if isPassed
                  currentStep.set 'page', currentPage
                  lastPageBump = 1
                  if stepWasSkipped
                    # trigger skipped if the condition passed, so it saves the fact that the step was skipped.
                    App.vent.trigger("survey:step:skipped", currentStep.get('id'))
                    # also insert a page break, because there's no way to evaluate any subsequent step's conditions
                    # since they could possibly skip or unskip this prompt.
                    loopThroughSteps = false

        myStepIndex++

    clearOldPage: (flow, oldPage) ->
      flow.each (step) =>
        if step.get('page') >= oldPage-1
          # why oldPage-1 and not just the oldPage?
          # because we need to clear the page that's about to be rendered too.
          step.set 'page', false
          # leave skipped statuses alone
          if step.get('status') isnt "skipped" then App.vent.trigger("flow:step:reset", step.get('id'))
      console.log 'currentResponses', App.request('responses:current').map (response) -> "id: #{response.get('id')}, response: #{response.get('response')}"

    getAftersubmitPage: (flow) ->
      console.log 'getAftersubmitPage'
      result = flow.find (step) -> step.get('id').endsWith('afterSurveySubmit')
      if result is undefined or result.get('page') is false then throw new Error "current flow aftersubmit invalid or no page assigned"
      result.get('page')

    getPageFirstStep: (flow, page) ->
      console.log 'getPageFirstStep'
      result = flow.findWhere(page: page)
      if result is undefined then throw new Error "Page #{page} does not exist in flow"
      result

    getPageSteps: (flow, page) ->
      console.log 'getPageSteps'
      resultArr = flow.where(page: page)
      new Entities.Collection resultArr

  App.vent.on "surveytracker:page:new", (page) ->
    API.assignNewPage App.request('flow:current'), page

  App.vent.on "surveytracker:page:old", (oldPage) ->
    API.clearOldPage App.request('flow:current'), oldPage

  App.reqres.setHandler "flow:page:aftersubmit:page", ->
    API.getAftersubmitPage App.request('flow:current')

  App.reqres.setHandler "flow:page:steps", (page) ->
    API.getPageSteps App.request('flow:current'), page

  App.reqres.setHandler "flow:page:step:first", (page) ->
    API.getPageFirstStep App.request('flow:current'), page

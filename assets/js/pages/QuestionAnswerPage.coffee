class @QuestionAnswerPage extends Widget
  enhancePage: ->
    @element.find('[data-value]').click (e) ->
      e.preventDefault()

      $.postJson location.href,
        id: 'me'
        value: $(this).data('value')

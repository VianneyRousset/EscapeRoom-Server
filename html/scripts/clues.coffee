define () ->

  class Clues
    constructor: (@app) ->

    set_propositions: (messages) ->
      $('#clues > div.list.select > *').remove()
      for msg in messages
        a = $('<span></span>')
        a.html msg
        a.click((a) => @set_content a.target.innerHTML)
        console.log msg
        $('#clues > div.list.select').append a

    set_content: (msg) ->
      $('#clues textarea').val msg

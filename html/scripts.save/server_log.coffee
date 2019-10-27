define () ->

  class ServerLog
    constructor: (@app) ->

    add: (messages) ->
      $('#server-log > *').remove()
      for msg in messages
        a = $('<span></span>')
        a.html msg
        $('#server-log').append a

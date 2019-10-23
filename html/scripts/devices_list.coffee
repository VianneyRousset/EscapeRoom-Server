define () ->

  class DevicesList
    constructor: (@app) ->

    set: (devices) ->
      $('#devices-list > *:not(template)').remove()
      template = $('#devices-list template').html()
      console.log devices
      for name, d of devices
        a = $(template)
        a.children('summary').html name
        $('#devices-list').append a

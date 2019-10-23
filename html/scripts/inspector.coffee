define () ->

  class Inspector

    constructor: (@app) ->
      inspector = this
      need_confirmation_btn = $('.inspector button.need_confirmation')
      for i in need_confirmation_btn
        $(i).data 'content', $(i).html()
      need_confirmation_btn.click () -> inspector.add_confirm $(this)
      need_confirmation_btn.mouseleave () -> inspector.remove_confirm $(this)

    set: (node) ->
      @selection = node
      @show 'selection'
      @set_header node.color, node.title, node.description, node.state
      @set_conditions node.conditions
      @set_actions()

    unset: () ->
      @selection = undefined
      @show('empty')

    update: () -> if @selection isnt undefined then @set(@selection)

    show: (mode) ->
      if mode is 'selection'
        $('.inspector .empty').hide()
        $('.inspector .selection').show()
      else if mode is 'empty'
        $('.inspector .empty').show()
        $('.inspector .selection').hide()
      else
        log.warn 'Invalid inspector show mode'

    set_header: (color, title, description, state) ->
      $('.inspector .header').css 'background',
      "url(img/circuit-board.svg),
       linear-gradient(to top, #00000030, #00000000 6px),
       linear-gradient(to bottom right, #ffffff30, #ffffff00), #{color}"
      $('.inspector h1').html title
      $('.inspector .state').html state
      $('.inspector .description').html description

    set_conditions: (conditions) ->
      $('.inspector .conditions > *:not(template)').remove()
      template = $('.inspector .conditions template').html()
      for _, c of conditions
        a = $(template)
        a.children('summary').html c.title
        a.children('p').html c.description
        a.removeClass 'red'
        a.removeClass 'green'
        if c.state is 'done'
          a.addClass 'green'
        else
          a.addClass 'red'
        $('.inspector .conditions').append a
      

    set_actions: () ->
      activation_btn = $('.inspector #activation')
      if @selection.state is "done"
        activation_btn.hide()
      else
        activation_btn.show()


    add_confirm: (btn) ->
      if btn.hasClass 'confirm'
        @remove_confirm btn
        @set @selection
      else
        btn.addClass 'confirm'
        btn.html 'Confirmer'

    remove_confirm: (btn) ->
      btn.removeClass('confirm')
      btn.html btn.data 'content'

    click: (btn) ->
      if btn.data 'content'
        console.log "Forcer l\'activation du node \"#{@selection.id}\""


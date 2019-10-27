define () ->
  class Navigation

    constructor: (@game_state) ->
      window.addEventListener "hashchange", () => @navigate @get_page_anchor()
      @navigate @get_page_anchor()

    get_page_anchor: () ->
      window.location.href.split("#")[1]

    navigate: (anchor) ->
      $(".box nav > a").removeClass('active')
      $(".box nav > a[href='\##{anchor}']").addClass('active')
      $(".tab-content").removeClass('active')
      $(".tab-content[id='tab-#{anchor}']").addClass('active')

    set_game_is_running: (is_running) ->
      a = $('.box nav > a.game_state')
      a.removeClass 'loading'
      a.removeClass 'new-game'
      a.removeClass 'cancel-game'
      a.attr 'href', null
      if is_running is undefined
        a.addClass 'loading'
        a.html '<div></div><div></div><div></div>'
      else if is_running
        a.addClass 'cancel-game'
        a.html '<img src="img/x_white.svg"/>Annuler la partie'
      else
        a.addClass 'new-game'
        a.html '<img src="img/plus_white.svg"/>Nouvelle partie'
        a.attr 'href', '#setup'



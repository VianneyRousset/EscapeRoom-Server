// Generated by CoffeeScript 2.3.2
(function() {
  define(function() {
    var Inspector;
    return Inspector = class Inspector {
      constructor(app) {
        var i, inspector, j, len, need_confirmation_btn;
        this.app = app;
        inspector = this;
        need_confirmation_btn = $('.inspector button.need_confirmation');
        for (j = 0, len = need_confirmation_btn.length; j < len; j++) {
          i = need_confirmation_btn[j];
          $(i).data('content', $(i).html());
        }
        need_confirmation_btn.click(function() {
          return inspector.add_confirm($(this));
        });
        need_confirmation_btn.mouseleave(function() {
          return inspector.remove_confirm($(this));
        });
      }

      set(node) {
        this.selection = node;
        this.show('selection');
        this.set_header(node.color, node.title, node.description, node.state);
        this.set_conditions(node.conditions);
        return this.set_actions();
      }

      unset() {
        this.selection = void 0;
        return this.show('empty');
      }

      update() {
        if (this.selection !== void 0) {
          return this.set(this.selection);
        }
      }

      show(mode) {
        if (mode === 'selection') {
          $('.inspector .empty').hide();
          return $('.inspector .selection').show();
        } else if (mode === 'empty') {
          $('.inspector .empty').show();
          return $('.inspector .selection').hide();
        } else {
          return log.warn('Invalid inspector show mode');
        }
      }

      set_header(color, title, description, state) {
        $('.inspector .header').css('background', `url(img/circuit-board.svg), linear-gradient(to top, #00000030, #00000000 6px), linear-gradient(to bottom right, #ffffff30, #ffffff00), ${color}`);
        $('.inspector h1').html(title);
        $('.inspector .state').html(state);
        return $('.inspector .description').html(description);
      }

      set_conditions(conditions) {
        var _, a, c, results, template;
        $('.inspector .conditions > *:not(template)').remove();
        template = $('.inspector .conditions template').html();
        results = [];
        for (_ in conditions) {
          c = conditions[_];
          a = $(template);
          a.children('summary').html(c.title);
          a.children('p').html(c.description);
          a.removeClass('red');
          a.removeClass('green');
          if (c.state === 'done') {
            a.addClass('green');
          } else {
            a.addClass('red');
          }
          results.push($('.inspector .conditions').append(a));
        }
        return results;
      }

      set_actions() {
        var activation_btn;
        activation_btn = $('.inspector #activation');
        if (this.selection.state === "done") {
          return activation_btn.hide();
        } else {
          return activation_btn.show();
        }
      }

      add_confirm(btn) {
        if (btn.hasClass('confirm')) {
          this.remove_confirm(btn);
          return this.set(this.selection);
        } else {
          btn.addClass('confirm');
          return btn.html('Confirmer');
        }
      }

      remove_confirm(btn) {
        btn.removeClass('confirm');
        return btn.html(btn.data('content'));
      }

      click(btn) {
        if (btn.data('content')) {
          return console.log(`Forcer l\'activation du node "${this.selection.id}"`);
        }
      }

    };
  });

}).call(this);

// Generated by CoffeeScript 2.3.2
(function() {
  define(function() {
    var Clues;
    return Clues = class Clues {
      constructor(app) {
        this.app = app;
      }

      set_propositions(messages) {
        var a, i, len, msg, results;
        $('#clues > div.list.select > *').remove();
        results = [];
        for (i = 0, len = messages.length; i < len; i++) {
          msg = messages[i];
          a = $('<span></span>');
          a.html(msg);
          a.click((a) => {
            return this.set_content(a.target.innerHTML);
          });
          console.log(msg);
          results.push($('#clues > div.list.select').append(a));
        }
        return results;
      }

      set_content(msg) {
        return $('#clues textarea').val(msg);
      }

    };
  });

}).call(this);

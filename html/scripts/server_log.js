// Generated by CoffeeScript 2.3.2
(function() {
  define(function() {
    var ServerLog;
    return ServerLog = class ServerLog {
      constructor(app) {
        this.app = app;
      }

      add(messages) {
        var a, i, len, msg, results;
        $('#server-log > *').remove();
        results = [];
        for (i = 0, len = messages.length; i < len; i++) {
          msg = messages[i];
          a = $('<span></span>');
          a.html(msg);
          results.push($('#server-log').append(a));
        }
        return results;
      }

    };
  });

}).call(this);

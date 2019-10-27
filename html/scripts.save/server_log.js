// Generated by CoffeeScript 1.9.3
(function() {
  define(function() {
    var ServerLog;
    return ServerLog = (function() {
      function ServerLog(app) {
        this.app = app;
      }

      ServerLog.prototype.add = function(messages) {
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
      };

      return ServerLog;

    })();
  });

}).call(this);
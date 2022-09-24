function getPreferGameServerUrl() {
  return 'http://test.tankionline.com/';
}
var nodeNames = {
  1: {
    name: "e1",
    maxUsers: 2700
  },
  2: {
    name: "e2",
    maxUsers: 2700
  },
  3: {
    name: "e3",
    maxUsers: 2700
  },
  4: {
    name: "e4",
    maxUsers: 2700
  },
  5: {
    name: "e5",
    maxUsers: 2700
  },
  6: {
    name: "e6",
    maxUsers: 2700
  },
  7: {
    name: "e7",
    maxUsers: 2700
  },
  8: {
    name: "e8",
    maxUsers: 2700
  }
};

$(document).ready(function() {
  initServers();
  askBalancers();
  setInterval(function() {
    askBalancers();
  }, 10000);

});
var stat = {"total": 0, "nodes": {}};
function askBalancers() {
  $.getJSON("s/status.json?rnd=" + Math.random(), function(data) {
    stat = data;
    nodesToHosts(stat.nodes);
    updateStat();
  });
}

function updateStat() {
  for (var i in nodeNames) {
    var node = nodeNames[i];
    if (stat.nodes[node.name]) {
      stat.nodes[node.name] = stat.nodes[node.name];
    }
  }
  update();
}

function nodesToHosts(nodes) {//stat.nodes
  var re = /^.*\.([^\.]+)$/;
  for (var node in nodes) {
    var nodeHost = node.match(re);
    if (nodeHost) {
      nodes[nodeHost[1]] = nodes[node];
    }
  }
}

function initServers() {
  //return false;
  var langs = ['ru', 'en'];
  for (var l in langs) {
    var lang = langs[l];
    var tds = new Array();
    $("#holder_" + lang).html('');
    for (var i in nodeNames) {
      var link = '/battle-' + lang + '.html#/server=' + serversMapRev[i];
     // var link = '/battle-' + lang + '.html';
      
      var td = $('<a href="' + link + '" class="disabled" id="server-' + lang + i + '">' +
              (lang === 'ru' ? 'Сервер' : 'Server') + ' ' + i + ':&nbsp;<span>' +
              (lang === 'ru' ? 'Выключен' : 'Offilne') + '</span></a>');
      tds.push(td);
    }
    $("#holder_" + lang).append(tds);
  }
  update();
}
function format(s) {
  s = new String(s);
  s = s.replace(/(?=([0-9]{3})+$)/g, " ");
  return s;
}
function getServerLoad(i) {
  var st = stat.nodes[nodeNames[i].name];
  if (st) {
    return (st.online / nodeNames[i].maxUsers);
  } else {
    return 1000;
  }
}
function updateServer(i, lang) {
  var st = stat.nodes[nodeNames[i].name];
  var load = getServerLoad(i);
  var selectors = ["#server-" + lang + i];
  $(selectors).each(function() {
    $(this + " span").html(formatUsers(st, lang));
    var $btn = $(String(this));
    if (load >= 4) {
      $btn.attr("class", "disabled").bind('click', function(e) {
        e.preventDefault();
        return false;
      });
    } else {
      $btn.unbind('click');
      if (load > 1 && load < 4) {
        $btn.attr("class", "overloaded")/*.bind('click', function(e) {
         e.preventDefault();
         return false;
         })*/;
      } else {
        $btn.attr("class", "button").unbind('click');
      }
    }
  });
  return load < 4;
}

function formatUsers(st, lang) {
  var ret = "";
  switch (lang) {
    case "en":
      if (st) {
        ret += st.online;
        ret += " player";
        if (st.online != 1)
          ret += "s";
      } else {
        ret = "Offline";
      }
      break;
    case "ru":
      if (st) {
        var endings = ["ов", "а"];
        var countString = new String("0" + st.online);
        ret += st.online;
        ret += " игрок";
        if (countString.substr(-2, 1) == 1) {
          ret += endings[0];
        } else {
          var lastNum = countString.substr(-1, 1);
          if (lastNum == 1) {
          } else if (lastNum >= 2 && lastNum <= 4) {
            ret += endings[1];
          } else {
            ret += endings[0];
          }
        }
      } else {
        ret = "Выключен";
      }
      break;
  }
  return ret;
}

function update() {
  for (var i in nodeNames) {
    updateServer(i, 'ru');
    updateServer(i, 'en');
  }

}
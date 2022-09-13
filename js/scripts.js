// JavaScript requires jQuery
$(document).ready(function() {
    $('.fav-switch').bind('click', function() {
        var o = $(this);
        var id = o.data('id');
        if (o.data('request')) return;
        else o.data('request', true);
        o.removeClass('fa-star');
        o.addClass('fa-cog fa-spin');
        var req = $.post('/my/manage/json', {tid: id}, function(data) {
            if (!data.error) {
                o.removeClass('text-muted enlisted');
                if (data.action == 'enlisted') {
                    o.addClass('enlisted');
                } else {
                    o.addClass('text-muted');
                }
            }
        }).always(function() {
            o.removeClass('fa-cog fa-spin');
            o.addClass('fa-star');
            o.data('request', false);
        });
    });
    $(window).bind('hashchange', function(e) {
        var req = $.post('/my/lang/json', function(data) {
            window.location.href = window.location.pathname;
        });
    });
    $('#settings-regenerate-share').click(function(e, all) {
        all = typeof all !== 'undefined' ? all : false;
        var abtn = $('#settings-regenerate-all');
        var sbtn = $('#settings-regenerate-share');
        abtn.attr('disabled', true);
        sbtn.attr('disabled', true);
        var req = $.post('/my/regenerate/json', {all: all}, function(data) {
            if (!data.error) {
                var share = $('#settings-share');
                var loc = window.location;
                var port = (loc.port && loc.port != 80) ? ':' + loc.port : '';
                var link = loc.protocol + '//' + loc.hostname + port + '/custom/' + data.shared;
                share.val(link);
            } else {
                console.warn(data.error);
            }
        }).always(function() {
            abtn.attr('disabled', false);
            sbtn.attr('disabled', false);
        });

    });
    $('#settings-regenerate-all').click(function(e) {
        $('#settings-regenerate-share').trigger('click', [true]);
    });
    $('tr.prop-row').click(function() {
        var row = $(this);
        if (row.hasClass('selected')) return;
        var id = row.attr('id').slice(2);
        var img = $('#i-' + id);
        row.siblings('.selected').removeClass('selected');
        row.addClass('selected');
        img.siblings('.show').removeClass('show').addClass('hidden');
        img.removeClass('hidden').addClass('show');
    });
    $('#button-starts-with').click(function() {
        var url = $('#hidden-starts-with').val();
        var str = $('#input-starts-with').val();
        if (str) window.location.href = url + '/starts/' + str;
        else window.location.href = url;
    });
    $('#form-starts-with').submit(function(e) {
        e.preventDefault();
        $('#button-starts-with').trigger('click');
    });
    $('#reset-starts-with').click(function() {
        window.location.href = $('#hidden-starts-with').val();
    });
    $('[data-toggle="tooltip"]').tooltip();
    $('#file-upload-control').settingsUpload();
    /*
    $('.referer').click(function() {
        var icon = $(this);
        var container = $('#banner-container');
        if (icon.data('show'))  {
            container.addClass('hidden');
            icon.data('show', false);
            return;
        }
        var d = new Date();
        var movie = 'http://tankionline.com/tankiref.swf?t=' + d.getTime();
        var flashvars = {
            hash: icon.data('referer'),
            server:'tankionline.com'
        };
        var params = {
            allowfullscreen: 'false',
            allowscriptaccess: 'always',
            wMode: 'transparent',
            menu: "false"
        };
        var attributes = {};
        container.removeClass('hidden');
        icon.data('show', true);
        swfobject.embedSWF(movie, 'banner-movie', '468', '120', '9.0.0', false, flashvars, params, attributes);
    });
    */
    $('#tanker-charts').tankerCharts({switch:'chart-switch'});
    $('.usage-chart-switch').weaponUsage();
});

;(function($, window, undefined) {

    var pluginName = "weaponUsage",
        defaults = {
            chart:{spacing:[0,0,0,0],backgroundColor:null,plotBackgroundColor:null,plotBorderWidth:null,plotShadow:false,type:'pie'},
            tooltip:{pointFormat:'<b>{point.percentage:.1f}%</b>'},
            legend:{enabled:false},
            plotOptions:{
                pie: {
                    allowPointSelect:true,
                    cursor:'pointer',
                    dataLabels:{enabled:false},
                    showInLegend:true
                }
            },
            title:{
                margin:5,
                style:{color:'#fff',fontSize:'14px'}
            },
        };

    function Charts(element, options) {
        this.element = element;
        this.options = $.extend( {}, defaults, options);
        this.chartTime = this.chartExp = null;
        this._defaults = defaults;
        this._name = pluginName;
        this.scope = $(this.element).data('scope');
        this.scores = $(this.element).data('score');
        this.times = $(this.element).data('time');
        this.init();
    };

    Charts.prototype = {

        init: function() {
            var $this = this;
            $(this.element).bind('click.' + pluginName, function() {
                $this.draw();
            });
        },

        draw: function() {
            var container = $('#' + this.scope + '-chart-container');
            if (this.chartTime) {
                this.chartTime.destroy();
                this.chartExp.destroy();
                this.chartTime = this.chartExp = null;
                container.empty();
                container.addClass('hidden');
            } else {
                container.removeClass('hidden');
                var tid = this.scope + '-time-chart-container';
                var tc = $('<div id="' + tid + '" class="usage-chart-container">');
                container.append(tc);
                var sid = this.scope + '-score-chart-container';
                var sc = $('<div id="' + sid + '" class="usage-chart-container">');
                container.append(sc);

                var ch = {};
                ch.chart = this.options.chart;
                ch.chart.renderTo = tid;
                ch.title = this.options.title;
                ch.title.text = LANG.bytime;
                ch.tooltip = this.options.tooltip;
                ch.legend = this.options.legend;
                ch.plotOptions = this.options.plotOptions;
                ch.series = [];
                ch.series.push({borderWidth:0,data:this.times});
                this.chartTime = new Highcharts.Chart(ch);

                ch.chart.renderTo = sid;
                ch.title.text = LANG.byexperience;
                ch.series = [];
                ch.series.push({borderWidth:0,data:this.scores});
                this.chartExp = new Highcharts.Chart(ch);
            }
        }

    };

    $.fn[pluginName] = function( options ) {
        return this.each(function () {
            if (!$.data(this, "plugin_" + pluginName)) {
                $.data(this, "plugin_" + pluginName, new Charts( this, options ));
            }
        });
    };
}) (jQuery, window);

;(function($, window, undefined) {

    var pluginName = "tankerCharts",
        defaults = {
            debug: true,
            rankpath:'/i/rank/xs/',
            chart:{borderRadius:3,type:'column'},
            xAxis:{type:'datetime',dateTimeLabelFormats:{day:'%d.%m'}},
            title:{text:''},
        };

    function Charts(element, options) {
        this.element = element;
        this.options = $.extend( {}, defaults, options);
        this.options.chart.renderTo = this.element;
        this.current = 'sc';
        this.chart = null;
        this._defaults = defaults;
        this._name = pluginName;

        this.init();
    };

    Charts.prototype = {

        init: function() {
            var $this = this;
            $('#' + this.options.switch).find('button').bind('click.' + pluginName, function() {
                $this.switchChart(this);
            });
            $(this.element).bind('change.' + pluginName, function() {

            });
            $this.toggleButtons();
            this.draw();
        },

        draw: function() {
            if (this.chart) this.chart.destroy();
            var ch = {};
            ch.chart = this.options.chart;
            ch.xAxis = this.options.xAxis;
            ch.title = this.options.title;
            if (this.current != 'sc') {
                ch.plotOptions = {series:{stacking:'normal'}};
                ch.tooltip = {
                    formatter: function() {
                        var s = Highcharts.dateFormat('%a, %b %d %Y', new Date(this.x));
                        $.each(this.points, function () {
                            s += '<br/><span style="color:' + this.color + '">\u25CF</span> ' + this.series.name + ': <b>' + Math.abs(this.y) + '</b>';
                        });
                        return s;
                    },
                    shared: true
                };
            }
            if (RKS && RKS.length) {
                var lines = [];
                for(var r = 0; r < RKS.length; r++) {
                    var icoid = RKS[r][1] > 31 ? 31 : RKS[r][1];
                    var line = {
                        value: RKS[r][0],
                        color: '#edbd00',
                        width: 1,
                        dashStyle: 'ShortDot',
                        label: {
                            useHTML: true,
                            text:'<img src="' + this.options.rankpath + icoid + '.png"/>',
                            rotation: 0,
                            align: 'center',
                            x: -2,
                            y: -5,
                        }
                    };
                    lines.push(line);
                }
                ch.xAxis.plotLines = lines;
            }
            switch (this.current) {
                case 'sc':
                    ch.yAxis = [
                        {title:{text:LANG.crystals},opposite:true},
                        {title:{text:LANG.experience},opposite:false}
                    ];
                    ch.series = [
                        {name:LANG.crystals,data:CRYS,yAxis:0},
                        {name:LANG.experience,data:SCORES,yAxis:1}
                    ];
                    break;
                case 'kd':
                    ch.yAxis = [
                        {title:{text:LANG.amount},labels:{formatter:function(){return Math.abs(this.value);}}},
                        {title:{text:null},opposite:true}
                    ];
                    ch.series = [
                        {name:LANG.kills,color:Highcharts.getOptions().colors[2],data:KILLS},
                        {name:LANG.deaths,color:Highcharts.getOptions().colors[3],data:DEATHS},
                        {name:LANG.kd,type:'spline',color: Highcharts.getOptions().colors[1],data:KD,yAxis:1}
                    ];
                    break;
                case 'bm':
                    ch.yAxis = [
                        {title:{text:LANG.experience}},
                        {title:{text:LANG.minutes},opposite:true}
                    ];
                    ch.series = [
                        {name:'DM',color:Highcharts.getOptions().colors[0],data:DM},
                        {name:'TDM',color:Highcharts.getOptions().colors[4],data:TDM},
                        {name:'CTF',color:Highcharts.getOptions().colors[2],data:CTF},
                        {name:'CP',color:Highcharts.getOptions().colors[3],data:CP},
                        {name:'ASL',color:Highcharts.getOptions().colors[5],data:AS},
                        {name:LANG.duration,type:'spline',color:Highcharts.getOptions().colors[1],data:TM,yAxis:1}
                    ];
                    break;
            }
            this.chart = new Highcharts.Chart(ch);
        },

        switchChart: function(obj) {
            var btn = $(obj);
            if (btn.hasClass('sw-sc')) this.current = 'sc';
            else if (btn.hasClass('sw-kd')) this.current = 'kd';
            else this.current = 'bm';
            this.toggleButtons();
            this.draw();
        },

        toggleButtons: function() {
            var $this = this;
            $('#' + this.options.switch).find('button').each(function() {
                if ($(this).hasClass('sw-' + $this.current)) {
                    $(this).addClass('btn-primary');
                    $this.options.title.text = $(this).text();
                }
                else $(this).removeClass('btn-primary');
            });
        }
    };

    function debug(text, type) {
        if (!defaults.debug) return;
        type = typeof type !== 'undefined' ? type : 'log';
        if (window.console) {
            if ('call' in console[type]) console[type].call(console, text);
            else console.log(text);
        }
    };

    $.fn[pluginName] = function( options ) {
        return this.each(function () {
            if (!$.data(this, "plugin_" + pluginName)) {
                $.data(this, "plugin_" + pluginName, new Charts( this, options ));
            }
        });
    };
}) (jQuery, window);

;(function($, window, undefined) {

    var pluginName = "settingsUpload",
        defaults = {
            debug: true,
            display: 'file-upload-display',
            apply:   'file-upload-apply',
            merge:   'file-upload-merge',
            replace: 'file-upload-replace',
            status:  'file-upload-status'
        };

    function Upload(element, options) {
        this.element = element;
        this.options = $.extend( {}, defaults, options);
        this.display = $('#' + this.options.display);
        this.display.data('initial', this.display.html());
        this.apply = $('#' + this.options.apply);
        this.merge = $('#' + this.options.merge);
        this.replace = $('#' + this.options.replace);
        this.status = $('#' + this.options.status);
        this.idf = '';

        this._defaults = defaults;
        this._name = pluginName;

        this.init();
    };

    Upload.prototype = {

        init: function() {
            if (!(window.FileReader && window.FileReader.prototype.readAsText)) {
                this.display.addClass('hidden');
                $('#upload-not-supported').removeClass('hidden');
                return;
            }
            var $this = this;
            $(this.element).bind('change.' + pluginName, function() {
                $this.changed();
            });
            this.apply.click(function(){ $this.submit('apply');});
            this.merge.click(function(){ $this.submit('merge');});
            this.replace.click(function(){ $this.submit('replace');});
        },

        changed: function() {
            this.result('', false);
            var $this = this;
            var files = this.element.files;
            if (files == undefined || files.length == 0) {
                $this.result('No file selected', true);
                return;
            }
            var filename = $(this.element).val().replace(/C:\\fakepath\\/i, '');
            this.display.html(filename);
            var file = files[0];
            var reader = new FileReader();
            reader.onload = function(e) {
                $this.loaded(e.target.result);
            };
            reader.onerror = function(e) {
                $this.result(e.target.error.code, true);
            };
            reader.readAsText(file);
        },

        loaded: function(content) {
            try {
                var json = JSON.parse(content); //$.parseJSON
                if (json.id) {
                    this.idf = json.id;
                    this.request();
                }
                else throw new SyntaxError('Unsupported file structure');
            } catch (e) {
                this.result('Unsupported file format', true);
            }
        },

        request: function() {
            $(this.element).attr('disabled', true);
            this.result('Loading info...', false);
            var $this = this;
            var req = $.post('/my/check/json', {id: $this.idf}, function(data) {
                if (!data.error) {
                    $this.result('', false);
                    $this.info(data.info);
                } else {
                    $this.idf = '';
                    $this.result(data.error, true);
                }
            }).fail(function(xhr) {
                $this.idf = '';
                $this.result(xhr.status + ' ' + xhr.statusText, true);
            }).always(function() {

            });
        },

        info: function(data) {
            if (data.same) {
                if (data.message) this.result(data.message, true);
                this.idf = '';
                return;
            }
            var cl = customLink(data.code);
            var link = '<a href="' + cl + '" target="_blank">' + cl + '</a>';
            if (data.code) this.result(data.message + ': ' + link, false);
            if (data.saved) {
                this.merge.removeClass('hidden');
                this.replace.removeClass('hidden');
            } else this.apply.removeClass('hidden');
        },

        submit: function(mode) {
            debug(mode);
            var $this = this;
            var req = $.post('/my/apply/json', {id: $this.idf, mode: mode}, function(data) {
                if (!data.error) {
                    window.location.href = '/';
                } else {
                    $this.idf = '';
                    $this.result(data.error, true);
                }
            }).fail(function(xhr) {
                $this.idf = '';
                $this.result(xhr.status + ' ' + xhr.statusText, true);
            }).always(function() {
                this.merge.addClass('hidden');
                this.replace.addClass('hidden');
                this.apply.addClass('hidden');
            });
        },

        result: function(text, iserr) {
            this.status.removeClass('hidden text-danger text-success text');
            this.status.empty();
            if (iserr) this.status.addClass('text-danger');
            else this.status.addClass('text-success');
            if (text) this.status.html(text);
            else this.status.addClass('hidden');
            if (iserr) {
                this.display.html(this.display.data('initial'));
                $(this.element).attr('disabled', false);
            }
        }
    };

    function debug(text, type) {
        if (!defaults.debug) return;
        type = typeof type !== 'undefined' ? type : 'log';
        if (window.console) {
            if ('call' in console[type]) console[type].call(console, text);
            else console.log(text);
        }
    };

    function customLink(code) {
        var loc = window.location;
        var port = (loc.port && loc.port != 80) ? ':' + loc.port : '';
        return loc.protocol + '//' + loc.hostname + port + '/custom/' + code;
    };

    $.fn[pluginName] = function( options ) {
        return this.each(function () {
            if (!$.data(this, "plugin_" + pluginName)) {
                $.data(this, "plugin_" + pluginName, new Upload( this, options ));
            }
        });
    };
}) (jQuery, window);
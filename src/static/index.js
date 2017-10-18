require('./styles/main.scss');

var Chart = require('chart.js');
var Elm = require('../elm/Main');

var app = Elm.Main.embed(document.getElementById('main'));

charts = {};

app.ports.plot.subscribe(function (options) {
    if (charts[id]) {
        charts[id].destroy();
    }
    var id = options.id;
    delete options.id;

    var type = options.chartType;
    delete options.chartType;

    options.type = type;
    var element = document.getElementById(id).getContext('2d');
    charts[id] = new Chart(element, options);
});



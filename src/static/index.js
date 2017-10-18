require('./styles/main.scss');

var Chart = require('chart.js');
var Elm = require('../elm/Main');

var input = {
    countryCode: require('../../dataset-artifacts/country_code_count.csv'),
    yearCount: require('../../dataset-artifacts/year_count_oldest_to_newest.csv'),
    pages: {
        about: require('../md/about.md')
    }
};

var app = Elm.Main.embed(document.getElementById('main'), input);

charts = {};
toRender = {};

var renderChart = function (id, options) {
    var ctx = document.getElementById(id).getContext('2d');
    ctx.canvas.width = 800;
    ctx.canvas.height = 400;
    charts[id] = new Chart(ctx, options);
};

app.ports.plot.subscribe(function (options) {
    if (charts[id]) {
        charts[id].destroy();
    }
    var id = options.id;
    delete options.id;

    var type = options.chartType;
    delete options.chartType;

    options.type = type;
    if (document.getElementById(id)) {
        renderChart(id, options);
    } else {
        toRender[id] = options;
    }
});

document.addEventListener("DOMNodeInserted", function (event) {
    for (var id in toRender) {
        if (document.getElementById(id)) {
            renderChart(id, toRender[id]);
            delete toRender[id];
        }
    }
});



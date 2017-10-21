require('./styles/main.scss');

var Chart = require('chart.js');
var Elm = require('../elm/Main');

var input = {
    files: {
        applicantCount: require('../../dataset-artifacts/applicant_count_top_20.csv'),
        categoryCount: require('../../dataset-artifacts/category_counts_all_time.csv'),
        categoryVsDecisionCount: require('../../dataset-artifacts/category_vs_decision_count.csv'),
        countryCode: require('../../dataset-artifacts/country_code_count.csv'),
        decisionCount: require('../../dataset-artifacts/decision_counts.csv'),
        deviceNounCount: require('../../dataset-artifacts/device_noun_count.csv'),
        expeditedReviewCount: require('../../dataset-artifacts/expedited_review_count.csv'),
        yearVsDecisionOrthoCount: require('../../dataset-artifacts/year_vs_decision_ortho_count.csv'),
        yearCount: require('../../dataset-artifacts/year_count_oldest_to_newest.csv')
    },
    pages: {
        about: require('./md/about.md'),
        section1: require('./md/1-safe-devices.md'),
        section2: require('./md/2-basic-demographics.md'),
        intro: require('./md/intro.md')
    }
};

var app = Elm.Main.embed(document.getElementById('main'), input);

Chart.defaults.global.defaultFontFamily = "'Open Sans', sans-serif";
Chart.defaults.global.defaultFontColor = "#555555";
Chart.defaults.global.defaultFontSize = 13;

charts = {};
toRender = {};

var renderChart = function (id, options) {
    var ctx = document.getElementById(id).getContext('2d');
    ctx.canvas.width = 800;
    ctx.canvas.height = options.height ? options.height : 400;
    delete options['height'];
    charts[id] = new Chart(ctx, Object.assign(options, {
        options: {
            maintainAspectRatio: false,
            scales: {
                xAxes: [{ stacked: true }],
                yAxes: [{ stacked: true }]
            }
        }
    }));
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



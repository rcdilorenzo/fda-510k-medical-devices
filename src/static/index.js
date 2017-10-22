require('./styles/main.scss');

var hljs = require('highlightjs');

var Chart = require('chart.js');
var Elm = require('../elm/Main');

var input = {
    files: {
        applicantCount: require('../../dataset-artifacts/applicant_count_top_20.csv'),
        categoryVsDecisionCount: require('../../dataset-artifacts/category_vs_decision_count.csv'),
        deviceNounCount: require('../../dataset-artifacts/device_noun_count.csv'),
        expeditedReviewCount: require('../../dataset-artifacts/expedited_review_count.csv'),
        reviewDaysAvgCount: require('../../dataset-artifacts/review_days_average_count.csv'),
        subcategoryVsDecisionCount: require('../../dataset-artifacts/subcategory_vs_decision_count.csv'),
        yearVsDecisionOrthoCount: require('../../dataset-artifacts/year_vs_decision_ortho_count.csv'),
        yearCount: require('../../dataset-artifacts/year_count_oldest_to_newest.csv')
    },
    pages: {
        about: require('./md/about.md'),
        process: require('./md/process.md'),
        intro: require('./md/intro.md'),
        section1: require('./md/1-safe-devices.md'),
        section2: require('./md/2-basic-demographics.md'),
        section3: require('./md/3-year-counts.md'),
        section4a: require('./md/4a-specific-devices.md'),
        section4b: require('./md/4b-specific-devices.md'),
        section5: require('./md/5-expedited-review.md'),
        section6: require('./md/6-review-duration.md'),
        section7: require('./md/7-top-applicants.md'),
        conclusion: require('./md/conclusion.md')
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
            elements: { line: { tension: 0 } },
            scales: {
                xAxes: [{ stacked: true, ticks: { maxRotation: 80 } }],
                yAxes: [{ stacked: true }]
            }
        }
    }));
};

app.ports.plot.subscribe(function (options) {
    var id = options.id;
    delete options.id;

    if (charts[id]) {
        charts[id].destroy();
    }

    var type = options.chartType;
    delete options.chartType;

    options.type = type;
    if (document.getElementById(id)) {
        renderChart(id, options);
    } else {
        toRender[id] = options;
    }
});

var hasClass = function (elem, klass) {
    return (" " + elem.className + " ").indexOf(" " + klass + " ") > -1;
}

var highlighting = {};

document.addEventListener("DOMNodeInserted", function (event) {
    var blocks = document.querySelectorAll('pre code');
    blocks.forEach(function (element) {
        if (!hasClass(element, 'hljs') && !highlighting[element]) {
            highlighting[element] = true;
            hljs.highlightBlock(element);
            highlighting[element] = false;
        }
    });

    for (var id in toRender) {
        if (document.getElementById(id)) {
            renderChart(id, toRender[id]);
            delete toRender[id];
        }
    }
});



statesTrace = {
    z: [1, 1, 2, 6, 8, 22, 35, 40, 48, 51, 58, 66, 80, 94, 109, 121, 141, 152, 163, 246, 273, 275, 276, 303, 316, 333, 481, 622, 636, 1028, 1035, 1039, 1158, 1542, 1606, 1619, 1658, 2066, 2163, 2195, 2258, 2279, 2469, 3107, 3806, 4911, 4945, 5009, 5157, 5850, 6121, 7233, 8270, 23561, 25123],
    colorscale: [['0', 'rgb(200,200,200)'], ['1', 'rgb(255,0,0)']],
    locationmode: 'USA-states',
    locations: ['KA', 'P', 'AK', 'WY', 'KT', 'WV', 'SD', 'ND', 'HI', 'AR', 'MT', 'PR', 'ID', 'LA', 'VT', 'NM', 'MS', 'KY', 'NE', 'OK', 'SC', 'IA', 'ME', 'AL', 'RI', 'NV', 'KS', 'DE', 'NH', 'OR', 'VA', 'AZ', 'NC', 'UT', 'MO', 'GA', 'WA', 'DC', 'TN', 'WI', 'CT', 'CO', 'MD', 'OH', 'IN', 'MI', 'TX', 'PA', 'MN', 'FL', 'NY', 'NJ', 'MA', 'CA', 'IL'],
    locationssrc: 'rcdilorenzo:7:2534e0',
    type: 'choropleth',
    zsrc: 'rcdilorenzo:7:36d235'
};

module.exports = {
    states: { data: [statesTrace], layout: {geo: {scope: 'usa'}}}
};

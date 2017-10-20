# Introduction

Since 1976, medical devices designated a Class I, II, or III type for human applications have been required to undergo a 510(k) application to the FDA to determine safety. The purpose of this requirement is to verify that the new device is at least as safe and effective as existing legal products on the market. This submission is mandatory at least 90 days in advance of its marketing.

To more fully understand the 510(k) submissions to the FDA, a number of questions will be examined using various vizualizations. See the process section above for a more detailed, technical background on how the analysis was performed.

0. What kind of devices tend to get approved?
0. What are the demographics of the type of devices submitted?
0. What type of review committees tend to approve devices?
0. Where do most submissions come from geographically?
0. How often do reviews get expedited?
0. What companies make the most submissions?
0. How long do most reviews take?

This [dataset](https://l.rcd.zone/fda-510k-dataset) from the openFDA project [started in 2014](https://open.fda.gov/update/openfda-innovative-initiative-opens-door-to-wealth-of-fda-publicly-available-data/) incorporates a number of data attributes including but not limited to:

- Address: `street number, postal code, zip code, state, country code`
- Device: `name, class, identification regulation/registration numbers`
- Review: `date received, decision date, description, committee`

# Data Questions

As this exploration is part of my graduate program M.S. in Data Science, I am no expert in the medical field and do not attempt to be authoritative or push industry changes. My goal, instead, is to pursue some interesting answers to questions that could arise from a dataset such as this one. See the *About* section for more background. Although some of the data is processed on the fly as seen here, it has been significantly condensed from its original 1 GB size from [open.fda.gov](https://open.fda.gov). All data present here should be up-to-date as of the end of September 2017 when it was downloaded. For more information on the condensed formats, see the *Process* section as well as the [source code](https://l.rcd.zone/fda-repo) for this web application.

## What kind of devices are considered safe?

With just over 148,000 records in this dataset, a wide variety of medical devices are included since the 510(k) clearance began in 1976. Perhaps one of the most important questions to consider is the review decision based on the type of medical device. After a bit of analysis, it appears that the FDA has a particular review committee for eah of the general categories of devices since less than a 1% difference exists between the committee decisions and the categorization of the device.

<canvas id="catVsDec"></canvas>
<small>**Figure:** FDA approval decisions broken down by general categorization. *Note that each dataset can be toggled by pressing the legend label to easily see smaller categorical differences.*</small>

At a glance, the vast majority across all device categories are considered "Substantially Equivalent." However, if that category is disabled above, "Gastroenterology-urology devices" and "Orthopedic devices" have the most uncertainty with the former having the most marked "Unknown" and the latter primarily "Substantially Equivalent for Some Indications." Notice the other two close categories "General and plastic surgery" as well as "General hospital and personal use devices." The graph below is a reprint of the above one with the major category removed.

<canvas id="catVsDec--no-primary"></canvas>
<small>**Figure:** FDA approval decisions except for "Substantially Equivalent."</small>

Taking a closer look at the uncertainty of "Orthopedic devices," the submissions seem to be an area of interest with a growing number each year since 1976. When the "Substantially Equivalent" is hidden below, the bulk of the "Substantially Equivalent for Some Indications" occurred between 1985 and 1998 while the much fewer "Unknown" decisions primarily center around 2012 at 16 devices. Therefore, it seems that although this category has the least comparability to existing marketed devices most of these alternate decisions are in the past. 

<canvas id="yearVsDecision--ortho"></canvas>
<small>**Figure:** FDA approval decisions by year within the "Orthopedic devices" category.</small>

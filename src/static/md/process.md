# Process

As with most journeys, mine began by searching the internet. This quest, however, was not for memes or cat videos but for a real dataset that I could manipulate using data science and programming tools. Once I discovered the data from [open.fda.gov](https://open.fda.gov/), I became interested in the [device clearances dataset](https://open.fda.gov/device/510k/reference/) since it was one of the larger ones available (about ~ 1 GB uncompressed). From here, I began a multi-stage process following this outline:

0. [Importing Data](#importing-data)
0. [Setup Business Goals](#setup-business-goals)
0. [Data Analysis](#data-analysis)
0. [Data Presentation](#data-presentation)

## Importing Data

Although an API was directly available from the FDA, it was unsuitable for my purposes since I needed to quickly run complex queries that would be impossible through the API. Additionally, I needed to use some data science related tools for the class; this decision, therefore, became easy to make. With my software engineering background, I was quite familiar with the JSON format yet even at the beginning had an inkling that a fully-formated JSON block might be difficult to import into "Big Data" tools.

At this point, the JSON looked something like this:

```json
{
  "meta": {
    "last_updated": ...
    "terms": ...
    "results": {
      "skip": 0,
      "total": 148008,
      "limit": 148008
    },
    "license": ...
    "disclaimer": ...
  },
  "results": [
    {...},
    {...},
    ...
  ]
}
```

Before getting it into any tools, I knew that I needed to at least have a file with only the list of the JSON items instead of this "meta" information at the top level. Because I had a bought a used rack server with 32 GB of RAM and two Quad-core Intel Xeons, I decided to brute force it by running through the command line utility [jq](https://stedolan.github.io/jq/):

```bash
$ cat device-510k-0001-of-0001.json | jq '.results' > device-510k-converted.json
```

From this point, I imported into the Hadoop cluster I was working on using a command such as this one:
```bash
$ hadoop fs -copyFromLocal /usr/data/scripts/device-510k-converted.json /user/rcdilorenzo/
```

Unfortunately, I became a bit stuck investigating how to get this dataset into [Apache Hive](https://hive.apache.org/) so that I could visually explore it and perform analysis. To do this, I hoped to use other tools provided by [Hortonworks Data Platform](https://hortonworks.com/products/data-center/hdp/) (HDP) on the rack server to accomplish this goal. [Apache Pig](https://pig.apache.org/) was my first attempt before I realized that most "Big Data" tools expect the JSON to be line-by-line rather than one enormous array. I was attempting to apply [Twitter's Elephant Bird JSON plugin](https://github.com/twitter/elephant-bird) when I came to this realization. Though I did get Apache Pig to read the data, the translation to an HBase Catalog table within Hadoop was nearly impossible since the schema of columns and types was being determined on-the-fly by Elephant Bird.

Having discovered this alternate format, I scoured the web looking for conversion to a line-by-line based JSON format. The few tools I did find were quite disappointing. Therefore, I pulled out one of my favorite languages for this job writing the script below to manually stream each line and group until a single-line JSON object could be appended to the output file.

```elixir
defmodule MultiLineConvert do
  def start(input_path, output_path) do
    stream = File.stream!(input_path)
    file = File.open!(output_path, [:write, :append])

    stream
    |> Stream.chunk_while("", &chunk/2, &({:cont, &1, []}))
    |> Stream.each(&IO.binwrite(file, &1 <> "\n"))
    |> Stream.run
  end

  defp chunk("[\n", acc), do: {:cont, acc}
  defp chunk("]\n", acc), do: {:cont, acc}

  defp chunk(line, acc) when line in ["  },\n", "  }\n"] do
    {:cont, acc <> "}", ""}
  end

  defp chunk(line, acc) do
    trimmed = String.trim(line)
    {:cont, acc <> trimmed}
  end
end

MultiLineConvert.start("../device-510k-converted.json", "device-510k-fda.txt.json")
```

After letting this project rest for a week or two while working on new tools, I decided against using Hive with HBase and moved towards using [Spark](https://spark.apache.org/) with python and SQL in an [Apache Zeppelin](https://zeppelin.apache.org/) notebook. About this same time, I built my own computer with significantly higher clock speeds and RAM than the rack server. This machinery upgrade meant that I moved away from the Ambari views provided by HDP and towards using a Zeppelin notebook without a backing HDFS (Hadoop Distributed File System).

Once I settled on the Zeppelin notebook, I was able to easily import the data with this simple snippet:

```python
path = "./data/device-510k-converted.txt.json"
devices = spark.read.json(path)

devices.createOrReplaceTempView("medicaldevices")
devices.printSchema()
# root
#  |-- address_1: string (nullable = true)
#  |-- address_2: string (nullable = true)
#  |-- advisory_committee: string (nullable = true)
#  |-- advisory_committee_description: string (nullable = true)
#  |-- applicant: string (nullable = true)
#  |-- city: string (nullable = true)
#  |-- clearance_type: string (nullable = true)
#  |-- contact: string (nullable = true)
#  |-- country_code: string (nullable = true)
#  |-- date_received: string (nullable = true)
#  |-- decision_code: string (nullable = true)
#  |-- decision_date: string (nullable = true)
#  |-- decision_description: string (nullable = true)
#  |-- device_name: string (nullable = true)
#  |-- expedited_review_flag: string (nullable = true)
#  |-- k_number: string (nullable = true)
#  |-- openfda: struct (nullable = true)
#  |    |-- device_class: string (nullable = true)
#  |    |-- device_name: string (nullable = true)
#  |    |-- fei_number: array (nullable = true)
#  |    |    |-- element: string (containsNull = true)
#  |    |-- medical_specialty_description: string (nullable = true)
#  |    |-- registration_number: array (nullable = true)
#  |    |    |-- element: string (containsNull = true)
#  |    |-- regulation_number: string (nullable = true)
#  |-- postal_code: string (nullable = true)
#  |-- product_code: string (nullable = true)
#  |-- review_advisory_committee: string (nullable = true)
#  |-- state: string (nullable = true)
#  |-- statement_or_summary: string (nullable = true)
#  |-- third_party_flag: string (nullable = true)
#  |-- zip_code: string (nullable = true)
```

## Setup Business Goals

For this sample project to be valuable, it was necessary to create specific questions that could be answerable by the medical devices data. These questions need to be potentially valuable to those in the business. Thankfully, with two people in my immediate family, I was able to validate these questions a bit at the end of the project based on their feedback.

To begin, I brainstormed on some questions to guide my analysis and exploration.

- What kind of devices tend to get approved?
- What are the demographics of the type of devices submitted?
- What type of review committees tend to approve devices?
- Is there any correlation between time of year and approval percentage?
- Where do most submissions come from geographically?
- How often do reviews get expedited?
- What can be gathered from the free-text summary statements of the reviews?

As compared with the actual list from the *Results* tab, some questions were slightly modified while others ended up being thrown out completely. For example, the question about review committees became irrelevant when I graphed the committee grouped decisions in comparison to the general category grouped decisions. Apparently, a review committee was created for each category of device submitted, making these two graphs within 1% difference.

## Data Analysis

All of the analysis work was performed inside of a Zeppelin notebook available in the [GitHub repository](https://git.io/vdNzH). However, instead of going over each block from that notebook, I will explain some of the more interesting bits. If you do not have a Zeppelin installation handy, [a preview version](https://github.com/rcdilorenzo/fda-510k-medical-devices/raw/4b89c109006581935e41b1fb1ced97a585bfe56c/zeppelin-notebook-snapshot-10-2017.pdf) of the notebook is available.

Because Zeppelin uses Spark underneath, I was not sure exactly how much of SQL could be used especially in terms of aggregate functions. In fact, I only later discovered that the `substring` function could be used since it seemed not work intially. This discovery lead to more small blocks of SQL rather than large blocks of more direct PySpark manipulations. For example, I was able to execute the following SQL statement to load all of the decisions for the category "Orthopedic devices" and group them by year and count the frequencies:

```sql
SELECT decision_year, decision_description, COUNT(*) as decision_count FROM
  (SELECT substring(decision_date, 0, 4) as decision_year, decision_description FROM medicaldevices
  INNER JOIN device_types ON medicaldevices.openfda.regulation_number = device_types.type_id
  WHERE device_types.category_name = 'Orthopedic devices')
GROUP BY decision_year, decision_description ORDER BY decision_year, decision_count DESC LIMIT 100
```

This particular query is presented in the first question on the *Process* tab. Additionally, the `JOIN` to the `device_types` table is another highlight of the analysis. As described in the documentation for the dataset, the `openfda.regulation_number` is a two-level category indicator where the left side of the period is the general category left and the specific category number is on the right (e.g. `general.specific` like in `866.3510`). Unfortunately, however, the labels for these are found on a website and not in a downloadable format.

To this end, I wrote a python script using the library [BeautifulSoup](https://www.crummy.com/software/BeautifulSoup/) to scrape everything directly off of the webpage along with its related links and then save the results in another temporary view:

```python
import requests
import re
import pandas as pd
from bs4 import BeautifulSoup
from itertools import dropwhile
from operator import add

base = "http//www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfcfr"
# ^ I had to drop the colon to maintain code formatting.

initial = requests.get(base + "/CFRSearch.cfm?CFRPartFrom=862&CFRPartTo=892").text

initial_soup = BeautifulSoup(initial, "lxml")
initial_links = initial_soup.find(id="user_provided").find_all('a')[3:]


def capture_first_in(expression, element):
    return re.search(expression, element.text).group(1)
    
def category(link):
    name = link.text
    url = base + link.get("href")[1:]
    return [[name] + single_part for single_part in part(url)]
    
def part(url):
    text = requests.get(url).text
    soup = BeautifulSoup(text, "lxml")
    content = soup.find(id="user_provided")
    subpart_links = filter(lambda x: "Subpart" in x.text, content.find_all('a'))
    return reduce(add, [subpart(link) for link in subpart_links])
    
def subpart(link):
    letter = capture_first_in("Subpart (\w)", link)
    name = capture_first_in("--(.+)$", link)
    part_links = link.parent.parent.find_all('a')[1:]
    return [[letter, name] + individual_part(part_link) for part_link in part_links]
    
def individual_part(link):
    subpart_number = int(capture_first_in(" (\d+)\.", link))
    number = int(capture_first_in(" \d+\.(\d+)", link))
    id = capture_first_in(" (\d+\.\d+)", link)
    name = re.search("- ([\w .]+)", link.next_sibling).group(1)[:-1]
    return [id, subpart_number, number, name]

all = reduce(lambda acc, link: acc + category(link), initial_links, list())
columns = ["category_name", "subcategory_letter", "subcategory_name",
           "type_id", "category_code", "type_code", "type_name"]
frame = spark.createDataFrame(pd.DataFrame(all, columns=columns))
frame.createOrReplaceTempView("device_types")
```

With this temporary view store, then, I was able to join it to the original set by splitting out the general from the specific categories and performing `WHERE` clauses on both to achieved what was desired.

Aside from these two examples, the other code blocks took similar approaches but incorporated different aspects of the data. Once a code block was ready, I downloaded each table result as a CSV which could then be plugged directly into the web application.

## Data Presentation

In this final part, I was able to combine everything I had worked on into a single, cohesive website. As a software engineer, I am always up for doing more programming and designing beautiful things. In this case, I decided to go with the following web stack because it provided the best balanace of runtime guarentees, on-the-fly processing, and experimental tooling.

Compilation - [Webpack](https://webpack.js.org/)

Discussion Text - [Markdown]()

Languages - [Elm](http://elm-lang.org/) (with a little bit of necessary Javascript), [SCSS](http://sass-lang.com/guide)

Libraries - [elm-markdown](https://github.com/evancz/elm-markdown), [elm-csv-decode](http://package.elm-lang.org/packages/jinjor/elm-csv-decode/latest), [ChartJS](http://www.chartjs.org/)

Most of the work was processing the graphs, but a significant amount of the initial work was making sure Elm could interop with Javascript and call ChartJS appropriately. Once that was setup, I wasted no time in getting to the other necessary details. I even got a bit of design assistance from one of my co-workers. Of course, because this was put together in just under a week, some features and a couple of strange bugs still exist such as no proper URL routing. That said, I have to keep reminding myself that it is a demo website rather than an application depended upon by hundreds of people.

To handle dynamic interaction, I took the downloaded CSVs mentioned earlier and had webpack import them directly such that Elm could create charts and manipulate them as needed. Once the webpage is first loaded, all of the chart data is computed from the CSVs such that the only work left is for ChartJS. In short, I am extremely happy about how the website part of this project turned out and how easy it is to see the relevant data.



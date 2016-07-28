# Apriori algorithm application through PEMA class

This is a prototype to try out PEMA class in RevoPemaR package.


## Purpose

The purpose of this project is to show one possible way to utilize PEMA class through Apriori algorithm application.


## What is PEMA?

PEMA stands for Parallel External Memory Algorithm, which does not require all of the data to be in memory at one time.  


## More about PEMA

[RevoPema Getting Started Guide](https://msdn.microsoft.com/en-us/microsoft-r/pemar-getting-started)


## Data

[MovieLens dataset](https://grouplens.org/datasets/movielens/)


## How to Run

1. Download MovieLens datasets and unzip them under `org-data` folder which is in your home directory.
2. Create a folder named `input` in your home directory.
3. Execute `data_conversion.R`. This creates a bunch of files in `input` folder.
4. Execute `PemaAprioriExec.R`, maybe first and later half separately.


## To be Considered

1. How to eliminate redundant rules from the result of Apriori.
2. How to adjust Apriori computation when ids are sparsed integers.
3. How to distribute Apriori algorithm execution.


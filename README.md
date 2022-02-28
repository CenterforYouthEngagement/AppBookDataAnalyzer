# AppBookDataAnalyzer

This Mac app contains UI and processing code for analyzing AppBook student data directories coming from our iPads. The app includes classes for supporting multiple `Curriculum`s (eg. INSITE 2022-4-18) and multiple `Analytic`s to analyze. 

## Data Pipeline

The backbone of the app is the `DataPipelineManager` which manages:
1. `DirectoryDropDelegate` - retrieving a file path from the iPad student data directory that should be dropped from the Finder into the application's window. 
2. `DataDirectory` - which parses the dropped directory, outputting an array of `Database`s, one for each student that used this iPad.
3. `DatabaseAnalyzer` - which uses the `Curriculum` being analyzed, the student `Database`, and the `Analytic`s to be measured to output a `.csv` file (using `CSVOutput.swift`) containing all of the analytics desired. 


## Output

The output of the app is a CSV for each student `Database` found in the dropped directory. The CSV contains rows for each analytic event and columns for each page and job in the curriculum. A sample can be found [here](https://docs.google.com/spreadsheets/d/1wf1Ktjs9QQae_LsRDzpw8R-5H3Ca-w8_nnALRSP_fyI/edit?usp=sharing).

## Analytic

`Analytic` is a protocol to be implemented by each analytic we need to track (the rows in the output). This protocol asks that the implementing class have `title` (to be used as the row title in the output) and implement a function to analyze a given `Database` at a given `Column`. This function should run queries on an `FMDatabase` from the `FMDB` framework, same as we do in `AppBook`, and output the result of the analysis for this `Analytic` at the this `Column` (`.page` or `.job`). 

## Todo

- [ ] Drag and drop is not working
- [ ] Determine if we should use sync or async database access
- [ ] Create analytic events for each of our analytics
- [ ] Implement `CSVOutput.writeCSVToDisk()`. This can be done with `SwiftCSV` (3rd-party CSV writer for swift) or `TabularData` (1st-party CSV framework written by Apple)
- [X] Hard code columns for `insite20220418` - AppBooks and Jobs
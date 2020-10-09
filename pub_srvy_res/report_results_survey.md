# Current development on BIDS BEP029
This is a quick update on some ongoing discussion about the Motion Capture extension for BIDS ([BEP029](https://docs.google.com/document/d/1iaaLKgWjK5pcISD1MVxHKexB3PZWfE2aAC5HF_pCZWo/edit)). In the following we present results from a recent survey on BIDS Motion Capture supplementing previous discussions by Stefan Appelhoff, Helena Cockx, Sein Jeung, Robert Oostenveld and Julius Welzel. The scope of the survey was to better understand the needs of the BIDS community with regard to Motion Capture.

## Data collection
The survey was held online from June to September 2020 and distributed via Twitter and several mailing lists (e.g. FieldTrip). A total of 26 participants completed the form.<br>

## Moving forward
Getting things started, we encountered following questions regarding this extension which we try to answer as follows:<br>

### Score of BIDS-Motion
The aim is to develop BIDS compatible standards for non-brain motion data which is usable with brain data from other BIDS formats. For the first bit of the extension, we will focus on capturing physical motion (of the human body), but keep virtual motion in mind. The survey showed, that people capturing __only__ virtual motion are exclusively from the MR community. <br>

![space_per_mod](F2_space_per_mod.png)

### Data format
Using binary coded UTF-8 data for this BIDS extension, preferably .tsv seems to be the most favourable solution at the moment. Other datatypes mentioned in the survey (e.g.: .xdf, .c3d, .set) will further be explored.

### Data synchronization
How to synchronize different types of motion data streams is one of the questions which needs more work. For example IMU recordings can be grouped by recording position (_grey boxes_) or by type of recording (_coloured boxes_). This will have a direct consequence on organizing the BIDS directory structure.<br>

![placement](example_grps.jpg)

### Sensor placement
In the previous point, recording locations are mentioned. During the development of the extension we hope to provide a placement scheme which uses numeric coding or letters to define the exact placement of sensors or markers at the human body. This scheme will build upon existing ideas and be in partial agreement with the [ISPGR](https://ispgr.org/) and [MDS](https://www.movementdisorders.org/). The survey revealed a heterogenious behaviour when handling placement of sensors and markers.<br>

![placement](F3_plc_per_sys.png)

### BIDS conversion script
For converting recordings (e.g. XDF-files) we are developing a MatLab conversion script based on the [data2bids](https://www.fieldtriptoolbox.org/reference/data2bids/) example. This should help to directly convert motion capture recordings to BIDS structure.

### Timeline
For the rest of the year, we plan to provide a ontology about motion capture in confirmation with current BIDS and to solve the grouping issue of recording. By _roughly_ mid 2021 we hope to have developed a first draft of the Google-Doc. We are happy about contributions from within and outside the BIDS community.

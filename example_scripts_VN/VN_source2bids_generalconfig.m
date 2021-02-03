% modality agnostic metadata

% initialize general config struct shared across modalities
cfg = [];

% root directory
cfg.bidsroot                                = 'P:\Sein_Jeung\Project_Virtual_Navigation\Virtual_Navigation_data\data_E1\rawdata';  % write to the present working directory

% required for dataset_description.json
cfg.dataset_description.Name                = 'Example EEG and Motion Data: Virtual Navigation';
cfg.dataset_description.BIDSVersion         = 'unofficial extension';

% optional for dataset_description.json
cfg.dataset_description.License             = 'n/a';
cfg.dataset_description.Authors             = 'SJ, CD, KG';
cfg.dataset_description.Acknowledgements    = 'Special thanks to Arthur Morgan & Dutch van der Linde';
cfg.dataset_description.Funding             = 'n/a';
cfg.dataset_description.ReferencesAndLinks  = 'n/a';
cfg.dataset_description.DatasetDOI          = 'n/a';

% general information shared across modality specific json files 
cfg.InstitutionName                         = 'Technische Universitaet zu Berlin';
cfg.InstitutionalDepartmentName             = 'Biological Psychology and Neuroergonomics';
cfg.InstitutionAddress                      = 'Strasse des 17. Juni 135, 10623, Berlin, Germany';
cfg.TaskDescription                         = 'Navigation and spatial memory task.';
cfg.task                                    = 'VirtualNavigation';
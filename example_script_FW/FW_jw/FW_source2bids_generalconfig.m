% modality agnostic metadata

% initialize general config struct shared across modalities
cfg = [];

% root directory
cfg.bidsroot                                = 'C:\Users\juliu\Desktop\BIDS_motion_nj\sourcedata\';  % write to the present working directory

% required for dataset_description.json
cfg.dataset_description.Name                = 'free walking study';
cfg.dataset_description.BIDSVersion         = 'unofficial extension BEP029';

% optional for dataset_description.json
cfg.dataset_description.License             = 'n/a';
cfg.dataset_description.Authors             = 'NJ, SB, CW, SD';
cfg.dataset_description.Acknowledgements    = 'We would like to thank Lisa Straetmans for her support during data collection, Nils Eckhardt for his help in validating our gait detection procedure with a motion capture system, Reiner Emkes for hardware support, and Joanna Scanlon for her assistance during piloting. ';
cfg.dataset_description.Funding             = 'n/a';
cfg.dataset_description.ReferencesAndLinks  = 'n/a';
cfg.dataset_description.DatasetDOI          = 'n/a';

% general information shared across modality specific json files 
cfg.InstitutionName                         = 'Carl von Ossietzky Universität Oldenburg';
cfg.InstitutionalDepartmentName             = 'Department für Psychologie, Abt. Neuropsychologie';
cfg.InstitutionAddress                      = 'Ammerländer Heerstr. 114-118, Oldenburg, Germany';
cfg.TaskDescription                         = 'This free walking experiment consists of 16 participants. Subjects walked two different routes outdoors. Each route was walked twice. Once while pressing buttons in a self-paced manner.';
cfg.task                                    = 'FreeWalking';
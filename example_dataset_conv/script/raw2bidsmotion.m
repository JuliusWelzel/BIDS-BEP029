%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%             Process Raw data to convert to BIDS motion
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Data: Validation dataset (Elke Warmerdam, University of Kiel, https://www.mdpi.com/1424-8220/21/17/5833)
% Author: Julius Welzel, j.welzel@neurologie.uni-kiel.de

close all, clear all, clc;
% settings
display(['This script uses fieldtrip verision: ' ft_version])
display(['This script uses BIDS version 1.4.0 // BEP029'])

path_raw = fullfile(fileparts('C:\Users\User\Desktop\bids_motion_validation\'));

%% prep imu data
flist       = dir(path_raw);
flist       = flist(contains({flist.name},'pp'));

nms_subs    = extractAfter({flist.name},'sub-');

for s = 1:numel(nms_subs)

    %% prep data for BIDS conversion
    nms_tasks   = dir(fullfile(path_raw,['sub-' nms_subs{s} filesep 'motion' filesep]));
    nms_tasks   = nms_tasks(contains({nms_tasks.name},'.mat'));
    nms_tasks   = extractBetween({nms_tasks.name},'imu_','.mat');
    
    for t = 1:numel(nms_tasks)
        % load raw data
        load(fullfile(path_raw,['sub-' nms_subs{s} filesep 'motion' filesep],['imu_',nms_tasks{t},'.mat']))
        imu = data;
        clear data

        % extract data per type and store in ft like struct
        data_acc = [];
        [data_acc.label nms_acc_type nms_acc_loc nms_acc_comp]      = locs2chans(imu.imu_location,{'ACC'}); % only location, not label for *channels.tsv. Append accordingly :)
        data_acc.trial{1}   = reshape(imu.acc,[],size(imu.acc,2) * size(imu.acc,3))'; % change 3d matrix to 2d, where 2nd dim are all avaliable channels from tracking system
        data_acc.time{1}    = linspace(0,length(data_acc.trial{1})/imu.fs,length(data_acc.trial{1}));

        data_gyro = [];
        [data_gyro.label nms_gyro_type nms_gyro_loc nms_gyro_comp]     = locs2chans(imu.imu_location,{'ANGVEL'}); % only location, not label for *channels.tsv. Append accordingly :)
        data_gyro.trial{1}   = reshape(imu.acc,[],size(imu.acc,2) * size(imu.acc,3))'; % change 3d matrix to 2d, where 2nd dim are all avaliable channels from tracking system
        data_gyro.time{1}    = linspace(0,length(data_gyro.trial{1})/imu.fs,length(data_gyro.trial{1}));

        data_magn = [];
        [data_magn.label nms_magn_type nms_magn_loc nms_magn_comp]     = locs2chans(imu.imu_location,{'MAGN'}); % only location, not label for *channels.tsv. Append accordingly :)
        data_magn.trial{1}   = reshape(imu.acc,[],size(imu.acc,2) * size(imu.acc,3))'; % change 3d matrix to 2d, where 2nd dim are all avaliable channels from tracking system
        data_magn.time{1}    = linspace(0,length(data_magn.trial{1})/imu.fs,length(data_magn.trial{1}));

        % combine data
        cfg = [];
        dat_imu = ft_appenddata(cfg, data_acc, data_gyro, data_magn);

        % construct ft header
        dat_imu.hdr.Fs                  = dat_imu.fsample;
        dat_imu.hdr.nSamples            = length(dat_imu.time{1});
        dat_imu.hdr.nTrials             = size(dat_imu.trial);
        dat_imu.hdr.nChans              = size(dat_imu.trial{1},1);
        dat_imu.hdr.chantype            = horzcat(nms_acc_type,nms_gyro_type,nms_magn_type);
        dat_imu.hdr.chanunit            = dat_imu.hdr.chantype;
        dat_imu.hdr.label               = dat_imu.label;

        %% start BIDS conversion
        cfg = [];
        cfg.datatype = 'motion';
        cfg.method = 'convert';

        %%%%%%%%%% Modality agnostic info %%%%%%%%%%%%%%%%%%%%%%

        % required for dataset_description.json
        cfg.dataset_description.Name                = 'Neurological validation dataset';
        cfg.dataset_description.BIDSVersion         = 'BEP029';
        cfg.dataset_description.License             = 'n/a';
        cfg.dataset_description.Authors             = 'Elke Warmerdam,Robbin Romijnders,Johanna Geritz,Morad Elshehabi,Corina Maetzler,Jan Carl Otto,Maren Reimer,Klarissa Stuerner,Ralf Baron,Steffen PaschenORCID,Thorben Beyer,Denise Dopcke,Tobias Eiken,Hendrik Ortmann,Falko Peters,Felix von der Recke,Moritz Riesen,Gothia Rohwedder,Anna Schaade,Maike Schumacher,Anton Sondermann,Walter Maetzler and Clint Hansen';
        cfg.dataset_description.Acknowledgements    = 'n/a';
        cfg.dataset_description.Funding             = 'Mobilise-D';
        cfg.dataset_description.ReferencesAndLinks  = 'https://www.mdpi.com/1424-8220/21/17/5833';
        cfg.dataset_description.DatasetDOI          = 'doi.org/10.3390/s21175833';


        %%%%%%%%%% Motion specific info %%%%%%%%%%%%%%%%%%%%%%


        % construct file and participant- and file- specific config
        % information needed to construct file paths and names
        cfg.sub                         = nms_subs{s};
        cfg.task                        = nms_tasks{t}; 
        cfg.tracksys                    = "imu";
        cfg.TrackingSystemCount         = numel(cfg.tracksys);
        cfg.channels.tracked_point      = horzcat(nms_acc_loc,nms_gyro_loc,nms_magn_loc);
        cfg.channels.component          = horzcat(nms_acc_comp,nms_gyro_comp,nms_magn_comp);
        cfg.channels.name               = dat_imu.label;

        cfg.motion.Manufacturer                 = 'Noraoxon';
        cfg.motion.ManufacturersModelName       = 'MyoMOTION';
        cfg.motion.SubjectArtefactDescription   = 'n/a';
        cfg.motion.tracksys.imu.TrackPointsCount    = numel(cfg.channels.tracked_point);

        cfg.motion.trsystems    = {'imu'};

        cfg.bidsroot = 'C:\Users\User\Desktop\bids_motion_validation';

        cfg.writejson = 'yes';
        cfg.writetsv = 'yes';
        % save as BIDS
        data2bids_mot(cfg,dat_imu)
    end

    % check error in json
   
end


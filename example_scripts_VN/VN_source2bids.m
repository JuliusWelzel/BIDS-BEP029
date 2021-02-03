% Examaple script for converting .xdf recordings to BIDS 
% Author : Sein Jeung (seinjeung@gmail.com)

% initialze fieldtrip 
ft_defaults

% path to sourcedata 
sourceDataPath          = 'P:\Sein_Jeung\Project_Virtual_Navigation\Virtual_Navigation_data\data_E1\sourcedata'; 
addpath(genpath(sourceDataPath))

% range of (effective) sampling rate of data, used for identifying streams
% in .xdf
motionSRateRange        = [30 100]; 
eegSRateRange           = [900 1100];

% funcions that resolve dataset-specific problems
motionCustom            = 'vn_bids_custom_motion'; 
        
% participants label used to read in the info files
participants            = { 'sub1' ...
                            'sub2', ...
                            'sub3', ...
                           };                      
                       
% load general metadata that apply to all participants
VN_source2bids_generalconfig;

%--------------------------------------------------------------------------
% loop over participants
for pi = 1:numel(participants)
    
    % load participant information 
    eval([participants{pi} '_info']);
    datafiles   = subjectdata.datafiles;

    % loop over datafiles 
    for di = 1:numel(datafiles)
        
        % construct file and participant-specific metadata 
        VN_source2bids_participants; 
        
        %------------------------------------------------------------------
        %                   Convert Motion Data to BIDS
        %------------------------------------------------------------------
        % import motion data
        motionSource                = xdf2fieldtrip(cfg.dataset,'sraterange', motionSRateRange);
        
        % if needed, execute a custom function for any alteration 
        % to the data to address dataset specific issues 
        % (quat2eul conversion, for instance)
        if exist('motionCustom','var')
            motion                      = feval(motionCustom, motionSource);
        else
            motion = motionSource; 
        end
        
        % construct motion metadata
        VN_source2bids_motionconfig;
        
        % write motion files in bids format
        data2bids(motioncfg, motion);
        
        %------------------------------------------------------------------
        %                    Convert EEG Data to BIDS
        %------------------------------------------------------------------
        % import eeg data
        eegSource                       = xdf2fieldtrip(cfg.dataset,'sraterange', eegSRateRange);
        
        % if needed, execute a custom function for any alteration
        % to the data to address dataset specific issues
        if exist('eegCustom','var')
            eeg                      = feval(eegCustom, eegSource);
        else
            eeg = eegSource;
        end
        
        % construct eeg metadata
        VN_source2bids_eegconfig;
        
        % read in the event stream (synched to the EEG stream)
        eegcfg.event = ft_read_event(cfg.dataset);
        
        % write eeg files in bids format
        data2bids(eegcfg, eeg);
              
    end
end

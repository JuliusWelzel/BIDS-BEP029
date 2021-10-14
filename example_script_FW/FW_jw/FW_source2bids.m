%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                     
%
%       Examaple script for converting .xdf recordings to BIDS 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Data: Free walking (Nadine Jacobsen, Neuropsychology, University of Oldenburg)
% Author: Julius Welzel (Neurogeriatrics, UKSH Kiel,University of Kiel)
% Version: 1.0 // setting up default (11.02.2021)

% clear workspace
clear all, close all, clc


%% initialze fieldtrip 
addpath('C:\Users\juliu\Documents\MATLAB\toolboxes\fieldtrip-20201023')
addpath('C:\Users\juliu\Documents\MATLAB\toolboxes\xdf-Matlab-master')
ft_defaults

% path to sourcedata 
sourceDataPath          = 'C:\Users\juliu\Desktop\BIDS_motion_nj\sourcedata\'; 
addpath(sourceDataPath)

% range of (effective) sampling rate of data, used for identifying streams
% in .xdf
motionSRateRange        = [30 100]; 
eegSRateRange           = [900 1100];

% funcions that resolve dataset-specific problems
motionCustom            = 'fw_bids_custom_motion'; 
        
% participants label used to read in the info files
participants            = { 'sub2'};                      
                       
% load general metadata that apply to all participants
FW_source2bids_generalconfig;

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

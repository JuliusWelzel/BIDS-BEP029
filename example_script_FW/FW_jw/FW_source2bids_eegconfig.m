% eeg specific information 
%--------------------------------------------------------------------------
% eeg configuration for data2bids
eegcfg                              = cfg;
eegcfg.datatype                     = 'eeg';
eegcfg.method                       = 'convert';

% full path to eloc file 
eegcfg.elec                         = [sourceDataPath '\'  subjectdata.subjectID '\' subjectdata.eloc];

% coordinate system
eegcfg.coordsystem.EEGCoordinateSystem      = 'todo';
eegcfg.coordsystem.EEGCoordinateUnits       = 'todo';

% read in impedances
%eegcfg.electrodes.impedance         = [sourceDataPath '\' subjectdata.impedance];

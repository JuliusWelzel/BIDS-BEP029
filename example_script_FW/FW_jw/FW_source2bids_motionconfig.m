% motion metadata
% copy general fields 
motioncfg       = cfg; 

% data type and acquisition label
motioncfg.datatype                                = 'motion';
motioncfg.acq                                     = 'Accelerometers';

% motion specific fields in json
motioncfg.motion.Manufacturer                     = 'Faros';
motioncfg.motion.ManufacturersModelName           = 'eMotion 180°';
motioncfg.motion.RecordingType                    = 'continuous'; 

% coordinate system
motioncfg.coordsystem.MotionCoordinateSystem      = 'FRU';
motioncfg.coordsystem.MotionRotationRule          = 'left-hand'; 
motioncfg.coordsystem.MotionRotationOrder         = 'XYZ'; 

% rename and fill out motion-specific fields to be used in channels_tsv
motioncfg.channels.name         = cell(motion.hdr.nChans,1); 
motioncfg.channels.object       = cell(motion.hdr.nChans,1); 
motioncfg.channels.component    = cell(motion.hdr.nChans,1); 
motioncfg.channels.object_anat  = cell(motion.hdr.nChans,1); 
motioncfg.channels.tsvfile      = cell(motion.hdr.nChans,1); 

for ci  = 1:motion.hdr.nChans
    
    if  contains(motion.hdr.chantype{ci},'position')
        motion.hdr.chantype{ci} = 'position'; 
    end
    
    if  contains(motion.hdr.chanunit{ci},'meter')
        motion.hdr.chanunit{ci} = 'virtual meters'; 
    end

    splitlabel                          = regexp(motion.hdr.label{ci}, '_', 'split');
    motioncfg.channels.name{ci}         = motion.hdr.label{ci};
    motioncfg.channels.object{ci}       = splitlabel{1};                    % REQUIRED. Label of the object that is being tracked, for example, label of a tracker or a marker.
    motioncfg.channels.component{ci}    = splitlabel{end};                  % REQUIRED. Component of the representational system that the channel contains.
    motioncfg.channels.object_anat{ci}  = 'X.X.X';                          % RECOMMENDED. Label of the object that is being tracked, for example, label of a tracker or a marker.
    motioncfg.channels.tsvfile{ci}      = 'sub-001_task-VirtualNavigation_acq-ViveTrackers_motion';                          % REQUIRED. Label of the object that is being tracked, for example, label of a tracker or a marker.
    
end


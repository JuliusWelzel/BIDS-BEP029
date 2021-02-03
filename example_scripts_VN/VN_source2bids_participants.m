% information needed to construct file paths and names 
cfg.sub                                     = subjectdata.subjectID_BIDS;
cfg.dataset                                 = datafiles{di};

if isfield(subjectdata,'sessions')
    cfg.ses                                 = subjectdata.sessions{di};
end

if isfield(subjectdata,'runs')
    if ~isnan(subjectdata.runs)
        cfg.run                             = subjectdata.runs{di};
    end
end

% participant information
cfg.participants.age                        = subjectdata.age;        
cfg.participants.sex                        = subjectdata.sex;
cfg.participants.handedness                 = subjectdata.handedness;
cfg.participants.rfpt                       = subjectdata.rfpt; 
cfg.participants.comments                   = subjectdata.comments;   
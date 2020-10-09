%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                       Visualize BIDS survey results
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% BEP 029
% Data: Google Survey (Sein Jeung, University of Berlin)
% Author: Julius Welzel, j.welzel@neurologie.uni-kiel.de

clc; clear all; close all;

MAIN = [fileparts(pwd) '\'];
addpath(genpath(MAIN));


%Change MatLab defaults
set(0,'defaultfigurecolor',[1 1 1]);
% Change default axes fonts.
set(0,'DefaultAxesFontName', 'Calibri')
% Change default text fonts.
set(0,'DefaultTextFontname', 'Calibri')

cc = parula(3);
cc2 = cool(2);
%% load data

PATHIN_data = [MAIN '01_data\'];

res = readtable([PATHIN_data,'BIDS-Motion .csv']);

%% type of recording

[cnt_space nms_space] = findgroups(res.InWhichTypeOfSpaceIsYourMotionDataRecorded_);
nms_space{2} = 'Both';

b1 = bar(histcounts(cnt_space),'FaceColor','flat');
b1.CData = cc
xticklabels (nms_space)
xtickangle(45)
box off
ylabel 'Total [N]'
title 'In which type of space is your motion data recorded?'

save_fig(gcf,PATHIN_data,'space_type')

%% per BI type

[cnt_type nms_type ] = findgroups(res.WhatTypeOfBrainImagingModalityDoYouRecordInConjunctionWithMotio);
spctyp = [];
for s = 1:numel(nms_space)
    
    spctyp(s,1) = sum(contains(res.WhatTypeOfBrainImagingModalityDoYouRecordInConjunctionWithMotio(cnt_space == s),'EEG'));
    spctyp(s,2) = sum(contains(res.WhatTypeOfBrainImagingModalityDoYouRecordInConjunctionWithMotio(cnt_space == s),'fMRI'));
    spctyp(s,3) = sum(contains(res.WhatTypeOfBrainImagingModalityDoYouRecordInConjunctionWithMotio(cnt_space == s),'fNIRS'));
    
    ccc(s,:,:) = cc;
end

nms_typs = {'EEG','fMRI','fNIRS'};
nms_spcs = {'PM','Both','VM'};
b2 = bar(spctyp','stacked','FaceColor','flat')
legend(nms_spcs)
legend boxoff
xticklabels (nms_typs)
xtickangle(45)
box off
ylabel 'Total [N]'

title 'Type per recording modality'

for i = 1:3
    b2(i).CData = cc(i,:);
end

save_fig(gcf,PATHIN_data,'space_per_mod')

%% naming per system


[cnt_sys nms_sys ] = findgroups(res.x_optional_InCaseYouUseMotionCapture_WhatTypeOfMotionCaptureSys);
[cnt_plc nms_plc ] = findgroups(res.x_optional_InCaseYouUseMotionCapture_HowDoYouDefinePlacementOfT);

idx_opt = contains(res.x_optional_InCaseYouUseMotionCapture_WhatTypeOfMotionCaptureSys,'marker','IgnoreCase',true)
idx_imu = contains(res.x_optional_InCaseYouUseMotionCapture_WhatTypeOfMotionCaptureSys,'IMU','IgnoreCase',true)

sysplc = [];
sysplc(1,1) = sum(contains(res.x_optional_InCaseYouUseMotionCapture_HowDoYouDefinePlacementOfT(idx_opt),'Anatomical'));
sysplc(1,2) = sum(contains(res.x_optional_InCaseYouUseMotionCapture_HowDoYouDefinePlacementOfT(idx_opt),'body'));
sysplc(1,3) = sum(contains(res.x_optional_InCaseYouUseMotionCapture_HowDoYouDefinePlacementOfT(idx_opt),'Custom'));
sysplc(1,4) = sum(contains(res.x_optional_InCaseYouUseMotionCapture_HowDoYouDefinePlacementOfT(idx_opt),'Predefined'));

sysplc(2,1) = sum(contains(res.x_optional_InCaseYouUseMotionCapture_HowDoYouDefinePlacementOfT(idx_imu),'Anatomical'));
sysplc(2,2) = sum(contains(res.x_optional_InCaseYouUseMotionCapture_HowDoYouDefinePlacementOfT(idx_imu),'body'));
sysplc(2,3) = sum(contains(res.x_optional_InCaseYouUseMotionCapture_HowDoYouDefinePlacementOfT(idx_imu),'Custom'));
sysplc(2,4) = sum(contains(res.x_optional_InCaseYouUseMotionCapture_HowDoYouDefinePlacementOfT(idx_imu),'Predefined'));

nms_sys = {'Optical','IMU'};
nms_plc = {'Anatomical','body','Custom','Predefined'};

b3 = bar(sysplc,'stacked','FaceColor','flat')
legend(nms_plc)
legend boxoff
xticklabels (nms_sys)
xtickangle(45)
box off
ylabel 'Total [N]'

title 'Placement per system'

cc2 = cool(4)
for i = 1:4
    b3(i).CData = cc2(i,:);
end

save_fig(gcf,PATHIN_data,'plc_per_sys')
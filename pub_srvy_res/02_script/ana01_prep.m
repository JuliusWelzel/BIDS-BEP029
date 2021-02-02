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

c_phy = [218 114 126] / 255;
c_bth = [172 108 130] / 255;
c_vm = [104 92 121] / 255;

cc = [c_phy;c_bth;c_vm];
%% load data

PATHIN_data = [MAIN '01_data\'];

res = readtable([PATHIN_data,'BIDS-Motion .csv']);

%% type of recording

[cnt_space nms_space] = findgroups(res.InWhichTypeOfSpaceIsYourMotionDataRecorded_);
nms_space{2} = 'Both';

b1 = bar(histcounts(cnt_space)/sum(histcounts(cnt_space))*100,'FaceColor','flat');
b1.CData = [c_phy;c_bth;c_vm];
xticklabels (nms_space)
xtickangle(45)
box off
ylabel 'Share of answers [%]'
title 'In which type of space is your motion data recorded?'

save_fig(gcf,PATHIN_data,'F1_space_type')

%% per BI type

[cnt_type nms_type ] = findgroups(res.WhatTypeOfBrainImagingModalityDoYouRecordInConjunctionWithMotio);
spctyp = [];
total_ = size(res,1)/100;
for s = 1:numel(nms_space)
    
    spctyp(s,1) = sum(contains(res.WhatTypeOfBrainImagingModalityDoYouRecordInConjunctionWithMotio(cnt_space == s),'EEG')) / total_;
    spctyp(s,2) = sum(contains(res.WhatTypeOfBrainImagingModalityDoYouRecordInConjunctionWithMotio(cnt_space == s),'fMRI'))/ total_;
    spctyp(s,3) = sum(contains(res.WhatTypeOfBrainImagingModalityDoYouRecordInConjunctionWithMotio(cnt_space == s),'fNIRS')) / total_;
    
    ccc(s,:,:) = cc;
end

nms_typs = {'EEG','fMRI','fNIRS'};
nms_spcs = {'Physical motion','Both','Virtual motion'};
b2 = bar(spctyp','stacked','FaceColor','flat')
legend (nms_spcs)
legend boxoff
xticklabels (nms_typs)
xtickangle(45)
box off
ylabel 'Share of answers [%]'

title 'Type of motion capture per recording modality'

for i = 1:3
    b2(i).CData = cc(i,:);
end

save_fig(gcf,PATHIN_data,'F2_space_per_mod')

%% naming per system


[cnt_sys nms_sys ] = findgroups(res.x_optional_InCaseYouUseMotionCapture_WhatTypeOfMotionCaptureSys);
[cnt_plc nms_plc ] = findgroups(res.x_optional_InCaseYouUseMotionCapture_HowDoYouDefinePlacementOfT);

idx_opt = contains(res.x_optional_InCaseYouUseMotionCapture_WhatTypeOfMotionCaptureSys,'marker','IgnoreCase',true);
idx_imu = contains(res.x_optional_InCaseYouUseMotionCapture_WhatTypeOfMotionCaptureSys,'IMU','IgnoreCase',true);

sysplc = [];
sysplc(1,1) = sum(contains(res.x_optional_InCaseYouUseMotionCapture_HowDoYouDefinePlacementOfT(idx_opt),'Anatomical landmarks'))/total_;
sysplc(1,2) = sum(contains(res.x_optional_InCaseYouUseMotionCapture_HowDoYouDefinePlacementOfT(idx_opt),'Image'))/total_;
sysplc(1,3) = sum(contains(res.x_optional_InCaseYouUseMotionCapture_HowDoYouDefinePlacementOfT(idx_opt),'Custom verbal description'))/total_;
sysplc(1,4) = sum(contains(res.x_optional_InCaseYouUseMotionCapture_HowDoYouDefinePlacementOfT(idx_opt),'Predefined'))/total_;

sysplc(2,1) = sum(contains(res.x_optional_InCaseYouUseMotionCapture_HowDoYouDefinePlacementOfT(idx_imu),'Anatomical landmarks'))/total_;
sysplc(2,2) = sum(contains(res.x_optional_InCaseYouUseMotionCapture_HowDoYouDefinePlacementOfT(idx_imu),'Image'))/total_;
sysplc(2,3) = sum(contains(res.x_optional_InCaseYouUseMotionCapture_HowDoYouDefinePlacementOfT(idx_imu),'Custom verbal description'))/total_;
sysplc(2,4) = sum(contains(res.x_optional_InCaseYouUseMotionCapture_HowDoYouDefinePlacementOfT(idx_imu),'Predefined placement system'))/total_;

nms_sys = {'Optical','IMU'};
nms_plc = {'Anatomical landmarks','Images','Custom verbal descriptions','Predefined placement system'};

b3 = bar(sysplc,'stacked','FaceColor','flat');
legend(nms_plc)
legend boxoff
xticklabels (nms_sys)
xtickangle(45)
box off
ylabel 'Share of answers [%]'

title 'Placement description of markers at participants body'

cc2 = [[7, 153, 146]; [56, 173, 169]; [130, 204, 221]; [60, 99, 130]]/ 255;
for i = 1:4
    b3(i).CData = cc2(i,:);
end

save_fig(gcf,PATHIN_data,'F3_plc_per_sys')
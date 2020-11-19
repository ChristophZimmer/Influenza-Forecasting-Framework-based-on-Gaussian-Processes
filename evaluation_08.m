%% Copyright (c) 2020 Robert Bosch GmbH
% All rights reserved.
% This source code is licensed under the AGPL-3.0 license found in the
% LICENSE file in the root directory of this source tree.
% @author: Christoph Zimmer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If 08.m has been executed, the first three blocks are not necessary. 
%% Load GPML
addpath( genpath('.'), genpath('./../SPI-Toolbox/')  )
if exist('gpml-matlab-master', 'dir')
    disp('Loading GPML');
    startup();
else
    error('Please get GPML');
end

%% Load ILI data and identify relevant columns 
if exist('ILINet-national.csv','file') == 2
    zw1 = dlmread('ILINet-national.csv');
    ILI_national = zw1(:,[2,3,4,5]);
else
    error('Please get national ILInet data, remove first two rows and replace column 1-2 by zeros');
end
if exist('ILINet-regional.csv','file') == 2
    zw1 = dlmread('ILINet-regional.csv');
    ILI_regional = zw1(:,[2,3,4,5]);
else
    error('Please get regional ILInet data, remove first two rows and replace column 1-2 by zeros');
end
ILI = [ ILI_national ; ILI_regional ];



%% Build seasons structure from the data
ILIseasons = [];
for reg = 0:10
    for year = 1997 : 2018
        choice1 = (ILI(:,1) == reg) .* (ILI(:,2) == year) .* (ILI(:,3) >= 40)==1;
        choice2 =     (ILI(:,1) == reg) .* (ILI(:,2) == year + 1) .* (ILI(:,3) <= 39)==1;
        block1 = zeros( sum(choice1) + sum(choice2), 5);
        block1(:,1) = year;
        block1(:,2:end) = [ ILI(  choice1 ,:) ; ILI( choice2 ,:)];
        ILIseasons = [ ILIseasons ; block1];
    end
end
 
        

%% Evaluation forecasting performance for GP framework
colist = dlmread('FeatureSel/bestGPfeatures.csv');
for ico = 1:length(colist)   % for each individual GP model
    folder = [ 'GP_pastweeks', num2str(colist(ico))] ;
    pastweeks =  dec2base( colist(ico), 10) - '0';
    aba = clock;
    disp( [ num2str( [ aba(4:5), round(aba(6))] ), '  pastweeks   ', num2str( pastweeks )] );
    logscoretable = [];
    logscoretable_all = [];
    seasons = [2012:1:2018];
    for reg = 0:0   % for each region (0 stands for US National)
        for iseason = 1:length(seasons)    % for each season
            season = seasons(iseason);
            weeknumbers0 = ILIseasons(   (ILIseasons(:,1) == season).*(ILIseasons(:,2)== reg ) == 1 ,4);
            weeknumbers = weeknumbers0(5:33);
            for iew = 1:length(weeknumbers)   % perform the predictions for all EW in a specific season
                ew = weeknumbers(iew);
                disp(['Region :', num2str(reg), '   Season: ',num2str(seasons(iseason)),',   week:',num2str(ew)]);
                logscoretable_all = [logscoretable_all ; logscore_file_all(ILIseasons,folder,season,reg,ew) ];
            end
        end
    end
    % output performance evaluation
    dlmwrite( [folder,'/', 'logscoretable_all.csv'] ,logscoretable_all,'delimiter','\t' );
end

%% Evaluation forecasting performance for GP ENSEMBLE
colist = dlmread('FeatureSel/bestGPfeatures.csv');
folder1 = [ 'GP_pastweeks', num2str(colist(1))] ;
folder2 = [ 'GP_pastweeks', num2str(colist(2))] ;
folder3 = [ 'GP_pastweeks', num2str(colist(3))] ;
logscoretable = [];
logscoretable_all = [];
seasons = [2012:1:2018];
if ~exist('ensembles', 'dir')
    mkdir('ensembles')
end
for reg = 0:0   % for each region (0 stands for US National)
    for iseason = 1:length(seasons)   % for each season
       season = seasons(iseason);
       weeknumbers0 = ILIseasons(   (ILIseasons(:,1) == season).*(ILIseasons(:,2)== reg ) == 1 ,4);
       weeknumbers = weeknumbers0(5:33);
       for iew = 1:length(weeknumbers)   % perform the predictions for all EW in a specific season
            ew = weeknumbers(iew);
            disp(['Region :', num2str(reg), '   Season: ',num2str(seasons(iseason)),',   week:',num2str(ew)]);
            logscoretable_all = [logscoretable_all ; logscore_file_all_ensemble(ILIseasons,folder1,folder2,folder3,season,reg,ew) ];
        end
    end
end
% output ensemble performance
dlmwrite( ['ensembles/', 'logscoretable_GP.csv'] ,logscoretable_all,'delimiter','\t' );

 
   
    
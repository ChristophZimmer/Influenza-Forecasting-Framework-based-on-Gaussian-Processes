%% Copyright (c) 2020 Robert Bosch GmbH
% All rights reserved.
% This source code is licensed under the AGPL-3.0 license found in the
% LICENSE file in the root directory of this source tree.
% @author: Christoph Zimmer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Load GPML
%addpath( genpath('.'), genpath('./../SPI-Toolbox/')  )
addpath( genpath('.')   )
if exist('gpml-matlab-master', 'dir')
    disp('Loading GPML');
    startup();
else
    error('Please get GPML');
end


%% Load ILI data and identify relevant columns 
if exist('ILINet-national.csv', 'file') == 2   
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
    for year = 1997 : 2019
        choice1 = (ILI(:,1) == reg) .* (ILI(:,2) == year) .* (ILI(:,3) >= 40)==1;
        choice2 =     (ILI(:,1) == reg) .* (ILI(:,2) == year + 1) .* (ILI(:,3) <= 39)==1;
        block1 = zeros( sum(choice1) + sum(choice2), 5);
        block1(:,1) = year;
        block1(:,2:end) = [ ILI(  choice1 ,:) ; ILI( choice2 ,:)];
        ILIseasons = [ ILIseasons ; block1];
    end
end



%% GP forecasting  %%%%%%%%%%%%%%%%%%%%%%%%%%%
colist = dlmread('FeatureSel/bestGPfeatures.csv');
for ico = 1:length(colist)  % for each individual model
    folder = [ 'GP_pastweeks', num2str(colist(ico))] ;
    pastweeks =  dec2base( colist(ico), 10) - '0';
    aba = clock;
    disp( [ num2str( [ aba(4:5), round(aba(6))] ), '  pastweeks   ', num2str( pastweeks )] );
    if ~exist(folder, 'dir')
        mkdir(folder)
    end
    for reg = 0 :0   % for each region under consideration (0 means US National)
        seasons = [2012:1:2018];
        for iseason = 1:length(seasons)    % for each season 
            season = seasons(iseason);
            weeknumbers0 = ILIseasons(   (ILIseasons(:,1) == season).*(ILIseasons(:,2)== reg) == 1 ,4);
            weeknumbers = weeknumbers0(5:34);
            for iew = 1 :length(weeknumbers)   % perform the predictions for all EW in a specific season
                ew = weeknumbers(iew);
                disp(['Region ', num2str(reg), 'Season: ',num2str(season),'  EW: ',num2str(ew)]);
                hist = zeros(4,131);  %%% part for 1-4 week predictions
                pointpred = zeros(4,1);
                for weekahead = 1 : 4   % perform the 4 predictions for a specific EW in a specific season
                    disp('   weekahead');
                    [mu,var] = predict_level( ILIseasons, reg, season, ew, pastweeks, weekahead);
                    sig = sqrt(var);
                    hist(weekahead,:) = create_histogram(weekahead+3,mu,sig);
                    pointpred(weekahead) = mu;
                end
                hist2 = zeros(3,131);  %%% part for other targets 
                pointpred2 = zeros(3,1);
                % output forecasts
                name2 = [ folder,'/',num2str(season),'-ew',num2str(ew),'_alltargets-reg',num2str(reg),'.csv'];
                write_forecast_file_alltargets(pointpred,pointpred2,hist,hist2,name2,weeknumbers,reg);
            end
        end
    end 
end
 
% Copyright (c) 2020 Robert Bosch GmbH
% All rights reserved.
% This source code is licensed under the AGPL-3.0 license found in the
% LICENSE file in the root directory of this source tree.
% @author: Christoph Zimmer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath( genpath('.')   )
%addpath( genpath('.'), genpath('./../SPI-Toolbox/')  )
scoreGPens = dlmread(  'ensembles/logscoretable_GP.csv' );

 

%% Prediction interval plots for 1 approach   ALL years and targets
plot_alltargets(scoreGPens,0 , 'GPens' )

%% Prediction interval plots for main text
fig = figure('position', [50, 50, 1000+50, 400+50] ) ;
subplot(2,2,1)
pred_interval_year_tar(scoreGPens ,0, 2012, 1)
text( 20,8,'2012/13','FontSize',16); ylabel({ 'ILI'}); title('1 week');
subplot(2,2,2)
pred_interval_year_tar(scoreGPens ,0, 2012, 3)
text( 20,8,'2012/13','FontSize',16); ylabel({ 'ILI'}); title('3 week');
subplot(2,2,3)
pred_interval_year_tar(scoreGPens ,0, 2018, 1)
text( 20,8,'2018/19','FontSize',16); ylabel({  'ILI'}); subplot(2,2,4)
pred_interval_year_tar(scoreGPens ,0, 2018, 3)
text( 20,8,'2018/19','FontSize',16); ylabel({ 'ILI'})


%% Coverage plot 
plot_coverage_one(scoreGPens,[2012:2018],'GPens')
 

  
 
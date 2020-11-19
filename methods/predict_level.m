% Copyright (c) 2020 Robert Bosch GmbH
% All rights reserved.
% This source code is licensed under the AGPL-3.0 license found in the
% LICENSE file in the root directory of this source tree.
% @author: Christoph Zimmer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mu,sig] = predict_level( ILIseasons, reg, season, ew, pastweeks, weekahead)
%%% Set up training data for specific EW and weekahead
trainx = [];
trainy = [];
for yeart = 1997:2007
    weeknumber = find( ILIseasons( (ILIseasons(:,1) == season).*(ILIseasons(:,2)==reg) == 1 ,4) == ew);  % relative weeknumber for prediction season
    zw1 = ILIseasons( (ILIseasons(:,1) == yeart).*(ILIseasons(:,2)==reg) == 1 ,:);
    zw2 = weeknumber; % relative week since EW40
    zw3 = zw1( 1:zw2,end)' ;
    zw4 = zw3( end + 1 - pastweeks );
    trainx = [trainx ; zw4];
    trainy = [trainy ; zw1( zw2 + weekahead,end) ];
end
for yeart = 2010:season-1
    weeknumber = find( ILIseasons( (ILIseasons(:,1) == season).*(ILIseasons(:,2)==reg) == 1 ,4) == ew);  % relative weeknumber for prediction season
    zw1 = ILIseasons( (ILIseasons(:,1) == yeart).*(ILIseasons(:,2)==reg) == 1 ,:);
    zw2 = weeknumber; % relative week since EW40
    zw3 = zw1( 1:zw2,end)' ;
    zw4 = zw3( end + 1 - pastweeks );
    trainx = [trainx ; zw4];
    trainy = [trainy ; zw1( zw2 + weekahead,end) ];
end  
%
%%% Train GP based on this training data
meanfunc = [];                    % empty: don't use a mean function
covfunc = @covSEiso;              % Squared Exponental covariance function
likfunc = @likGauss;              % Gaussian likelihood
hyp = struct('mean', [], 'cov', [0 0], 'lik', -1);
hyp2 = minimize2(hyp, @gp, -100, @infGaussLik, meanfunc, covfunc, likfunc, trainx, trainy);
%
%%% Predict for specific year, reg, ew based on this GP
zw1 = ILIseasons( (ILIseasons(:,1) == season).*(ILIseasons(:,2)==reg) == 1 ,:);
zw2 = find( zw1(:,4) == ew);
zw3 = zw1( 1:zw2,end)' ;
predx = zw3( end + 1 - pastweeks );
[mu, sig] = gp(hyp2, @infGaussLik, meanfunc, covfunc, likfunc, trainx, trainy, predx);
end
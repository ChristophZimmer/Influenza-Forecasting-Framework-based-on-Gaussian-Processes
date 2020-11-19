% Copyright (c) 2020 Robert Bosch GmbH
% All rights reserved.
% This source code is licensed under the AGPL-3.0 license found in the
% LICENSE file in the root directory of this source tree.
% @author: Christoph Zimmer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = logscore_file_all(ILIseasons,folder,season,reg,ew)
name = [ folder,'/',num2str(season),'-ew',num2str(ew),'_alltargets-reg',num2str(reg),'.csv'];
csvtable = readtable(name); 
regionlist = {'US National', 'HHS Region 1', 'HHS Region 2', 'HHS Region 3', 'HHS Region 4', 'HHS Region 5', 'HHS Region 6', 'HHS Region 7', 'HHS Region 8', 'HHS Region 9', 'HHS Region 10'};
targetlist = {'Season onset','Season peak week','Season peak percentage','1 wk ahead','2 wk ahead','3 wk ahead','4 wk ahead'};
BASELINE = [ 2.2, 1.8, 3.1, 2.0, 2.2, 1.8, 4.0, 1.6, 2.2, 2.3, 1.1];
%%%%%% ground truth  1-4 weeks 
ilipos = (ILIseasons(:,2)==reg).*(ILIseasons(:,1)==season)==1;
zw2 = ILIseasons( ilipos,:);
pos = find( zw2(:,4) == ew);
groundtruth = zw2(pos+1:pos+4,end);
%%%%%  logscore  + pointpreds    1-4 weeks 
logscore=zeros(1,4);
pointpreds = zeros(1,4);
quants = zeros(2,4);
for itar = 1:4
    zw1 = csvtable(  strcmp(  table2array(csvtable(:,2)) , targetlist(itar+3)) == 1  ,:);
    zw2 = zw1(2:end,:);
    gtr = groundtruth(itar);
    low = find( [ 0:0.1:13 ,100] > gtr,1 ) - 6; 
    up =  find( [ 0:0.1:13 ,100] > gtr,1 ) + 4;
    zw3 = zw2(low:up,:);
    logscore(itar) = max(-10,  log( sum( table2array( zw3(:,end) ) ) )   );
    pointpreds(itar) = table2array( zw1(1,end) );
    % quantiles
    zw4 = table2array(zw2(:,end))';
    qlow = find( cumsum(zw4) <= 0.05 ) + 1; % +1 as still no mass in this interval ;  
    if isempty(qlow)
        qlow = 1;
    end
    qup =  find( cumsum(zw4) >= 0.95)  +1; % +1 as mass no earlier than this interval, that's why end is needed
    zw6 = [ 0:0.1:13 ,100];
    quants(:,itar) = zw6([qlow(end),qup(1)])';      
end

y = [ 
    [season, reg, ew, -2, zeros(1,5)];
    [season, reg, ew, -1,zeros(1,5)];
    [season, reg, ew, 0, zeros(1,5)];
    season, reg, ew , 1 , quants(1,1), groundtruth(1), pointpreds(1), quants(2,1), logscore(1) ;
    season, reg, ew , 2 , quants(1,2), groundtruth(2), pointpreds(2), quants(2,2), logscore(2) ;
    season, reg, ew , 3 , quants(1,3), groundtruth(3), pointpreds(3), quants(2,3), logscore(3) ;
    season, reg, ew , 4 , quants(1,4), groundtruth(4), pointpreds(4), quants(2,4), logscore(4) ;
];
end
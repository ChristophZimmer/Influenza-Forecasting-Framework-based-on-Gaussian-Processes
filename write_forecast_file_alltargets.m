% Copyright (c) 2020 Robert Bosch GmbH
% All rights reserved.
% This source code is licensed under the AGPL-3.0 license found in the
% LICENSE file in the root directory of this source tree.
% @author: Christoph Zimmer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = write_forecast_file_alltargets(pointpred,pointpred2,hist,hist2,name,weeknumbers,reg)
if isempty(find(weeknumbers==53))
    weeknumbers2= weeknumbers(1:end-1);
    if exist('template_all_52.csv', 'file') == 2
        abc = readtable('template_all_52.csv');
    else
        error('Please get template for 52 week years from predict.cdc.gov');
    end    
else
    if exist('template_all_53.csv', 'file') == 2
        abc = readtable('template_all_53.csv');
    else
        error('Please add one line for 53 week after line 15 and line 50 in 52 week template and save as 53 week template.');
    end  
    weeknumbers2 = weeknumbers;
end
reglist = { 'US National', 'HHS Region 1',  'HHS Region 2',  'HHS Region 3',  'HHS Region 4',  'HHS Region 5',  'HHS Region 6',  'HHS Region 7',  'HHS Region 8',  'HHS Region 9',  'HHS Region 10'};
abc(:,1) = reglist(reg+1);
le = length(weeknumbers2) + 3;
%
abc(1,end) = num2cell( pointpred2(1) );
abc(2:2+le+1,end) = num2cell( hist2(1,1:1+le+1)' );
%
abc(2+le+2,end) = num2cell( pointpred2(2) );
abc(2+le+3 : 2 + le + 3 + le ,end) = num2cell( hist2(2,1:1+le)' );
%
abc(2+2 * le + 4 ,end) = num2cell(pointpred2(3));
abc(2+2 * le + 5 : 2+2*le+135,end) = num2cell( hist2(3,:)');
%%%
abc(2+2*le+136,end) = num2cell( pointpred(1) );
abc(2+2*le+137 :2+2*le+137 + 130,end) =  num2cell( hist(1,:)' );
abc(2+2*le+268,end) = num2cell( pointpred(2) );
abc(2+2*le+269 :2+2*le+269 + 130,end) =  num2cell( hist(2,:)' );
abc(2+2*le+400,end) = num2cell( pointpred(3) );
abc(2+2*le+401 : 2+2*le+401 + 130,end) =  num2cell( hist(3,:)' );
abc(2+2*le+532,end) = num2cell( pointpred(4) );
abc(2+2*le+533 : 2+2*le+533 + 130,end) =  num2cell( hist(4,:)' );
%
writetable(abc,name);
end
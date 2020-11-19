%% Copyright (c) 2020 Robert Bosch GmbH
% All rights reserved.
% This source code is licensed under the AGPL-3.0 license found in the
% LICENSE file in the root directory of this source tree.
% @author: Christoph Zimmer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = create_histogram(target,mean,stddev,weeknumbers)
if ( 3 <= target ) && (target <= 7)
    probcorr = (1-normcdf(0,mean,stddev))^-1;
    intervals = 0:0.1:13;
    zw1 = normcdf( intervals,mean,stddev);
    hist = [ zw1(2:end)-zw1(1:end-1) , 1-normcdf( 13,mean,stddev) ];
    y = hist .* probcorr;
elseif target == 2 
    if isempty(find(weeknumbers==53))
        weeknumbers2 = weeknumbers(1:end-1);
    else
        weeknumbers2 = weeknumbers;
    end
    probcorr = (1- ( normcdf(0.5,mean,stddev)+ 1 - normcdf(length(weeknumbers2) + 0.5,mean,stddev) ) )^-1;
    intervals = 0.5:1:length(weeknumbers2) + 0.5;
    zw1 = normcdf( intervals, mean, stddev);
    hist = [ zw1(2:end)-zw1(1:end-1)  ];
    y = hist.* probcorr;
end
end
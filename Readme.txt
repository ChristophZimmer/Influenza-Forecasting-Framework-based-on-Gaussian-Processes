% Copyright (c) 2020 Robert Bosch GmbH
% All rights reserved.
% This source code is licensed under the AGPL-3.0 license found in the
% LICENSE file in the root directory of this source tree.
% @author: Christoph Zimmer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Influenza Forecasting Framework based on Gaussian Processes
This is the companion code for the algorithm reported in the paper
 "Influenza Forecasting Framework based on Gaussian Processes".
The paper can be found here https://proceedings.icml.cc/static/paper_files/icml/2020/1239-Paper.pdf
The code is only thought for reproducing results of the paper and for no other purpose. Please cite the above paper when reporting, reproducing or 
extending the results.



Purpose of the project

This software is a research prototype, solely developed for and published as part of the 
publication cited above. It will neither be maintained nor monitored in any way.



Requirements, how to build, test, install, use, etc.

The code is not stand alone. It needs a Gaussian Process module (e.g. GPML [1]) in addition, the ILInet data from CDC [2] for national as ILINet-national.csv
 and regional level (as ILINet-regional.csv) as well as the forecasting template from [3]. Then, the code can reproduce the results of the above 
cited paper by executing first the file main_08.m, then evlaution_08.m and finally plot_09.m. 

[1] http://www.gaussianprocess.org/gpml/code/matlab/doc/
[2] https://gis.cdc.gov/grasp/fluview/fluportaldashboard.html
[3] https://predict.cdc.gov/post/5d8257befba2091084d47b4c



License

This code is open-sourced under the AGPL-3.0 license. See the
LICENSE file for details.


 


 
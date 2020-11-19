% Copyright (c) 2020 Robert Bosch GmbH
% All rights reserved.
% This source code is licensed under the AGPL-3.0 license found in the
% LICENSE file in the root directory of this source tree.
% @author: Christoph Zimmer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_alltargets(logscoretable_all ,reg ,name  )
%%%%%%  Create plots for ALL targets
fig1 = figure('position', [50, 50, 1200, 950] ) ;
for plyear = 2012:2018
    for pltarget = 1:4
        subplot(7,4,(plyear-2012)*4+ ( pltarget  ))
        pred_interval_year_tar_all(logscoretable_all ,reg, plyear, pltarget)
        text( 18,8,[num2str(plyear),'/',num2str(plyear+1)],'FontSize',10); ylabel({ 'ILI'});  
        targetnamelist = {'Peak intensity', '1 week', '2 week', '3 week', '4 week'};
        if pltarget == 1
            ylabel(   'ILI' )
        end
        if plyear == 2012
            title(targetnamelist(pltarget+1));
        end
    end
end

end

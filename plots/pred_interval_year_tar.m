% Copyright (c) 2020 Robert Bosch GmbH
% All rights reserved.
% This source code is licensed under the AGPL-3.0 license found in the
% LICENSE file in the root directory of this source tree.
% @author: Christoph Zimmer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pred_interval_year_tar(logscoretable_all ,reg, plyear, pltarget)
zw1 = logscoretable_all( (logscoretable_all(:,1)== plyear).*(logscoretable_all(:,4)==pltarget).*(logscoretable_all(:,2)==reg) == 1,[3,5,6,7,8]);
h=fill( [ 1:length(zw1) , fliplr(1:length(zw1))],  [ zw1(:,2)', fliplr(zw1(:,5)') ],'g');
hold on
plot( zw1(:,3),'rx')
plot(zw1(:,4),'b')
set(gca,'xtick',1:3, 'xticklabel',{'','',''},'FontSize',16) 
xticks(1 :3: length(zw1));
xticklabels({ zw1(1:3:end,1)});
xlabel('Epidemic Week','FontSize',16);
h.FaceColor = [0.7,.7,1];
h.EdgeColor = [0.7,.7,1];
ylim([0,10])
yticks(0 :2: 10);
grid on
end

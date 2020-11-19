% Copyright (c) 2020 Robert Bosch GmbH
% All rights reserved.
% This source code is licensed under the AGPL-3.0 license found in the
% LICENSE file in the root directory of this source tree.
% @author: Christoph Zimmer 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_coverage_one(table1,seasons,name)
weeknumbers = [ 44    45    46    47    48    49    50    51    52     1     2     3     4     5     6     7     8     9    10    11    12    13    14    15    16    17    18    19    20 ]';
coverage_table = [];
for pltarget = 1:4
    line = [];
    for iweek=1:length(weeknumbers)-1
        zw1 = table1( (table1(:,4)== pltarget ).*(table1(:,2)==0).*(table1(:,3)==weeknumbers(iweek)) == 1,[3,4,5,6,8]);
        if pltarget < 0
            for ii = 1:6
                wknum = [[40:43]';table1( (table1(:,1)== seasons(ii) ).*(table1(:,4)==0) == 1,3)];
                for jj = 3:5
                    if zw1(ii,jj) > 0
                        zw1(ii,jj) = find(wknum == zw1(ii,jj));
                    else
                    end
                end
            end
        else
        end
        zw2 = (zw1(:,3) <= zw1(:,4)).*(zw1(:,4)<= zw1(:,5));
        line = [ line , sum(zw2)/length(zw2) ];
    end
    coverage_table = [ coverage_table ; line ];
end

quants = binoinv([0.005 0.995],size(zw1,1),0.95);
si = size(coverage_table,2);
fig1 = figure('position', [50, 50, 500+50, 800+50] ) ;
for i=1:4
    subplot(4,1,i)
    hold on
    h=fill( [ 0:si+2 , fliplr(0:si+2)],  [ repmat(quants(1),1,si+3)  , fliplr( repmat(quants(2),1,si+3) ) ]/size(zw1,1),'g');
    ylim([0,1])
    grid on
    si = size(coverage_table,2);
    plot( coverage_table(i,:),'k')
    h.FaceColor = [0.7,1,0.7];
    h.EdgeColor = [0.7,1,0.7];
    set(gca,'xtick',1:3, 'xticklabel',{'','',''},'FontSize',16) 
    xticks(1 :3: length(weeknumbers));
    xticklabels({ weeknumbers(1:3:end,1)});
    text(25,0.25, [ num2str(i),' week'])
    ylabel('Coverage')
    xlabel('Epidemic Week')
end

 

if name == 'GPens'
    fig1 = figure;
    iset = [1,3];
    for i= 1:2
        subplot(2,1,i)
        ii = iset(i);
        hold on
        h=fill( [ 0:si+2 , fliplr(0:si+2)],  [ repmat(quants(1),1,si+3)  , fliplr( repmat(quants(2),1,si+3) ) ]/size(zw1,1),'g');
        ylim([0,1])
        grid on
        si = size(coverage_table,2);
        plot( coverage_table(ii,:),'k')
        h.FaceColor = [0.7,1,0.7];
        h.EdgeColor = [0.7,1,0.7];
        set(gca,'xtick',1:3, 'xticklabel',{'','',''},'FontSize',16) 
        xticks(1 :3: length(weeknumbers));
        xticklabels({ weeknumbers(1:3:end,1)});
        text(25,0.25, [ num2str(ii),' week'])
        ylabel('Coverage')
        xlabel('Epidemic Week')
    end
end
        
 

 

end
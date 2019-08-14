% Plotting Hurricane Tracks using axesm and plotm
load coast
axesm('mercator','MapLonLimit',[-120 -60],'MapLatLimit',[0 35])
plotm(lat,long)
plotm(lat_track, lon_track,'color','r')
legend('Coastline', 'Storm Track')
title('Hurricane Ivan 2004 Track')
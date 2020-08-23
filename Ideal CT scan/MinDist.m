
% Read data from Excel File.
PositionReal = xlsread('SphereDB.xlsx');
PositionMuskanTemp = xlsread('output.xls')/1000;
PositionMuskan(:,1) = PositionMuskanTemp(:,2);
PositionMuskan(:,2) = PositionMuskanTemp(:,1);
PositionMuskan(:,3) = PositionMuskanTemp(:,3);
Distance = 1000*ones(size(PositionReal,1),1);

% Cycle through the real particle matrix. We assume that the correct 
% distance corresponds to the shortest distance
for i = 1:size(PositionReal,1)
    % Cycle through Muskan's matrix
    for j = 1:size(PositionMuskan,1)
        TempDistance = sqrt((PositionMuskan(j,1)-PositionReal(i,1))^2+...
            (PositionMuskan(j,2)-PositionReal(i,2))^2+...
            (PositionMuskan(j,3)-PositionReal(i,3))^2);
        if TempDistance < Distance(i)
            Distance(i) = TempDistance;
        end
    end

end

DistancePixel = Distance * 1000;



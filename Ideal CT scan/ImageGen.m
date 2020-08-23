

% Read data from Excel File.
Position = xlsread('SphereDB.xlsx');

% Create pixel coordinates by assuming that 0.1 mm (one diameter) = 100
% pixels.
Scale = 1000;
Position = Position*Scale;
Distance = zeros(size(Position,1),1);
MatTemp = zeros(round(0.4*Scale),round(0.4*Scale));

% Create one section every 50 pixels along the height, 12 in total.
for i = 1:20
    % Scan each pixel of the image to decide if it is inside a particle
    % 0 is black, 1 is white. White corresponds to particles
    for j = 1:round(0.4*Scale)
        for k = 1:round(0.4*Scale)
            % Distance is a vector containing the distance between the center
            % of each particle and the current pixel.
            Distance = sqrt((Position(:,1)-j).^2+(Position(:,2)-k).^2+(Position(:,3)-i*50).^2);
            if any(Distance<=Scale*0.05)
                MatTemp(j,k) = 1;
            else
                MatTemp(j,k) = 0;
            end
        end
    end
    % Save as tiff
    ImageTemp = mat2gray(MatTemp); %Convert to greyscale image
    imshow(ImageTemp) % Show image
    imwrite(ImageTemp,sprintf('img%i.tif',i))% Save image as tiff with proper name
    
end




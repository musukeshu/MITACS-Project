clc
clear
dbstop if error

% reading the image and converting it to black and white for processing
img=zeros(400,400,20);
for i=1:20
img(:,:,i)=imread(sprintf('img%d.tif',i));
img(:,:,i)=imbinarize(img(:,:,i));
end

% This is to convert the image to logical form for imfindcircles
l=logical(mod(img,2));

% Building a list of circles
for z = 1:20
    % Find the circles and put centre, radii and z coordinates in matrix
    [centre, radius]=imfindcircles(reshape(l(:,:,z),[400 400]),[5 51]); % Why do you have to reshape?
    if z==1 % initialize circleList variable for first iteration
        circleList = [centre radius 50*z*ones(size(centre,1),1)];
    else
        circleList = [circleList;
                      centre radius 50*z*ones(size(centre,1),1)];        
    end
end

% We take each circle one at a time
found = zeros(size(circleList,1), 1);
for i = 1:size(circleList,1)
    if found(i)==1 % If this circle is associated to a particle that has already been found, move on to the next circle.
        continue
    else
        j = 1;
        while found(i)==0 && j<= size(circleList,1)
            % Is the other circle located 50 pixels away in the z direction?
            if abs(circleList(i,4)-circleList(j,4))==50
                % Are their center superposed in the x-y plane?
                if ((circleList(i,1)-circleList(j,1))^2+(circleList(i,2)-circleList(j,2))^2)<4^2
                    % Are their radii consistent
                    if  abs(sqrt(50^2-circleList(i,3)^2)+sqrt(50^2-circleList(j,3)^2)-50)<10
                        found(j)=1; % Both circles are identified as found
                        found(i)=1;
                        
                        % The centre is added in the centre list. We use
                        % the mean of the two center coordinates
                        % The z coordinate is also based on the mean value
                        % from both circles.
                        % First circle : variable does not exist
                        if exist('particleList')==1 
                            particleList = [particleList;
                                zeros(1,3)];
                        else
                            particleList = zeros(1,3);
                        end

                        
                        particleList(end,1) = (circleList(i,1)+circleList(i,1))/2;
                        particleList(end,2) = (circleList(i,2)+circleList(i,2))/2;
                        if circleList(i,4)>circleList(j,4)
                            particleList(end,3)=circleList(i,4)-(sqrt(50^2-circleList(i,3)^2)+(50-sqrt(50^2-circleList(j,3)^2)))/2;
                        else
                            particleList(end,3)=circleList(j,4)-(sqrt(50^2-circleList(j,3)^2)+(50-sqrt(50^2-circleList(i,3)^2)))/2;
                    
                        end
                    end
                end
                
            end
            j=j+1;
        end
        % If there is no such circle, the circle is assumed to be centred
        if found(i)==0
            if exist('particleList')==1 
                particleList = [particleList;
                                    zeros(1,3)];
            else
                particleList = zeros(1,3);
            end
            particleList(end,1) = circleList(i,1);
            particleList(end,2) = circleList(i,2);
            particleList(end,3) = circleList(i,4);
            found(i)=1;
        end
    end

    
end

    
% 
% Position(:,1) = particleList(:,2);
% Position(:,2) = particleList(:,1);
% Position(:,3) = particleList(:,3);
% 
% % Already in Pixel coordinate
% Scale = 1000;
% Distance = zeros(size(Position,1),1);
% MatTemp = zeros(round(0.4*Scale),round(0.4*Scale));
% 
% % Create one section every 50 pixels along the height, 12 in total.
% for i = 1:20
%     % Scan each pixel of the image to decide if it is inside a particle
%     % 0 is black, 1 is white. White corresponds to particles
%     for j = 1:round(0.4*Scale)
%         for k = 1:round(0.4*Scale)
%             % Distance is a vector containing the distance between the center
%             % of each particle and the current pixel.
%             Distance = sqrt((Position(:,1)-j).^2+(Position(:,2)-k).^2+(Position(:,3)-i*50).^2);
%             if any(Distance<=50)
%                 MatTemp(j,k) = 1;
%             else
%                 MatTemp(j,k) = 0;
%             end
%         end
%     end
%     % Save as tiff
%     ImageTemp = mat2gray(MatTemp); %Convert to greyscale image
%     imshow(ImageTemp) % Show image
%     imwrite(ImageTemp,sprintf('New_img%i.tif',i))% Save image as tiff with proper name
    
% end
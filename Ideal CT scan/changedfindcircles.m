clc
clear

% reading the image and converting it to black and white for processing
img=zeros(400,400,20);
for i=1:20
img(:,:,i)=imread(sprintf('img%d.tif',i));
img(:,:,i)=imbinarize(img(:,:,i));
end

% This is to convert the image to logical form for imfindcircles
l=logical(mod(img,2));


cen=zeros(100,3,20);
R=50;
x=0;
for z=1:16
    %Finding centre and radii for first image
    i1=l(:,:,z);
    im1=reshape(i1,[400 400]);
    [centre1, radii1]=imfindcircles(im1,[10 50]);
    cen(1:size(centre1,1),1:2,z)=centre1;
     radii1=round(radii1);
    centre1=round(centre1);
    
    %Finding centre and radii for second image
    i2=l(:,:,z+1);
    im2=reshape(i2,[400 400]);
    [centre2, radii2]=imfindcircles(im2,[10 50]);
     radii2=round(radii2);
    centre2=round(centre2);
    
    % This is done to use the second image as first in the next iteration
    if(z==1)
        c1=centre1;
        c1(:,3)=0;
    else
        c1=c2temp;
        c1(:,3)=0;
    end
    c2=centre2;
    
    %% This is used if the sphere is sliced exactly in the middle(older version)
%     for i=1:size(centre1,1)
%         if(c1(i,1:2)==0)
%             continue;
%         else
%                 if((radii1(i,1)==R || radii1(i,1)==R-1 || radii1(i,1)==R+1))
%                     c1(i,1:2)=0;
%                     c1(i,3)=x+50;
%                 end
%         end
%     end
    
    %% This is used if sphere is sliced from any other position
for i=1:size(centre1,1)
    if(c1(i,1:2)==0)
        continue;
    end
   for j=1:size(centre2,1)
        if((c1(i,1)==c2(j,1) ||c1(i,1)==c2(j,1)+1 || c1(i,1)==c2(j,1)-1) && (c1(i,2)==c2(j,2) ||c1(i,2)==c2(j,2)+1 || c1(i,2)==c2(j,2)-1) )
            c1(i,3)=sqrt(R*R - radii1(i,1)*radii1(i,1));
            c1(i,3)=c1(i,3)+x+50;
            c1(i,1:2)=0;
            c2(j,1:2)=0;
            break;
        end
    end
end

for i=1:size(centre1,1)
    if(c1(i,1:2)==0)
        continue;
    else
        %% This part is a consideration that the circle still exist in second image(Method 1),
        % but it covers such a smaller area that it is not visible to us.
%             c1(i,3)=sqrt(R*R - radii1(i,1)*radii1(i,1));
%             c1(i,3)=x+50+c1(i,3);
%             c1(i,1:2)=0;
            
       %% This is the second method, instead of first one(Method 2).
       %%In this it is assumed that if the sphere is in one image only,
       %%lets use it as it is.
            c1(i,3)=x+radii1(i,1);
            c1(i,1:2)=0;
    end
end


cen(1:size(centre1,1),3,z)=c1(:,3);
if(c2>=0)       % This condition is used for the sake of last image only
c2temp=c2(:,1:2);
end
x=x+50;
end


% This is used just to generate results in proper format
finalcentre=zeros(100,3);
k=1;
for i=1:16
        for j=1:100
            if(cen(j,:,i)~=0)
                finalcentre(k,:)=cen(j,:,i);
                k=k+1;
            end
        end
end
 
% saving resuts as excel sheet
xlswrite('output.xls',finalcentre);

               
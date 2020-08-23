im = imread('img1.tif');
BW = im2bw(im);
dim = size(BW);
col = round(dim(2)/2)-90;
row = find(BW(:,col), 1 );

boundary = bwtraceboundary(BW,[row, col],'N');
imshow(im)
hold on;
plot(boundary(:,2),boundary(:,1),'g','LineWidth',3);
BW_filled = imfill(BW,'holes');
boundaries = bwboundaries(BW_filled);
for k=1:9
   b = boundaries{k};
   plot(b(:,2),b(:,1),'r','LineWidth',2);
end
close all;
clear all;
clc

%read image
im_IN = imread('coins.png');

%threshold value
valor_thresh = graythresh(im_IN);

%applying segmentation by threshold
im_BW = im2bw(im_IN, valor_thresh);

%fill the white holes in the image
Im_BW_fill_holes = imfill(im_BW,'holes');

%identify all objects in the image
Objects = bwconncomp(Im_BW_fill_holes, 8);

%find properties of the image (BoundingBox, Centroid)
prop_objectos=regionprops(Objects,'BoundingBox','Centroid');

figure, imshow(im_IN);%print the image
hold on

for i=1:Objects.NumObjects %for every object in the image
    Im_Obj_Area_AUX = false(size(Im_BW_fill_holes));
    Im_Obj_Area_AUX(Objects.PixelIdxList{i})=true;
    boundaries = bwboundaries(Im_Obj_Area_AUX);
    
    b = boundaries{1};
    
    %draw the perimeter in red
    plot(b(:,2),b(:,1),'r--','LineWidth',2);
    
    %label every object in green
    text('position',int32([prop_objectos(i).Centroid(1) prop_objectos(i).Centroid(2)]),...      
        'fontsize',5,'string',i,'color', 'g') 

    %print rectangle around every object in green
    thisObj = prop_objectos(i).BoundingBox;
    rectangle('Position', [thisObj(1),thisObj(2),thisObj(3),thisObj(4)],...                      
        'EdgeColor','g','LineWidth',2)
end
hold off
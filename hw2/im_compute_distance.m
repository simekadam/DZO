function [dist] = im_compute_distance(im1, im2, im_rectangle)
% function [dist] = im_compute_distance(im1, im2, im_rectangle)
% computes distance between areas of IM1 and IM2 specified by a
% cropping rectangle. 
%    imdiff = im1 - im2; 
%    imdiff = imdiff(im_rectangle(1): im_rectangle(2), ...
%                    im_rectangle(3):im_rectangle(4));
%    dist = sqrt(sum(imdiff(:).^2));
     
    imdiff = im1 - im2; 
    imdiff = imdiff(im_rectangle(1): im_rectangle(2), ...
                    im_rectangle(3):im_rectangle(4));
    dist = sqrt(sum(imdiff(:).^2));

function out = data_resample(in, outsize)
% function out = dataresample(in, outsize)
% IN: M-by-N matrix.
% OUTSIZE: desired new size of data.
% This function takes the matrix IN and samples it by a rectangular
% grid to produce a new matrix OUT of desired size OUTSIZE. The corner points
% of the two matrices (top-left, top-right, bottom-left, bottom-right
% coincide.
% IN and OUT are of class: double.
nh = outsize(1);
nw = outsize(2);
ht_scale = size(in,1) / nh;
wid_scale = size(in,2) / nw;

 % newX = (1:wid_scale:size(in,2));  %# New image pixel X coordinates
 % newY = (1:ht_scale:size(in,1));

newX = linspace(1,size(in,2),nw);
newY = linspace(1,size(in,1),nh);


out = interp2(in,newX,newY(:),'cubic');

function [mask] = computeEdgeMask(L, gamma, il, ih, ol, oh)
%computeEdgeMask computes edge mask from the input image.
%
%Synopsis
%  mask = computeEdgeMask(L, gamma, il, ih, ol, oh)
%
%Arguments
%  mask         calculated edge mask, data type single, values range 0 to 1
%  L            fisrt input image, data type single, values range 0 to 100
%  gamma        mask gamma adjustement
%  il, ih, ol, oh control mask constrast
%
%See also adjustContrast

  % TODO compute edge mask
  ims = imresize(L, 0.5, 'bilinear');
  edges = imfilter(ims, fspecial('sobel'));
  mask = imresize(edges, [size(L,1) size(L,2)], 'bilinear');
  mask = mask./max(mask(:));
  mask = mask.^gamma;
  % icrease mask contrast
  mask = imageDetailTool.adjustContrast(real(mask), il, ih, ol, oh);
 
  
end

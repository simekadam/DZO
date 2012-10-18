function [filtered, smaller, reconstructed] = im_smaller(im, outsize, sigma);
% function [filtered, smaller, reconstructed] = im_smaller(im, outsize, sigma);
% Inputs:
%  IM: M-by-N matrix of class double
%  OUTSIZE: desired size of output image
%  SIGMA:   parameter of Gaussian to filter the image IM prior to
%  sampling
% Outputs:
%  all three are of class double
%  FILTERED: result after filtering with a Gaussian
%  SMALLER : result after sub-sampling (using interp2)
%  RECONSTRUCTED: result after super-sampling SMALLER (using
%    interp2) to original size

filter_size = (ceil((ceil(sigma*5)/2)+0.5)*2)-1;
gauss_filter1D = fspecial('gauss', [filter_size, 1], sigma);
original_size = size(im);

filtered = conv2(gauss_filter1D', gauss_filter1D, im, 'same');
smaller = data_resample(filtered, outsize);
reconstructed = data_resample(smaller, original_size);
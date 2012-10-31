function [imf] = reduceNoise(im, amount, filter, radius)
%reduceNoise applies noise reducing filtering to the input image.
%
%Synopsis
%  imf = reduceNoise(im, amount, filter, radius)
%
%Arguments
%  imf          output image, data type single
%  im           input image, data type single, values may range 0 to 100 or
%               from -128 to 127
%  amount        amount of filtering, i.e. controls ratio of original and
%               filtered image in the results
%  filter       type of filter - 'median' or 'Gaussian'
%  radius       for median filter this is the half-size of the filtering window
%               for Gaussian filter this is its standard deviation

  % TODO filter image using the requested filter
  filter_size = (ceil((ceil(radius*5)/2)+0.5)*2)-1;
  gauss_filter = fspecial(filter, filter_size, radius);
  
  K = amount*gauss_filter + (1-amount);
%   mesh(K);
  imf = medfilt2(K, im);
  
  
end

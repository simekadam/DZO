function [Lf] = sharpenImage(L, amount, radius)
%sharpenImage sharpens image using unsharp mask filtering: 
%  O = I + a I - a G * I,
%where `I' is the input image, `a' controls filtering amount, `G' is Gaussian
%kernel and `*' is convolution.
%
%Synopsis
%  Lf = sharpenImage(L, amount, radius)
%
%Arguments
%  L            input image, data type single, values may range 0 to 100
%  amout        sharpening amount
%  radius       standard deviation of Gaussian kernel

  % TODO sharpen image using unsharp mask
    filter_size = (ceil((ceil(radius*5)/2)+0.5)*2)-1;
    gauss_filter = fspecial('Gaussian', filter_size, radius);
    dirac = zeros(filter_size, filter_size);
    dirac(floor(filter_size/2)+1, floor(filter_size/2)+1) = 1;
    K = (1+amount)*dirac - (amount*gauss_filter);
%   mesh(K);
    Lf = imfilter(L, K,  'conv');
% Lf = L;  
  % clip overshots, so values remain in the range 0-100 as required by definition of
  % Luminance in Lab space
    Lf(Lf<0) = 0;
    Lf(Lf>100) = 100;
end

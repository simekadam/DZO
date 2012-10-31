function [mask] = adjustContrast(mask, il, ih, ol, oh)
%adjustContrast changes image contrast using a non-linear function passing
%points: [0, 0], [il, ol], [ih, oh] and [1, 1].
%
%Synopsis
%  mask = adjustContrast(mask, il, ih, ol, oh)
%
%Arguments
%  mask         image to adjust, data type single, value range 0 to 1
%  il           input value of first point on the curve
%  ol           output value of first point on the curve
%  ih           input value of second point on the curve
%  oh           output value of second point on the curve
%
%Intensity tranforming function starts at [0,0] and goes over [il, ol], [ih, oh]
%to [1, 1].

  % TODO adjust image contrast
  x = [0 il ih 1];
  y = [0 ol oh 1];
  mask = interp1(x, y, mask, 'cubic');

end

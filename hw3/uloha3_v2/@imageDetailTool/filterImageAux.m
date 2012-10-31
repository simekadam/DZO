function [Lf, af, bf] = filterImageAux(this, L, a, b)
% filterImageAux controls image detail apperance using unsharp mask and noise
% reduction filters.
%
%Synopsis
%  [Lf, af, bf] = filterImageAux(this, L, a, b)
%
%Arguments
%  L   luminance channel, data type single, values range 0 to 100
%  a   first color channel, data type single, values range -128 to 127
%  b   second color channel, data type single, values range -128 to 127
%  Lf   filtered luminance channel, data type single, values range 0 to 100
%  af   first filtered color channel, data type single, values range -128 to 127
%  bf   second filteredcolor channel, data type single, values range -128 to 127

  filterNames = get(this.controls.nrFilter, 'String');
  
  % sharpen image using unsharp mask
  Lf = this.sharpenImage(L, this.amount, this.radius);
  
  % retrieve clipping protection mask from sharpened and original image
  alpha = this.clippingProtection(L, Lf, this.blendLow, this.blendHigh);
  
  % retrieve edge mask from original image
  edgeMask = this.computeEdgeMask(L, this.maskGamma, ...
      this.maskContrastIL, this.maskContrastIH, ...
      this.maskContrastOL, this.maskContrastOH);
  
  if this.nrLuminance ~= 0
    % blend sharpened image with original using clipping protection
    % mask
    Lf = Lf.*alpha + L.*(1-alpha);
    % reduce noise in original image
    Lnr = this.reduceNoise(L, this.nrLuminance, filterNames{this.nrFilter}, this.nrRadius);
    % blend sharpened image with the smoothed image using edge mask
    Lf = Lf.*edgeMask + Lnr.*(1-edgeMask);
  else
    % blend sharpened image with original using clipping protection
    % mask combined with edge mask (the result is the same as above
    % without the noise redution being applied)
    alpha = alpha.*edgeMask;
    Lf = Lf.*alpha + L.*(1-alpha);
  end
  clear Lnr alpha edgeMask;
  
  if ~isempty(a) && this.nrColor ~= 0
    % filter noise out of color channels
    af = this.reduceNoise(a, this.nrColor, filterNames{this.nrFilter}, this.nrRadius);
    bf = this.reduceNoise(b, this.nrColor, filterNames{this.nrFilter}, this.nrRadius);
  else
    af = a;
    bf = b;
  end
end

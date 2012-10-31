classdef imageDetailTool < handle
%

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % public methods
  methods
    function [this] = imageDetailTool()

      defaultBackground = get(0,'defaultUicontrolBackgroundColor');

      this.figure = figure(...
        'IntegerHandle', 'off', ...
        'HandleVisibility', 'callback', ...
        'Visible', 'off', ...
        'Name', 'Image Detail Tool', ...
        'MenuBar', 'none', ...
        'NumberTitle', 'off', ...
        'Resize', 'on', ...
        'ResizeFcn', @(h,ev)this.updateLayout(), ...
        'Toolbar', 'none', ...
        'Units', 'characters', ...
        'Position', [20 10 180 55], ...
        'Color', defaultBackground);

      this.controls.preview = axes(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Box', 'on', 'XTick', [], 'YTick', []);
      
      this.controls.load = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'pushbutton', 'String', 'Load Image', ...
        'Callback', @(h,ev)this.loadImage() );
      
      this.controls.test = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'pushbutton', 'String', 'T', ...
        'Callback', @(h,ev)this.test() );
      
      this.controls.zoom = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'popupmenu', 'String', {'1:8' '1:4' '1:3' '1:2' '1:1' '2:1' '3:1' '4:1' '8:1'}, ...
        'Value', 5, ...
        'Callback', @(h,ev)this.updateLayout() );
      
      this.controls.original = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'checkbox', 'String', 'Show original', ...
        'Callback', @(h,ev)this.updateFilter() );
      
      this.controls.showMask = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'checkbox', 'String', 'Show mask', ...
        'Callback', @(h,ev)this.updateFilter() );
      
      this.controls.cacheResults = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'checkbox', 'String', 'Cache results', 'Value', 1, ...
        'Callback', @(h,ev)this.updateFilter() );
      
      this.controls.amountL = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'text', 'String', 'Amount', 'HorizontalAlignment', 'left');
      this.controls.amount = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'edit', 'String', num2str(this.amount), ...
        'Callback', @(h,ev)this.updateFilter() );

      this.controls.radiusL = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'text', 'String', 'Sigma', 'HorizontalAlignment', 'left');
      this.controls.radius = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'edit', 'String', num2str(this.radius), ...
        'Callback', @(h,ev)this.updateFilter() );
      
      this.controls.blendL = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'text', 'String', 'Clipping Protection [l h]', 'HorizontalAlignment', 'left');
      this.controls.blendLow = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'edit', 'String', num2str(this.blendLow), ...
        'Callback', @(h,ev)this.updateFilter() );
      this.controls.blendHigh = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'edit', 'String', num2str(this.blendHigh), ...
        'Callback', @(h,ev)this.updateFilter() );
      
      this.controls.maskGammaL = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'text', 'String', 'Mask Gamma', 'HorizontalAlignment', 'left');
      this.controls.maskGamma = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'edit', 'String', num2str(this.maskGamma), ...
        'Callback', @(h,ev)this.updateFilter() );
      
      this.controls.maskContrastL = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'text', 'String', 'Mask Constrast [il ih ol oh]', ...
        'HorizontalAlignment', 'left');
      this.controls.maskContrastIL = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'edit', 'String', num2str(this.maskContrastIL), ...
        'Callback', @(h,ev)this.updateFilter() );
      this.controls.maskContrastIH = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'edit', 'String', num2str(this.maskContrastIH), ...
        'Callback', @(h,ev)this.updateFilter() );
      this.controls.maskContrastOL = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'edit', 'String', num2str(this.maskContrastOL), ...
        'Callback', @(h,ev)this.updateFilter() );
      this.controls.maskContrastOH = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'edit', 'String', num2str(this.maskContrastOH), ...
        'Callback', @(h,ev)this.updateFilter() );
      
      this.controls.nrFilterL = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'text', 'String', 'NR Filter', ...
        'HorizontalAlignment', 'left');
      this.controls.nrFilter = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'popupmenu', 'String', {'Gaussian' 'median'}, ...
        'Value', this.nrFilter, ...
        'Callback', @(h,ev)this.updateFilter() );
      
      this.controls.nrRadiusL = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'text', 'String', 'Sigma', ...
        'HorizontalAlignment', 'left');
      this.controls.nrRadius = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'edit', 'String', num2str(this.nrRadius), ...
        'Callback', @(h,ev)this.updateFilter() );
      
      this.controls.nrLuminanceL = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'text', 'String', 'Luminance NR Amount', ...
        'HorizontalAlignment', 'left');
      this.controls.nrLuminance = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'edit', 'String', num2str(this.nrLuminance), ...
        'Callback', @(h,ev)this.updateFilter() );
      
      this.controls.nrColorL = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'text', 'String', 'Color NR Amount', ...
        'HorizontalAlignment', 'left');
      this.controls.nrColor = uicontrol(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Style', 'edit', 'String', num2str(this.nrColor), ...
        'Callback', @(h,ev)this.updateFilter() );
      
      this.controls.imaxes = axes(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Box', 'on', 'XTick', [], 'YTick', []);
      
      this.controls.testim = axes(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Box', 'on', 'XTick', [], 'YTick', []);
      
      this.controls.plotl = axes(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Box', 'on', 'XTick', [], 'YTick', []);
      
      this.controls.plotm = axes(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Box', 'on', 'XTick', [], 'YTick', []);
      
      this.controls.plotr = axes(...
        'Parent', this.figure, 'Units', 'characters', ...
        'Box', 'on', 'XTick', [], 'YTick', []);

      this.updateLayout();
      
      this.updateTestIm();

      ensureVisible(this.figure);

      set(this.figure, 'Visible', 'on');
    end

  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % protected data members
  properties (SetAccess = protected)
    figure
    controls
    im = struct('rgb', 0, 'L', [], 'a', [], 'b', [])
    viewCenter = [0 0]
    imcache = cell(2,1)
    imcacheKeys = nan(2, 14)
    imcacheIndex = 1
    % filter params
    amount = 4
    radius = 0.7
    blendLow = 8
    blendHigh = 27
    maskGamma = 0.5
    maskContrastIL = 0.3
    maskContrastIH = 0.8
    maskContrastOL = 0.02
    maskContrastOH = 0.98
    nrFilter = 1
    nrRadius = 5;
    nrLuminance = 0;
    nrColor = 0;
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % protected methods
  methods(Access = protected)
    function updateLayout(this)
      pos = get(this.figure, 'Position');
      w = pos(3);
      h = pos(4);
      b = h - 0.5;
      
      % determine unit size
      set(this.figure, 'Units', 'pixels');
      pos = get(this.figure, 'Position');
      chw = pos(3)/w;
      chh = pos(4)/h;
      set(this.figure, 'Units', 'characters');
      
      if 46*chw >( 257+chw)
          s = 0;
      else
          s = 6;
      end
      eh = round(1.2*chh)/chh;
      
      % layout controls
      b = b - 193/chh;
      set(this.controls.preview, 'Position', [1 b 257/chw 193/chh]);
            
      b = b - 2;
      set(this.controls.load, 'Position', [1 b 16 1.6]);
      set(this.controls.test, 'Position', [18 b 5 1.6]);
      set(this.controls.original, 'Position', [23+s b 257/chw-23-s 1.6]);
            
      b = b - 1.5;
      set(this.controls.amountL, 'Position', [1 b 10 1]);
      set(this.controls.amount, 'Position', [11 b 5 1.2]);
      set(this.controls.showMask, 'Position', [23+s b 257/chw-23-s 1.6]);
      
      b = b - 1.3;
      set(this.controls.radiusL, 'Position', [1 b 10 1]);
      set(this.controls.radius, 'Position', [11 b 5 eh]);
      set(this.controls.cacheResults, 'Position', [23+s b-0.2 257/chw-23-s 1.6]);
      
      b = b - 1.3;
      set(this.controls.blendL, 'Position', [1 b 27 1]);
      
      b = b - 1.3;
      set(this.controls.blendLow, 'Position', [11 b 5 eh]);
      set(this.controls.blendHigh, 'Position', [17 b 5 eh]);
      
      b = b - 1.3;
      set(this.controls.maskGammaL, 'Position', [1 b 15 1]);
      set(this.controls.maskContrastL, 'Position', [17+s b 27 1]);
      
      b = b - 1.3;
      set(this.controls.maskGamma, 'Position', [11 b 5 eh]);
      set(this.controls.maskContrastIL, 'Position', [17+s b 5 eh]);
      set(this.controls.maskContrastIH, 'Position', [23+s b 5 eh]);
      set(this.controls.maskContrastOL, 'Position', [29+s b 5 eh]);
      set(this.controls.maskContrastOH, 'Position', [35+s b 5 eh]);
      
      b = b - 1.3;
      set(this.controls.nrLuminanceL, 'Position', [1 b 27 1]);
      set(this.controls.nrLuminance, 'Position', [29 b 5 eh]);
      
      b = b - 1.3;
      set(this.controls.nrColorL, 'Position', [1 b 27 1]);
      set(this.controls.nrColor, 'Position', [29 b 5 eh]);
      
      b = b - 1.3;
      set(this.controls.nrFilterL, 'Position', [1 b 10 1]);
      set(this.controls.nrFilter, 'Position', [11 b 17 eh]);
      set(this.controls.nrRadiusL, 'Position', [29 b 6+s 1]);
      set(this.controls.nrRadius, 'Position', [35+s b 5 eh]);
      
      set(this.controls.imaxes, 'Position', [257/chw+2 0.5 w-257/chw-3 h-1 ]);
      set(this.controls.zoom, 'Position', [257/chw+2 h-0.5-2 9 2]);
      
      b = 0.5;
      set(this.controls.plotl, 'Position', [1 b 83/chw 257/chh]);
      set(this.controls.plotm, 'Position', [87/chw+1 b 83/chw 257/chh]);
      set(this.controls.plotr, 'Position', [174/chw+1 b 83/chw 257/chh]);
      
      b = b + 5/chh + 257/chh;
      set(this.controls.testim, 'Position', [1 b 257/chw 51/chh]);
      
      % determine zoom level
      zoomOptions = get(this.controls.zoom, 'String');
      zoom = eval(regexprep(zoomOptions{get(this.controls.zoom, 'Value')}, ':', '/'));
      
      % update axes limits so that it displays zoomed view
      set(this.controls.imaxes, 'Units', 'pixels');
      p = round(get(this.controls.imaxes, 'Position')/zoom);
      set(this.controls.imaxes, 'Units', 'characters');
      s = size(this.im.rgb);
      set(this.controls.imaxes, ...
         'XLim', [0 p(3)+1] + min(max(this.viewCenter(1) - round(p(3)/2), 0), s(2)-p(3)-2), ...
         'YLim', [0 p(4)+1] + min(max(this.viewCenter(2) - round(p(4)/2), 0), s(1)-p(4)-2) );
    end

    function loadImage(this)
      [file path ] = uigetfile({...
        '*.jpeg;*.jpg;*.tiff;*.tif;*.png', 'Common Image Files (*.jpeg,*.jpg,*.tiff,*.tif,*.png)';
        '*.*',  'All Files (*.*)' });
      
      if isnumeric(file)
        return
      end
      
      set(this.figure, 'Pointer', 'watch');
      drawnow expose
      
      this.im = struct('rgb', im2uint8(imread([path file])), ...
        'L', [], 'a', [], 'b', []);
      if size(this.im.rgb, 3) > 1
        [this.im.L this.im.a this.im.b] = this.RGB2Lab(this.im.rgb);
      else
        this.im.L = single(this.im.rgb)/255*100;
      end
      
      im = this.filterImage(this.im);
      this.imcacheKeys(:) = nan;
      this.setImCache(im);
      if size(im,3) < 3 
        cdata = im(:,:,[1 1 1]); 
      else
        cdata = im;
      end
      
      this.viewCenter = round([size(this.im.rgb,2) size(this.im.rgb,1)]/2);
      
      image(cdata, 'Parent', this.controls.imaxes);
      set(this.controls.imaxes, 'XLimMode', 'manual', 'YLimMode', 'manual', ...
        'XTick', [], 'YTick', []);

      if size(this.im.rgb,3) < 3 
        cdata = this.im.rgb(:,:,[1 1 1]); 
      else
        cdata = this.im.rgb;
      end
      image(cdata, 'Parent', this.controls.preview, ...
        'ButtonDownFcn', @(h, e) this.previewClick(h));
      axis(this.controls.preview, 'equal');
      set(this.controls.preview, ...
        'XTick', [], 'YTick', []);
      
      this.updateLayout();
      
      set(this.figure, 'Pointer', 'arrow');
    end
    
    function updateTestIm(this)
      im = uint8([ repmat(floor(255.5:-0.5:128), 25, 1); 
                   repmat(floor(0:0.5:127.5), 25, 1) ]);
           
      im = this.filterImage(struct('rgb', im, 'L', single(im)/255*100, 'a', [], 'b', []));
      
      image(im(:,:,[1 1 1]), 'Parent', this.controls.testim);
      set(this.controls.testim, 'XLimMode', 'manual', 'YLimMode', 'manual', ...
        'XTick', [], 'YTick', [], 'XLim', [0 257], 'YLim', [0 51]);
      
      line([16 16]*2, [1 50], 'Parent', this.controls.testim, 'Color', 'red', 'LineStyle', ':');
      line([64 64]*2, [1 50], 'Parent', this.controls.testim, 'Color', 'green', 'LineStyle', ':');
      line([112 112]*2, [1 50], 'Parent', this.controls.testim, 'Color', 'magenta', 'LineStyle', ':');
      
      stairs(5:45, im(5:45,16*2)', 'Parent', this.controls.plotl, 'Color', 'red');
      set(this.controls.plotl, 'Box', 'on', 'XTick', [], 'YTick', [], ...
        'XLim', [4 46], 'YLim', [0 257]);
      stairs(5:45, im(5:45,64*2)', 'Parent', this.controls.plotm, 'Color', 'green');
      set(this.controls.plotm, 'Box', 'on', 'XTick', [], 'YTick', [], ...
        'XLim', [4 46], 'YLim', [0 257]);
      stairs(5:45, im(5:45,112*2)', 'Parent', this.controls.plotr, 'Color', 'magenta');
      set(this.controls.plotr, 'Box', 'on', 'XTick', [], 'YTick', [], ...
        'XLim', [4 46], 'YLim', [0 257]);
    end
    
    function previewClick(this, imh)
      pt = get(get(imh, 'Parent'), 'CurrentPoint');
      this.viewCenter(1) = round(pt(1,1));
      this.viewCenter(2) = round(pt(1,2));
      this.updateLayout();
    end
    
    function updateFilter(this)
      set(this.figure, 'Pointer', 'watch');
            
      this.amount = str2double(get(this.controls.amount, 'String'));
      this.radius = str2double(get(this.controls.radius, 'String'));
      this.blendLow = str2double(get(this.controls.blendLow, 'String'));
      this.blendHigh = str2double(get(this.controls.blendHigh, 'String'));
      this.maskGamma = str2double(get(this.controls.maskGamma, 'String'));
      this.maskContrastIL = str2double(get(this.controls.maskContrastIL, 'String'));
      this.maskContrastIH = str2double(get(this.controls.maskContrastIH, 'String'));
      this.maskContrastOL = str2double(get(this.controls.maskContrastOL, 'String'));
      this.maskContrastOH = str2double(get(this.controls.maskContrastOH, 'String'));
      
      this.blendHigh = min(this.blendHigh, 49);
      this.blendLow = max(min(this.blendHigh, this.blendLow), 0);
      set(this.controls.blendLow, 'String', this.blendLow);
      set(this.controls.blendHigh, 'String', this.blendHigh);
      
      this.nrFilter = get(this.controls.nrFilter, 'Value');
      this.nrRadius = str2double(get(this.controls.nrRadius, 'String'));
      this.nrLuminance = str2double(get(this.controls.nrLuminance, 'String'));
      this.nrColor = str2double(get(this.controls.nrColor, 'String'));
      
      if ~get(this.controls.cacheResults, 'Value')
        this.imcacheKeys(:) = nan;
      end

      drawnow expose
      
      this.updateTestIm();
      
      if numel(this.im.rgb) > 1
        if isempty(this.getImCache())
          im = this.filterImage(this.im);
          this.setImCache(im);
        else
          im = this.getImCache();
        end
        if size(im,3) < 3
          cdata = im(:,:,[1 1 1]);
        else
          cdata = im;
        end
        set(get(this.controls.imaxes, 'Children'), 'CData', cdata);
      end
      
      set(this.figure, 'Pointer', 'arrow');
    end
    
    function [rgb] = filterImage(this, im)
      if get(this.controls.showMask, 'Value')
        rgb = this.computeEdgeMask(im.L, this.maskGamma, ...
          this.maskContrastIL, this.maskContrastIH, ...
          this.maskContrastOL, this.maskContrastOH);
        rgb = uint8(rgb*255);
        return
      end
      if get(this.controls.original, 'Value')
        rgb = im.rgb;
        return
      end
      
      [Lf af bf] = this.filterImageAux(im.L, im.a, im.b);
      
      if ~isempty(af)
        rgb = this.Lab2RGB(Lf, af, bf);
      else
        rgb = uint8(Lf/100*255);
      end
    end
    
    % defined in separate file
    [Lf, af, bf] = filterImageAux(this, L, a, b)
        
    function test(this)
      range = 0:0.1:100;
      out = this.clippingProtection(range, range, this.blendLow, this.blendHigh);
      figure; plot(range, out);
      title('Clipping protection');
      
      range = 0:0.001:1;
      out = this.adjustContrast(range, ...
          this.maskContrastIL, this.maskContrastIH, ...
          this.maskContrastOL, this.maskContrastOH);
      figure; plot(range, out);
      title('Constrast adjust function');
    end
    
    function [im] = getImCache(this)
      if get(this.controls.original, 'Value') && ~get(this.controls.showMask, 'Value')
        im = this.im.rgb;
        return;
      end
      
      key = [this.amount this.radius this.blendLow this.blendHigh ...
             this.maskGamma this.maskContrastIL this.maskContrastIH ...
             this.maskContrastOL this.maskContrastOH this.nrFilter ...
             this.nrRadius this.nrLuminance this.nrColor ...
             get(this.controls.showMask, 'Value') ];

      i = find(all(this.imcacheKeys == key([1 1], :), 2));
      if isempty(i)
        im = [];
      else
        this.imcacheIndex = i;
        im = this.imcache{i};
      end
    end

    function setImCache(this, im)
      if get(this.controls.original, 'Value') && ~get(this.controls.showMask, 'Value')
        return;
      end
      
      key = [this.amount this.radius this.blendLow this.blendHigh ...
             this.maskGamma this.maskContrastIL this.maskContrastIH ...
             this.maskContrastOL this.maskContrastOH this.nrFilter ...
             this.nrRadius this.nrLuminance this.nrColor ...
             get(this.controls.showMask, 'Value') ];

      i = find(all(this.imcacheKeys == key([1 1], :), 2));
      if isempty(i)
        i = mod(this.imcacheIndex, 2) + 1;
        this.imcacheIndex = i;
        this.imcache{i} = im;
        this.imcacheKeys(i,:) = key;
      else
        this.imcacheIndex = i;
      end
    end
    
  end
  
  methods(Access = public, Static)
    function [L a b] = RGB2Lab(rgb)
      if strfind(computer('arch'), '64')
        lab = applycform(im2double(rgb), makecform('srgb2lab'));
        L = single(lab(:,:,1));
        a = single(lab(:,:,2));
        b = single(lab(:,:,3));
      else
        maxSlice = 2^20; % 1 Mpix = 24 Mbytes
        sc = floor(maxSlice/size(rgb,1));
        L = zeros(size(rgb,1), size(rgb,2), 'single');
        a = zeros(size(rgb,1), size(rgb,2), 'single');
        b = zeros(size(rgb,1), size(rgb,2), 'single');
        for i=1:sc:size(rgb,2)
          lab = applycform(im2double(...
            rgb(:, i:min(i + sc - 1, end), :) ), makecform('srgb2lab'));
          L(:, i:min(i + sc - 1, end)) = single(lab(:,:,1));
          a(:, i:min(i + sc - 1, end)) = single(lab(:,:,2));
          b(:, i:min(i + sc - 1, end)) = single(lab(:,:,3));
        end
      end
    end
    
    function [rgb] = Lab2RGB(L, a, b)
      if strfind(computer('arch'), '64')
        rgb = im2uint8(applycform(cat(3, double(L), double(a), double(b)), ...
            makecform('lab2srgb')));
      else
        maxSlice = 2^20; % 1 Mpix = 24 Mbytes
        sc = floor(maxSlice/size(L,1)); % number of slice columns
        rgb = zeros(size(L,1), size(L,2), 3, 'uint8');
        for i=1:sc:size(rgb,2)
          rgb(:, i:min(i + sc - 1, end), :) = ...
            im2uint8(applycform(cat(3, ...
              double(L(:, i:min(i + sc - 1, end))), ...
              double(a(:, i:min(i + sc - 1, end))), ...
              double(b(:, i:min(i + sc - 1, end))) ), ...
              makecform('lab2srgb') ));
        end
      end
    end
    
    % Methods in separate files to be written by a student.
    [Lf] = sharpenImage(L, amount, radius);
    [alpha] = clippingProtection(L, Lf, bl, bh);
    [mask] = computeEdgeMask(L, gamma, l, h, ol, oh);
    [mask] = adjustContrast(mask, l, h, ol, oh);
    [imf] = reduceNoise(im, amount, filter, radius);
  end
  
end

% suppress some mlint mesages
%#ok<*PROP>
%#ok<*CPROP>

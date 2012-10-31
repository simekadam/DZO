function [] = ensureVisible( figures )
%ensureVisible ensures that passed figures are fully visible on some monitor.
%
%Synopsis
%  ensureVisible( figures )
%
%Arguments
%  figures      Array of figure handles.
%
%See also 

error(nargchk(1,1,nargin));

for i=1:numel(figures)
  ensureVisibleAux(figures(i));
end

function [] = ensureVisibleAux( figure )

oldUnits = get(figure, 'Units');
set(figure, 'Units', 'Pixels');
pos = get(figure, 'Position');
w = pos(3);
h = pos(4);
%convert to [lower left corner, upper right corner] y axis growing up with
%origin in lower-left corner
p = [pos(1:2) pos(1:2)+pos(3:4)-1];

%[upper left corner, lower right corner] y axis growing down with origin in 
%upper-left corner
monitors = get(0, 'MonitorPositions');
%convert to [lower left corner, upper right corner] y axis growing up with
%origin in lower-left corner
ph = monitors(1,4)-monitors(1,2)+1; % primary monitor height
for i=1:size(monitors,1)
  m = monitors(i,:);
  monitors(i,:) = [m(1) ph-m(4)+1 m(3) ph-m(2)+1];
end

% calculate intersection with all monitors
int = [max(monitors(:,1), p(1)) ...
       max(monitors(:,2), p(2)) ... 
       min(monitors(:,3), p(3)) ... 
       min(monitors(:,4), p(4))];

dim = int(:,3:4)-int(:,1:2)+1;
dim(dim<0) = 0;
area = prod(dim,2);

if round(sum(area)) ~= round(w*h)
  % move figure to the monitor with the biggest overlap
  [dummy i] = max(area);
  m = monitors(i,:);
  if m(1) > p(1)
    pos(1) = m(1)+3;
  end
  if m(2) > p(2)
    pos(2) = m(2)+3;
  end
  if m(3) < p(3)
    pos(1) = m(3)-w+1-3;
  end
  if m(4) < p(4)
    pos(2) = m(4)-h+1-22;
  end
  set(figure, 'Position', pos);
end

% restore units
set(figure, 'Units', oldUnits);

function [alpha] = clippingProtection(L, Lf, bl, bh)
%clippingProtection calculates a blending mask with low, or even zero, values
%in areas of extreme highlights and shadows appearing in input images.
%
%Synopsis
%  alpha = clippingProtection(L, Lf, bl, bh)
%
%Arguments
%  alpha        calculated blending mask, data type single, values range 0 to 1
%  L            fisrt input image, data type single, values range 0 to 100
%  Lf           second input image, data type single, values range 0 to 100
%  bl           beginning of highlits/shadows to midtones transision area
%  bh           end of highlits/shadows to midtones transision area

  % TODO calculate clipping protection mask
    alpha = ones(size(L), 'single');
   [sizex, sizey] = size(L);
%    
%    disp(sizex);
%    disp(sizey);
    
        
   C = 0.5*((b(L, bl, bh) + b(Lf, bl, bh)));
         
   
   

%     zero = L<bl | L>(100-bl);
%     one = bh<L<100-bh;
%     alpha(zero) = 0;
%     alpha(one) = 1;
%     disp(alpha);
     alpha = Lf.*C + (1-C).*L; 
     alpha = alpha./100;
%     disp(alpha);
  
end

function [y] = b(input, l, h)
    
  x = [0, l, h, 100-h, 100-l, 100 ];
  y = [0, 0, 1, 1,     0,     0];
  y = interp1(x, y, input, 'linear');

%     if(x <= l)
%         y = 0;
%     elseif(x <= h)
%         k = -1/(l-h);
%         q = -k*l;
%         y = k*x+q;
%     elseif(x <= (100-h))
%         y = 1;
%     elseif(x < 100-l)
%         k = 1/(h-l);
%         q = -k*(100-l);
%         y = -((k*x)+q);
%     else
%         y = 0;
% 
%     end    
end
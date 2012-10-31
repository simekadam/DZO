function [y] = b(x, l, h)
    
    if(x <= l)
        y = 0;
    elseif(x <= h)
        k = -1/(l-h);
        q = -k*l;
        y = k*x+q;
    elseif(x <= (100-h))
        y = 1;
    elseif(x < 100-l)
        k = 1/(h-l);
        q = -k*(100-l);
        y = -((k*x)+q);
    else
        y = 0;

    end    
end
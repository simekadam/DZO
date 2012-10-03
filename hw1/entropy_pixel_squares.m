function [entropy_aver, bytes_aver_image, bytes_aver_coding, entropy_diff, bytes_diff_image, bytes_diff_coding] = entropy_pixel_squares(im)

    [rows, columns] = size(im);
    
    avg = zeros(rows/8,columns/8);
    im = double(im);
    x=1;
    for i = 1:8:rows-7,
        y=1;
        for j = 1:8:columns-7,
            avg(x,y) = round(mean2(im(i:i+7,[j j+7])));
            im(i:i+7,[j j+7]) = im(i:i+7,[j j+7]) - avg(x,y);
            y=y+1;
        end
        x = x+1;
    end

%entropy_aver = entropy_single_pixels(avg);
avg = reshape(avg.',1,[]);

fprintf('AVERAGES:\n');
entropy_single_pixels(avg);
fprintf('DIFFS:\n');
entropy_single_pixels(im);    
%disp(im);
%whos('avg');

end


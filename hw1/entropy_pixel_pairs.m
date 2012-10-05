function [entropy, bytes_image, bytes_coding] = entropy_pixel_pairs(im)



[rows, columns] = size(im);
b = zeros(rows/2,columns);

im = double(im);

x=1;
for i = 1:2:rows,
    for j = 1:columns,
        b(x,j) = im(i,j) + im(i+1,j)*1000;
    end
    x = x+1;
end
%disp(b);
b = reshape(b.',1,[]);

%disp(b);

histg = hist(b,0:255255);
histg(histg==0) = [];
nzhist = histg ./ numel(b);
entropy = -sum(nzhist.*log2(nzhist));

bytes_image = (entropy*(numel(b))/8);

bytes_coding = 4*numel(unique(b));

fprintf('ENTROPY_VALUE:%s\n',num2str(entropy));
fprintf('BYTES_IMAGE:%s\n',num2str(bytes_image));
fprintf('BYTES_CODING:%s\n',num2str(bytes_coding));

end
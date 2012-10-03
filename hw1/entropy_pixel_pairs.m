function [entropy, bytes_image, bytes_coding] = entropy_pixel_pairs(im)

entropy = 0;
bytes_image = 0;
bytes_coding = 0;

[rows, columns] = size(im);
b = zeros(rows/2,columns);

%typecast(im(:),'uint32');
im = double(im);

x=1;
for i = 1:2:rows,
    for j = 1:columns,
        b(x,j) = im(i,j) + im(i+1,j)*1000;
    end
    x = x+1;
end

b = reshape(b.',1,[]);

%whos('b');
%disp(b(35,15));
%disp(im(i,j)*1000 + im(i+1,j));

%disp(hist(b));
%disp(numel(unique(b)));

histg = hist(b,65536);
histg(histg==0) = [];
nzhist = histg ./ numel(im);
entropy = -sum(nzhist.*log2(nzhist));

bytes_image = (entropy*(numel(b))/8);

bytes_coding = 4*numel(unique(b));

fprintf('ENTROPY_VALUE:%s\n',num2str(entropy));
fprintf('BYTES_IMAGE:%s\n',num2str(bytes_image));
fprintf('BYTES_CODING:%s\n',num2str(bytes_coding));

end
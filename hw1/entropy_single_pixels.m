function [entropy, bytes_image, bytes_coding] = entropy_single_pixels(im)

%zkouska zmeny v GITu

im = double(im);
im = reshape(im.',1,[]);
histg = hist(im, 0:255);

histg(histg==0) = [];
nzhist = histg ./ numel(im);
entropy = -sum(nzhist.*log2(nzhist));

bytes_image = (entropy*(numel(im))/8);

bytes_coding = 2*numel(unique(im));

fprintf('ENTROPY_VALUE:%s\n',num2str(entropy));
fprintf('BYTES_IMAGE:%s\n',num2str(bytes_image));
fprintf('BYTES_CODING:%s\n',num2str(bytes_coding));

end
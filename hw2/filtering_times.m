function [t_2D, t_separable] = filtering_times(im, sigmas)
% function [t_2D, t_separable] = filtering_times(im, sigmas)
% IM: an M-by-N matrix of class double
% SIGMAS: a 1-by-K vector storing sigmas of Gaussian filters.
% This function takes one sigma after another, and for each one:
%    * it filters the image with a 2D Gaussian kernel of a given sigma
%    * it filters the image with two separable 1D Gaussian kernels of a given sigma
%
% For each sigma, this function records the time needed for the filtering using
% a 2D Gaussian, and using the separable kernels. The timings are stored in
% t_2D and t_separable, respectively.
% Thus t_2D and t_separable are 1-by-K vectors.
%im = im2double(im);

for sigma = sigmas
	% find closest greater odd integer ≤ 3·sigma
	filter_size = (ceil((ceil(sigma*3)/2)+0.5)*2)-1;
	gauss_filter = fspecial('gauss', filter_size, sigma);
	gauss_filter1D = fspecial('gauss', [filter_size, 1], sigma);
	tic
	filtered_image = conv2(im, gauss_filter, 'same');
	toc
	timer2d = toc;
	tic
	filtered_image2 = conv2(gauss_filter1D, gauss_filter1D, im, 'same');
	toc
	timer1d = toc;

	fprintf('%i test %i\n', timer1d, timer2d);

	% THIS CODE CHECKS IF ARE BOTH TRANSFORMS PRODUCING SAME RESULTS (SLIGHT DIFFERENCE IS CAUSED BY NUMERIC ROUNDING WHILE COMPUTING)
	% im_diff = filtered_image - filtered_image2;

	% [row_val row_ind] = max(abs(im_diff), [], 1);
	% disp(max(row_val)<10e-13);


end
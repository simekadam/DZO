outsize = [150 200];

sigmas = [0.8, 1, 1.2, 1.4, 1.7, 2.0, 2.3, 2.6, 3.0, 3.5, 5, 10, 20];
sigmaN = length(sigmas);

dists_filtering = zeros(1,sigmaN);
dists_aliasing  = zeros(1,sigmaN);

im_rectangle = [250, 600, 250, 800];

for k = 1:sigmaN

    sigma = sigmas(k);
    [filtered, smaller, reconstructed] = im_smaller(im, outsize, sigma);

    dists_filtering(k) = im_compute_distance(im, filtered, im_rectangle);
    dists_aliasing(k)  = im_compute_distance(reconstructed, filtered, im_rectangle);
    disp(sigma);
  	imshow(smaller/255);
  	pause
end

	plot(sigmas,dists_filtering, '-rs');
	hold on;
	plot(sigmas,dists_aliasing, '-gs');
	xlabel('Sigma');
	ylabel('Difference');
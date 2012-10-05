function [entropy, bytes_image, bytes_coding] = entropy_single_pixels(image)

		%nejaky weird pretypovani
		image  = double(image);
		image = reshape(image.',1,[]);

		%vystup histogramu
		histogramOutput = hist(image, 0:255);

		%sejmu nuly
		histogramOutput( histogramOutput == 0 ) = [];

		%odectu prumer
		histogramOutput = histogramOutput ./ numel( image );

		%tohle snad jakoze pocita tu entropii
		entropy = sum( histogramOutput .* log2( histogramOutput ) )*( -1 );
		bytes_image = ( entropy * ( numel( image ) ) / 8 );
		bytes_coding = 2 * numel( unique( image ) );

		%vystupy
		fprintf( 'ENTROPY_VALUE:%s\n', num2str( entropy ));
		fprintf( 'BYTES_IMAGE:%s\n', num2str( bytes_image ));
		fprintf( 'BYTES_CODING:%s\n', num2str( bytes_coding ));

end
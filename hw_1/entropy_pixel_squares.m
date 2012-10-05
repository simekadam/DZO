function [entropy_aver, bytes_aver_imageage, bytes_aver_coding, entropy_diff, bytes_diff_imageage, bytes_diff_coding] = entropy_pixel_squares(image)



    [rowCount, columnCount] = size(image);
    
    averages = zeros(rowCount/8,columnCount/8);
    image = double(image);
    x=1;
    for i = 1:8:rowCount-7,
        y=1;
        for j = 1:8:columnCount-7,
            averages( x,y ) = round( mean2( image( i:i+7,( j:j+7 ) )));
            image( i:i+7,(j:j+7) )  = image( i:i+7, ( j:j+7 ) ) - averages( x, y );
            y = y+1;
        end
        x = x+1;
    end

%entropy_aver = entropy_single_pixels(avg);
averages = reshape( averages.',1,[] );

%nejaky weird pretypovani
        aimage  = double(averages);
        aimage = reshape(aimage.',1,[]);

        %vystup histogramu
        ahistogramOutput = hist(aimage, 0:255);

        %sejmu nuly
        ahistogramOutput( ahistogramOutput == 0 ) = [];

        %odectu prumer
        ahistogramOutput = ahistogramOutput ./ numel( aimage );

        %tohle snad jakoze pocita tu entropii
        entropy_aver = sum( ahistogramOutput .* log2( ahistogramOutput ) )*( -1 );
        bytes_aver_imageage = ( entropy_aver * ( numel( aimage ) ) / 8 );
        bytes_aver_coding = 2 * numel( unique( aimage ) );

        %vystupy
        fprintf( 'ENTROPY_AVER:%s\n', num2str( entropy_aver ));
        fprintf( 'BYTES_AVER_IMAGE:%s\n', num2str( bytes_aver_imageage ));
        fprintf( 'BYTES_AVER_CODING:%s\n', num2str( bytes_aver_coding )); 

        image = reshape(image.',1,[]);

        %vystup histogramu
        histogramOutput = hist(image, -255:255);

        %sejmu nuly
        histogramOutput( histogramOutput == 0 ) = [];

        %odectu prumer
        histogramOutput = histogramOutput ./ numel( image );

        %tohle snad jakoze pocita tu entropii
        entropy_diff = sum( histogramOutput .* log2( histogramOutput ) )*( -1 );
        bytes_diff_imageage = ( entropy_diff * ( numel( image ) ) / 8 );
        bytes_diff_coding = 2 * numel( unique( image ) );

        %vystupy
        fprintf( 'ENTROPY_DIFF:%s\n', num2str( entropy_diff ));
        fprintf( 'BYTES_DIFF_IMAGE:%s\n', num2str( bytes_diff_imageage ));
        fprintf( 'BYTES_DIFF_CODING:%s\n', num2str( bytes_diff_coding ));

% ENTROPY_AVER: entropy of 'averages' observations
% BYTES_AVER_IMAGE: bytes needed for storing the averages by entropy coding
% BYTES_AVER_CODING: bytes needed for storing the entropy coding itself.
% For the differences it outputs:
% ENTROPY_DIFF: entropy of values in the image of differences
% BYTES_DIFF_IMAGE: bytes needed for storing the differences by entropy coding
% BYTES_DIFF_CODING: bytes needed for storing the entropy coding itself.


end


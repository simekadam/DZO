function [entropy, bytes_image, bytes_coding] = entropy_pixel_pairs(image)


[rowCount, columnCount] = size( image );

pairedValues = zeros( rowCount/2,columnCount );

image = double( image );

x=1;
for i = 1:2:rowCount,
    for j = 1:columnCount,
        pairedValues( x,j )  = image( i,j ) + image( i+1,j ) * 1000;
    end
    x = x+1;
end

pairedValues = reshape(pairedValues.',1,[]);

histogramOutput = hist( pairedValues, 0:255256 );
histogramOutput( histogramOutput==0 ) = [];
output = histogramOutput ./ numel( pairedValues );

entropy = -sum( output.*log2( output ) );
bytes_image = ( entropy * ( numel( pairedValues ) ) / 8 );
bytes_coding =  numel( unique( pairedValues ) ) * 4;

fprintf('ENTROPY_VALUE:%s\n',num2str( entropy ));
fprintf('BYTES_IMAGE:%s\n',num2str( bytes_image ));
fprintf('BYTES_CODING:%s\n',num2str( bytes_coding ));

end
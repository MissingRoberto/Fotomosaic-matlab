function [ IMAGE ] = imagerandom( IMAGES, N )
%IMAGERANDOM Summary of this function goes here
%   Detailed explanation goes here
    i= rand(1);
    i= i(1,1);
    INDEX=int8(N*i);
    IMAGE=IMAGES(INDEX);

end


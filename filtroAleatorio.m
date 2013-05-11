function [ IMAGE ] = filtroAleatorio( image_in )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
rd= 0.5 + (1.5-0.5).*rand(1,3);
            IMAGE=0.3*image_in;
            IMAGE(:,:,1)=int8(rd(:,1)*image_in(:,:,1));
            IMAGE(:,:,2)=int8(rd(:,2)*image_in(:,:,2));
            IMAGE(:,:,3)=int8(rd(:,3)*image_in(:,:,3));
            IMAGE=IMAGE/0.3;

end


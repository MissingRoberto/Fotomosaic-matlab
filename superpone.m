function [ image_out ] = superpone( image_sup, image_edge, color)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

tam= size(image_sup);
image_out=image_sup;
for i=1:tam(1,1),
    for j=1:tam(1,2),
        for p=1:tam(1,3),
           if(image_edge(i,j)==0)
               image_out(i,j,p)=color;
           else
               image_out(i,j,p)=image_sup(i,j,p);
           end  
            
        end
    end
end

end


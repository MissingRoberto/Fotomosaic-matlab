function [ list ] = oscureceLista( lst_image, factor )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    list=lst_image;
    LST_SIZE= size(lst_image);
    for i=1:LST_SIZE(:,2),
        list{i}=factor*lst_image{i};
    end

end


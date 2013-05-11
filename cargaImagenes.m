function [ list ] = cargaImagenes( folder, elem_size )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

D = dir(strcat(folder,'/*.jpg'));
list = cell(1,numel(D));
for i = 1:numel(D)
    IMG= imread(strcat(folder,'/',D(i).name));
    IMG = imresize(IMG,[elem_size elem_size]);
    list{i} = IMG;
end
end


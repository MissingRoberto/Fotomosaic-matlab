clear

LST_IMAGES = dir('black/*.jpg');
LST_SIZE= size(LST_IMAGES);
N= LST_SIZE(1,1);
i= rand(1);
i= i(1,1);
INDEX=int8(N*i);
if(INDEX==0)
    INDEX=1;
end
IMAGE=LST_IMAGES(INDEX);
    
    
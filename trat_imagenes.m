
% *********************************************************************
% *********************************************************************
% *************// PROYECTO. FOTOMOSAICO // ****************************
% **// Autores: Miguel Viana Matesanz y Roberto Jiménez Sánchez //*****
% *********************************************************************
% *********************************************************************

clear 

% ********************************************
% Constantes iniciales 
% ********************************************

% Colores aleatorios

COLORS=0;

% Nombre de la imagen que va a ser procesada

IMAGE_NAME = 'iker.jpg';

% Umbrales para la transformación de la imagen a binaria


EDGE1=155;
EDGE2=137;
EDGE3=115;
EDGE4=95;

% Colores de la imagen solapada **** TODAVÍA SIN UTILIZAR

COLOR_LAYER0=255;
COLOR_LAYER1=200;
COLOR_LAYER2=150; 
COLOR_LAYER3=100;
COLOR_LAYER4=0;

% Factores de oscurecimiento de la imagen 

%IKER

D_WHITE=1.2;
D_BLACK=0.6;
D_GRAY=0.7;
D_MIDDLE_BLACK=0.50;
D_MIDDLE_WHITE=0.8;

% Factores de coloracion de la imagen
SET_RED=1;
SET_GREEN=1;
SET_BLUE=1;

% Constante de submuestreo de la imagen

A=3;

% Tamaño de cada imagen del mosaico ELEM_SIZExELEM_SIZE

ELEM_SIZE= 80;

% Cargamos imagenes para el mosaico

LIST_WHITE = cargaImagenes('white',ELEM_SIZE);
LIST_GRAY = cargaImagenes('gray',ELEM_SIZE);
LIST_BLACK = cargaImagenes('black',ELEM_SIZE);

% Oscurecemos o aclaramos las imagenes

LIST_MIDDLE_BLACK = oscureceLista(LIST_GRAY,D_MIDDLE_BLACK);
LIST_GRAY = oscureceLista(LIST_GRAY,D_GRAY);
LIST_BLACK = oscureceLista(LIST_BLACK,D_BLACK);
LIST_MIDDLE_WHITE = oscureceLista(LIST_WHITE,D_MIDDLE_WHITE);
LIST_WHITE = oscureceLista(LIST_WHITE,D_WHITE);




% ****************************************************************
% ****************************************************************
% *************// IMPLEMENTACION. FOTOMOSAICO // *****************
% ****************************************************************
% ****************************************************************



% ****************************************************************
% FASE 1: Leemos la imagen del fichero que vamos a tratar
% ****************************************************************


IMAGE_RGB = imread(IMAGE_NAME);


% ****************************************************************
% FASE 2: Convierte la señal original a escala de grises
% ****************************************************************

 
IMAGE_GRAY = rgb2gray(IMAGE_RGB);


% ****************************************************************
% FASE 3: Descomposición en capas
% ****************************************************************


% Convertimos nuestra imagen a binaria con el primer umbral

IMAGE_EDGE1 = IMAGE_GRAY>EDGE1;


% Convertimos nuestra imagen a binaria con el segundo umbral

IMAGE_EDGE2 = IMAGE_GRAY>EDGE2;

% Convertimos nuestra imagen a binaria con el segundo umbral

IMAGE_EDGE3 = IMAGE_GRAY>EDGE3;

% Convertimos nuestra imagen a binaria con el segundo umbral

IMAGE_EDGE4 = IMAGE_GRAY>EDGE4;


% *************************************************************************
% FASE 4: Superposición de las imagenes umbrales
% *************************************************************************

% Superposición de las 2 imagenes creadas a partir de los umbrales. 


IMAGE_FONDO = IMAGE_GRAY > 255;% Una imagen entera negra.
IMAGE_SUPERPUESTA = IMAGE_RGB;
IMAGE_SUPERPUESTA = superpone(IMAGE_SUPERPUESTA,IMAGE_FONDO,COLOR_LAYER0);
IMAGE_SUPERPUESTA = superpone(IMAGE_SUPERPUESTA,IMAGE_EDGE1,COLOR_LAYER1);
IMAGE_SUPERPUESTA = superpone(IMAGE_SUPERPUESTA,IMAGE_EDGE2,COLOR_LAYER2);
IMAGE_SUPERPUESTA = superpone(IMAGE_SUPERPUESTA,IMAGE_EDGE3,COLOR_LAYER3);
IMAGE_SUPERPUESTA = superpone(IMAGE_SUPERPUESTA,IMAGE_EDGE4,COLOR_LAYER4);


% *************************************************************************
% FASE 5: Submuestreo de la imagen
% *************************************************************************


IMAGE_SUBM = IMAGE_SUPERPUESTA(1:A:end, 1:A:end, 1:1:end);

% Miramos las dimensiones

SIZE = size(IMAGE_SUBM);
M = SIZE(1,1);
N = SIZE(1,2);

% **************************************************
% ADICIONAL: Sobremuestreo de la imagen submuestreada
% **************************************************


% Sobremuestreamos la imagen


IMAGE_SOBR = imresize(IMAGE_SUBM, [ELEM_SIZE*M ELEM_SIZE*A*N]);


% *************************************************************************
% FASE 6: Composición del fotomosaico
% *************************************************************************



RESULT = [];

for c=1:N %Bucle para recorrer las columnas de la imagen
    
    COLUMN=[];
    
    for f=1:M %Bucle para recorrer las filas de la imagen dentro de una columna
        MUESTRA= IMAGE_SUBM(f,c,:);
       
        % Miramos el valor de la muestra para elegir el tipo de imagen a añadir
        
        switch MUESTRA(:,:,1)
            case COLOR_LAYER0,
                LST_IMAGES = LIST_WHITE;
            case COLOR_LAYER1,
                LST_IMAGES = LIST_MIDDLE_WHITE;
            case COLOR_LAYER2,
                LST_IMAGES = LIST_GRAY;
            case COLOR_LAYER3,
                LST_IMAGES = LIST_MIDDLE_BLACK;
           
            otherwise,
                LST_IMAGES = LIST_BLACK; 
        end
        
        % Elegimos una imagen aleatoria
        
        LST_SIZE = size(LST_IMAGES);
        rd = rand(1);
        INDEX = int8(LST_SIZE(:,2)*rd(1,1));
        
        if INDEX == 0,
            INDEX = 1;
        end
        
        % Añadimos la imagen a la columna.
        
        IMAGE = LST_IMAGES{INDEX};
        
        %IMAGE=filtroAleatorio(IMAGE);
       
        if(COLORS)
            rd= 0.5 + (1.5-0.5).*rand(1,3);
            IMAGE=0.3*IMAGE;
            IMAGE(:,:,1)=int8(rd(:,1)*IMAGE(:,:,1));
            IMAGE(:,:,2)=int8(rd(:,2)*IMAGE(:,:,2));
            IMAGE(:,:,3)=int8(rd(:,3)*IMAGE(:,:,3));
            IMAGE=IMAGE/0.3;
        end
     
        COLUMN = [COLUMN ; IMAGE];
       
    end
  
    RESULT = [RESULT COLUMN];
    
end


% *************************************************************************
% FASE 7: Muestra de los resultados y el proceso
% *************************************************************************


% Muestra todos los pasos del proceso

figure;
subplot(4,2,1), subimage(IMAGE_RGB), title('Imagen original'), axis('off');
subplot(4,2,2), subimage(IMAGE_GRAY), title('Imagen en escala de grises'),axis('off');
subplot(4,2,3), subimage(IMAGE_EDGE1), title('Imagen binaria umbral 1'),axis('off');
subplot(4,2,4), subimage(IMAGE_EDGE2), title('Imagen binaria umbral 2'),axis('off');
subplot(4,2,5), subimage(IMAGE_EDGE3), title('Imagen binaria umbral 3'),axis('off');
subplot(4,2,6), subimage(IMAGE_EDGE4), title('Imagen binaria umbral 4'),axis('off');
subplot(4,2,7), subimage(IMAGE_SUPERPUESTA), title('Imagen superpuesta'),axis('off');
subplot(4,2,8), subimage(IMAGE_SUBM), title('Imagen submuestreada'),axis('off');

% Muestra el resultado final

figure;
RESULT(:,:,1)=SET_RED*RESULT(:,:,1);
RESULT(:,:,2)=SET_GREEN*RESULT(:,:,2);
RESULT(:,:,3)=SET_BLUE*RESULT(:,:,3);

imshow(RESULT), title('Fotomosaico');

% Guarda las imagenes en ficheros

imwrite(IMAGE_GRAY,'iker/iker-gray.jpg');
imwrite(IMAGE_EDGE1,'iker/iker-edge1.jpg');
imwrite(IMAGE_EDGE2,'iker/iker-edge2.jpg');
imwrite(IMAGE_EDGE3,'iker/iker-edge3.jpg');
imwrite(IMAGE_EDGE4,'iker/iker-edge4.jpg');
imwrite(IMAGE_SUPERPUESTA,'iker/iker-superpuesta.jpg');
imwrite(IMAGE_SUBM,'iker/iker-submuestreada.jpg');

imwrite(RESULT,'iker/iker-result.jpg');



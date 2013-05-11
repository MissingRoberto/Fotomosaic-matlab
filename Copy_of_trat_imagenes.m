
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


% Nombre de la imagen que va a ser procesada

IMAGE_NAME = 'picasso.jpg';

% Umbrales para la transformación de la imagen a binaria

EDGE1=170;
EDGE2=130;
EDGE3=115;
EDGE4=70;


% Colores de la imagen solapada **** TODAVÍA SIN UTILIZAR

COLOR_LAYER0=0;
COLOR_LAYER1=128;
COLOR_LAYER2=255; 

% Factores de oscurecimiento de la imagen 

D_WHITE=1.2;
D_BLACK=0.9;
D_GRAY=1.3;
D_MIDDLE_BLACK=0.8;
D_MIDDLE_WHITE=0.85;

% Constante de submuestreo de la imagen

A=6;

% Tamaño de cada imagen del mosaico ELEM_SIZExELEM_SIZE

ELEM_SIZE= 40;

% Cargamos imagenes para el mosaico

LIST_WHITE = cargaLista('white',ELEM_SIZE);
LIST_GRAY = cargaLista('gray',ELEM_SIZE);
LIST_BLACK = cargaLista('black',ELEM_SIZE);

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


% ****************************************************************
% FASE 4: Superposición de las imagenes umbrales
% ****************************************************************

% Superposición de las 2 imagenes creadas a partir de los umbrales. 


IMAGE_FONDO = IMAGE_GRAY > 255;% Una imagen entera negra.
IMAGE_SUPERPUESTA = IMAGE_RGB;
IMAGE_SUPERPUESTA = superpone(IMAGE_SUPERPUESTA,IMAGE_FONDO,255);
IMAGE_SUPERPUESTA = superpone(IMAGE_SUPERPUESTA,IMAGE_EDGE4,200);
IMAGE_SUPERPUESTA = superpone(IMAGE_SUPERPUESTA,IMAGE_EDGE1,150);
IMAGE_SUPERPUESTA = superpone(IMAGE_SUPERPUESTA,IMAGE_EDGE3,100);
IMAGE_SUPERPUESTA = superpone(IMAGE_SUPERPUESTA,IMAGE_EDGE2,0);


% *********************************************
% FASE 5: Submuestreo de la imagen
% *********************************************


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


RESULT_1 = [];
RESULT_2 = [];
RESULT_3 = [];

for c=1:N %Bucle para recorrer las columnas de la imagen
    
    COLUMN_1=[];
    COLUMN_2=[];
    COLUMN_3=[];
    
    for f=1:M %Bucle para recorrer las filas de la imagen dentro de una columna
        MUESTRA= IMAGE_SUBM(f,c,:);
       
        % Miramos el valor de la muestra para elegir el tipo de imagen a añadir
        
        switch MUESTRA(:,:,1)
            case 255,
                LST_IMAGES = LIST_WHITE;
            case 200,
                LST_IMAGES = LIST_MIDDLE_WHITE;
            case 150,
                LST_IMAGES = LIST_GRAY;
            case 100,
                LST_IMAGES = LIST_MIDDLE_BLACK;
           
            otherwise,
                LST_IMAGES = LIST_BLACK; 
        end
        
        % Elegimos una imagen aleatoria
        
        LST_SIZE = size(LST_IMAGES);
        rd = rand(1);
        INDEX = int8(LST_SIZE(1,3)*rd(1,1));
        
        if INDEX == 0,
            INDEX = 1;
        end
        
        % Añadimos la imagen a la columna.
        
        IMAGE = LST_IMAGES(:,:,INDEX);
        figure;
        imshow(IMAGE);
        COLUMN_1 = [COLUMN_1 ; IMAGE(:,:,1)];
         COLUMN_2 = [COLUMN_2 ; IMAGE(:,:,2)];
          COLUMN_3 = [COLUMN_3 ; IMAGE(:,:,3)];
       
    end
    
    RESULT_1 = [RESULT_1 COLUMN_1];
    RESULT_2 = [RESULT_2 COLUMN_2];
    RESULT_3 = [RESULT_3 COLUMN_3];
end

RESULT=cat(3,RESULT_1,RESULT_2,RESULT_3);
% *************************************************************************
% FASE 7: Muestra de los resultados y el proceso
% *************************************************************************


% Muestra todos los pasos del proceso

figure;
subplot(4,2,1), subimage(IMAGE_RGB), title('Imagen original'), axis('off');
subplot(4,2,2), subimage(IMAGE_GRAY), title('Imagen en escala de grisis'),axis('off');
subplot(4,2,3), subimage(IMAGE_EDGE1), title('Imagen binaria umbral 1'),axis('off');
subplot(4,2,4), subimage(IMAGE_EDGE2), title('Imagen binaria umbral 2'),axis('off');
subplot(4,2,5), subimage(IMAGE_EDGE3), title('Imagen binaria umbral 3'),axis('off');
subplot(4,2,6), subimage(IMAGE_EDGE4), title('Imagen binaria umbral 4'),axis('off');
subplot(4,2,7), subimage(IMAGE_SUPERPUESTA), title('Imagen superpuesta'),axis('off');
subplot(4,2,8), subimage(IMAGE_SUBM), title('Imagen submuestreada'),axis('off');

% Muestra el resultado final

figure;
imshow(RESULT), title('Fotomosaico');





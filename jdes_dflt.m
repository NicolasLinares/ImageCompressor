% Ejercicio 1 - GUIÓN DE PRÁCTICAS 4 
%--------------------------------------


function [MSE, RC] = jdes_dflt(fname)

% Entradas:
%  fname: Un string con nombre de archivo comprimido, incluido sufijo.
%         Admite archivos .hud
% Salidas:
%  MSE: Error cuadrático medio. 
%  RC: Relación de compresión.


mostrar_imagenes=0; % Flag para indicar si se quiere visualizar las imagenes resultantes

disptext=1; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Función jdes_dflt:');
end


% Instante inicial
tc=cputime;

%Lee el archivo comprimido 
fid = fopen(fname, 'r');
lenCodedY = double(fread(fid,1,'uint32'));
ultlY = double(fread(fid,1,'uint8'));
CodedY = double(fread(fid,lenCodedY, 'uint8'));
lenCodedCb = double(fread(fid,1,'uint32'));
ultlCb = double(fread(fid,1,'uint8'));
CodedCb = double(fread(fid,lenCodedCb, 'uint8'));
lenCodedCr = double(fread(fid,1,'uint32'));
ultlCr = double(fread(fid,1,'uint8'));
CodedCr = double(fread(fid,lenCodedCr, 'uint8'));
mamp = double(fread(fid,1,'uint32'));
namp = double(fread(fid,1,'uint32'));
caliQ = double(fread(fid,1,'uint16'));
m = double(fread(fid, 1, 'uint32'));
n = double(fread(fid, 1, 'uint32'));

fclose(fid);

CodedY = bytes2bits(CodedY, ultlY);
CodedCb = bytes2bits(CodedCb, ultlCb);
CodedCr = bytes2bits(CodedCr, ultlCr);

% Decodifica los tres Scans a partir de strings binarios
XScanrec = DecodeScans_dflt(CodedY,CodedCb,CodedCr,[mamp namp]);

% Recupera matrices de etiquetas en orden natural
%  a partir de orden zigzag
Xlabrec = invscan(XScanrec);

% Descuantizacion de etiquetas
Xtransrec = desquantmat(Xlabrec, caliQ);

% Calcula iDCT bidimensional en bloques de 8 x 8 pixeles
% Como resultado, reconstruye una imagen YCbCr con tamaño ampliado
Xamprec = imidct(Xtransrec,m, n);

% Convierte a espacio de color RGB
% Para ycbcr2rgb: 
% Intervalo [0,255]->[0,1]->[0,255]
Xrecrd = round(ycbcr2rgb(Xamprec/255)*255);
Xrec = uint8(Xrecrd);

% Repone el tamaño original
Xrec = Xrec(1:m, 1:n, 1:3);

%Genera el nombre del archivo descomprimido '*_des_def.bmp'
[pathstr, name, ext] = fileparts(fname);
nombredesc = sprintf('%s_des_def.bmp',name);

%Guarda el archivo descomprimido
imwrite(Xrec, nombredesc);

% ---------------------------------------------------------------------------------
% PRESENTACIÓN DE LOS RESULTADOS
% ---------------------------------------------------------------------------------

% Tiempo de ejecución
tiempo=cputime-tc;

% Vamos a comparar el resultado de la descompresión con la imagen origen

s = imfinfo(nombredesc); 
TD = s.FileSize; % Obtenemos el tamaño de la descompresión

% Obtenemos el nombre de la imagen origen ya que se ha concatenado
% la calidad usada en su compresión. De forma que del formato
% <nombre>_<caliQ>.hud, obtenemos <nombre>.bmp
nombre_origen = split(name,'_');
nombre_origen = convertStringsToChars(string(nombre_origen(1)));
nombre_origen = strcat(nombre_origen, '.bmp'); 
X_origen = imread(nombre_origen); 
[m_o, n_o, p_o] = size(X_origen);

s = imfinfo(nombre_origen); 
TO = s.FileSize; % Tamaño original

% CÁLCULO DEL RC
% ------------------------------
% Obtenemos el espacio que ocupan en bytes
[uCodedY, ultlY] = bits2bytes(CodedY);
[uCodedCb, ultlCb] = bits2bytes(CodedCb);
[uCodedCr, ultlCr] = bits2bytes(CodedCr);
% TDatos: 3 canales * (longitud + longitud de su último segmento de sbytes) + datos 
TDatos= 3 *(4+1)+ length(uCodedY) + length(uCodedCb) + length(uCodedCr);
% TCabecera = m + n + caliQ + mamp + namp 
TCabecera= 4 + 4 + 2 + 4 + 4;
% Tamaño del fichero comprimido
TC = TCabecera + TDatos;

% Mostrar la(s) Relacion(es) de compresión
RC = 100*(TO-TC)/TO; % TASA (rate) de compresión.


% CÁLCULO DEL MSE
% ------------------------------
MSE = (sum(sum(sum((double(Xrec) - double(X_origen)).^2))))/(m*n*3);


% Test visual
if mostrar_imagenes
    
    %Imagen original
    figure('Units','pixels','Position',[100 100 n_o m_o]);
    set(gca,'Position',[0 0 1 1]);
    image(X_origen); 
    set(gcf,'Name','Imagen original');
    
    %Imagen descomprimida
    figure('Units','pixels','Position',[100 100 n m]);
    set(gca,'Position',[0 0 1 1]);
    image(Xrec);
    set(gcf,'Name','Imagen reconstruida');
    
end


% Resultados
if disptext
    
    disp('-----------------');
    disp(sprintf('%s %s', 'Archivo comprimido:', fname));
    disp(sprintf('%s %d', 'Tamaño comprimido =', TC));
    disp(sprintf('%s %s', 'Archivo descomprimido:', nombredesc));
    disp(sprintf('%s %d', 'Tamaño descomprimido =', TD));
    disp(sprintf('%s %d %s %d', 'Tamaño cabecera y código =', TCabecera, ',  Tamaño datos=', TDatos));
    disp(sprintf('\n%s %2.2f %s', 'RC =', RC, '%.'));
    disp(sprintf('%s %2.2f %s', 'MSE =', MSE, '%.'));
    disp(sprintf('\n%s %2.2f %s', 'Tiempo de ejecución =', tiempo, ' segundos'));
    disp('--------------------------------------------------'); 
    
end 
 
end


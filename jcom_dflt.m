% Ejercicio 1 - GUIÓN DE PRÁCTICAS 4 
%--------------------------------------


function RC = jcom_dflt(fname, caliQ)

% Entradas:
%  fname: Un string con nombre de archivo, incluido sufijo.
%         Admite BMP y JPEG, indexado y truecolor.
%  caliQ: Factor de calidad (entero positivo >= 1)
%         100: calidad estandar
%         >100: menor calidad
%         <100: mayor calidad
% Salidas:
%  RC: Relación de compresión. 

disptext=1; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Función jcom_dflt:');
end

% Instante inicial
tc=cputime;

% Lee el archivo de imagen BMP que se va a comprimir con la función imlee, 
% que convierte la imagen RGB al espacio de color YCbCr y amplia dimensiones
% a múltiplos de 8. En X tendremos la imagen original en RGB y en Xamp la 
% nueva imagen en espacio YCbCr.
[X, Xamp, tipo, m, n, mamp, namp, TO] = imlee(fname);

% Calcula la tranfsormada DCT bidimensional en bloques de 8 x 8 píxeles.
Xtrans = imdct(Xamp);

% Cuantización de coeficientes, obteniendo la matriz de etiquetas Xlab.
Xlab = quantmat(Xtrans, caliQ);

% Genera un scan por cada componente de color. Esta función reordena en 
% zigzag cada bloque 8x8 de cada componente de color y obtiene una matriz 
% reordenada Xscan.
XScan = scan(Xlab);

% Codifica en binario los tres scans, usando Huffman por defecto.
[CodedY, CodedCb, CodedCr] = EncodeScans_dflt(XScan); 

% Obtenemos el espacio que ocupan en bytes los componentes para la posterior 
% descompresión.
[uCodedY, ultlY] = bits2bytes(CodedY);
[uCodedCb, ultlCb] = bits2bytes(CodedCb);
[uCodedCr, ultlCr] = bits2bytes(CodedCr);

uultlY = uint8(ultlY);
uultlCb = uint8(ultlCb);
uultlCr = uint8(ultlCr);

lenCodedY = uint32(length(uCodedY));
lenCodedCb = uint32(length(uCodedCb));
lenCodedCr = uint32(length(uCodedCr));

uMamp = uint32(mamp);
uNamp = uint32(namp);
uCaliQ = uint16(caliQ);
uN = uint32(n);
uM = uint32(m);

% Genera el nombre del archivo comprimido <name>_<caliQ>.hud
[pathstr, name, ext] = fileparts(fname);
nombrecomp = sprintf('%s_%d.hud',name, caliQ);

% Escribimos los datos en el archivo comprimido, siguiendo un orden de
% almacenamiento.

fid = fopen(nombrecomp, 'w');
fwrite(fid, lenCodedY, 'uint32');
fwrite(fid, uultlY, 'uint8');
fwrite(fid, uCodedY, 'uint8');
fwrite(fid, lenCodedCb, 'uint32');
fwrite(fid, uultlCb, 'uint8');
fwrite(fid, uCodedCb, 'uint8');
fwrite(fid, lenCodedCr, 'uint32');
fwrite(fid, uultlCr, 'uint8');
fwrite(fid, uCodedCr, 'uint8');
fwrite(fid, uMamp, 'uint32');
fwrite(fid, uNamp, 'uint32');
fwrite(fid, uCaliQ, 'uint16');
fwrite(fid, uM, 'uint32');
fwrite(fid, uN, 'uint32');
fclose(fid);

% ---------------------------------------------------------------------------------
% PRESENTACIÓN DE LOS RESULTADOS
% ---------------------------------------------------------------------------------

% Tiempo de ejecución
tiempo=cputime-tc;

% CÁLCULO DEL RC
% ------------------------------
% TDatos: 3 canales * (longitud + longitud de su último segmento de sbytes) + datos 
TDatos= 3 *(4+1)+ length(uCodedY) + length(uCodedCb) + length(uCodedCr);
% TCabecera = m + n + caliQ + mamp + namp 
TCabecera= 4 + 4 + 2 + 4 + 4;
% Tamaño del fichero comprimido
TC = TCabecera + TDatos;

% Mostrar la(s) Relacion(es) de compresión
RC = 100*(TO-TC)/TO; % TASA (rate) de compresión.

if disptext

    % Resultados
    disp('-----------------');
    disp(sprintf('%s %s', 'Archivo original:', fname));
    disp(sprintf('%s %d', 'Tamaño original =', TO));
    disp(sprintf('%s %s', 'Archivo comprimido:', nombrecomp));
    disp(sprintf('%s %d', 'Tamaño comprimido =', TC));
    disp(sprintf('%s %d %s %d', 'Tamaño cabecera y código =', TCabecera, ',  Tamaño datos=', TDatos));
    disp(sprintf('\n%s %2.2f %s', 'RC =', RC, '%.'));
    disp(sprintf('\n%s %2.2f %s', 'Tiempo de ejecución =', tiempo, ' segundos'));

    if RC < 0
        disp('El archivo original es demasiado pequeño. No se comprime.');
    end
    
    disp('--------------------------------------------------'); 
end

end 


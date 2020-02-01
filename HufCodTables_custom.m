% Ejercicio 2 - GUIÓN DE PRÁCTICAS 4 
%--------------------------------------


function [ehuf,BITS,HUFFVAL] = HufCodTables_custom(FREQ) 

% HufCodTables_custom: Genera tablas de codificación a medida

% Entradas: 
%   FREQ: Vector columna de 256 enteros con frecuencias de los enteros presentes 
%   Las tablas de crominancia C_DC y C_AC se aplican, tanto a Cb, como a Cr
% Salidas: 
%   BITS: Vector columna con el nº de palabras codigo de cada longitud (de 1 hasta 16)
%   HUFFVAL: Vector columna con los mensajes en orden creciente de longitud de palabra
%       En HUFFVAL estan solo los mensajes presentes en la secuencia
%       Su longitud es el nº de mensajes distintos en la secuencia
%       Los mensajes son enteros entre 0 y 255
%   ehuf: Es la concatenacion [EHUFCO EHUFSI], donde;
%     EHUFCO: Vector columna con palabras codigo expresadas en decimal
%       Esta indexado por los 256 mensajes de la fuente, 
%       en orden creciente de estos (offset 1)
%     EHUFSI: Vector columna con las longitudes de todas las palabras codigo
%       Esta indexado por los 256 mensajes de la fuente, 
%       en orden creciente de estos (offset 1)



% Construye Tablas de Especificación Huffman a través de la frecuencia FREQ.
[BITS, HUFFVAL] = HSpecTables(FREQ);

% Construye Tablas del Código Huffman.
[HUFFSIZE, HUFFCODE] = HCodeTables(BITS, HUFFVAL);

% Construye Tablas de Codificación Huffman.
[EHUFCO, EHUFSI] = HCodingTables(HUFFSIZE, HUFFCODE, HUFFVAL); 
ehuf = [EHUFCO EHUFSI]; 

end
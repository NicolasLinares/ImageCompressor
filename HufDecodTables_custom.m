% Ejercicio 2 - GUIÓN DE PRÁCTICAS 4 
%--------------------------------------


function [MINCODE,MAXCODE,VALPTR] = HufDecodTables_custom(BITS, HUFFVAL)

% HufDecodTables_custom: Genera tablas de decodificación a medida

% Entradas
%   BITS: Vector columna con el nº de palabras codigo de cada longitud (de 1 hasta 16)
%   HUFFVAL: Vector columna con los mensajes en orden creciente de longitud de palabra
%       En HUFFVAL estan solo los mensajes presentes en la secuencia
%       Su longitud es el nº de mensajes distintos en la secuencia
%       Los mensajes son enteros entre 0 y 255
% Salidas: 
%   MINCODE: Codigo mas pequeño de cada longitud
%       Vector columna g x 1, con g igual a nº de grupos de longitdes
%   MAXCODE: Codigo mas grande de cada longitud
%       Vector columna g x 1, con g igual a nº de grupos de longitdes
%   VALPTR: Indice al primer valor de HUFFVAL que
%       se decodifica con una palabra de long. i
%       Vector columna g x 1, con g igual a nº de grupos de longitdes


% Construye Tablas del Código Huffman.
[HUFFSIZE, HUFFCODE] = HCodeTables(BITS, HUFFVAL); 

% Construye Tablas de Decodificación Huffman. 
[MINCODE,MAXCODE,VALPTR] = HDecodingTables(BITS, HUFFCODE); 

end
% Ejercicio 2 - GUI�N DE PR�CTICAS 4 
%--------------------------------------


function [MINCODE,MAXCODE,VALPTR] = HufDecodTables_custom(BITS, HUFFVAL)

% HufDecodTables_custom: Genera tablas de decodificaci�n a medida

% Entradas
%   BITS: Vector columna con el n� de palabras codigo de cada longitud (de 1 hasta 16)
%   HUFFVAL: Vector columna con los mensajes en orden creciente de longitud de palabra
%       En HUFFVAL estan solo los mensajes presentes en la secuencia
%       Su longitud es el n� de mensajes distintos en la secuencia
%       Los mensajes son enteros entre 0 y 255
% Salidas: 
%   MINCODE: Codigo mas peque�o de cada longitud
%       Vector columna g x 1, con g igual a n� de grupos de longitdes
%   MAXCODE: Codigo mas grande de cada longitud
%       Vector columna g x 1, con g igual a n� de grupos de longitdes
%   VALPTR: Indice al primer valor de HUFFVAL que
%       se decodifica con una palabra de long. i
%       Vector columna g x 1, con g igual a n� de grupos de longitdes


% Construye Tablas del C�digo Huffman.
[HUFFSIZE, HUFFCODE] = HCodeTables(BITS, HUFFVAL); 

% Construye Tablas de Decodificaci�n Huffman. 
[MINCODE,MAXCODE,VALPTR] = HDecodingTables(BITS, HUFFCODE); 

end
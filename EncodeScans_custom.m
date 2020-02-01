% Ejercicio 2 - GUIÓN DE PRÁCTICAS 4 
%--------------------------------------


function [CodedY, CodedCb, CodedCr, BITS_Y_DC, HUFFVAL_Y_DC, BITS_Y_AC, HUFFVAL_Y_AC, BITS_C_DC, HUFFVAL_C_DC, BITS_C_AC, HUFFVAL_C_AC] = EncodeScans_custom(XScan)

% EncodeScans_custom: Codifica en binario los tres scan usando Huffman a medida

% Entradas:
%  XScan: Scans de luminancia Y y crominancia Cb y Cr: Matriz mamp x namp X 3
%  compuesta de:
%   YScan: Scan de luminancia Y: Matriz mamp x namp
%   CbScan: Scan de crominancia Cb: Matriz mamp x namp
%   CrScan: Scan de crominancia Cr: Matriz mamp x namp
% Salidas:
%   CodedY: String binario con scan Y codificado
%   CodedCb: String binario con scan Cb codificado
%   CodedCr: String binario con scan Cr codificado
%   BITS_*: Vectores columna con el nº de palabras código de cada longitud (de 1 hasta 16)
%	HUFFVAL_*: Vectores columna con los mensajes en orden creciente de longitud de palabra

disptext=0; % Flag de verbosidad 
if disptext 
    disp('--------------------------------------------------'); 
    disp('Función EncodeScans_custom:'); 
end

% Instante inicial 
tc=cputime;

% Separa las matrices bidimensionales para procesarlas.
YScan = XScan(:,:,1); 
CbScan = XScan(:,:,2); 
CrScan = XScan(:,:,3);

% Recolectar valores a codificar. Se generan dos tablas por scan:
%   nn_DC_CP: Contiene los pares categoría y posición (C, P) para las diferencias
%           DIFF entre etiquetas DC de bloques adyacentes del scan nn.
%   nn_AC_ZCP: Contiene los valores (Z, C, P) para las etiquetas AC del scan:
%           Z: Nº de ceros previos a la etiqueta.
%           C: Categoría de la etiqueta.
%           P: Posición de la etiqueta.
[Y_DC_CP, Y_AC_ZCP] = CollectScan(YScan); 
[Cb_DC_CP, Cb_AC_ZCP] = CollectScan(CbScan); 
[Cr_DC_CP, Cr_AC_ZCP] = CollectScan(CrScan);

% Obtiene las frecuencias de categorías o pares ZC.
FREQ_Y_DC = Freq256(Y_DC_CP(:,1)); 
FREQ_Y_AC = Freq256(Y_AC_ZCP(:,1)); 
FREQ_C_DC = Freq256([Cb_DC_CP(:,1);Cr_DC_CP(:,1)]); 
FREQ_C_AC = Freq256([Cb_AC_ZCP(:,1);Cr_AC_ZCP(:,1)]);

% ---------------------------------------------------------------------------------
% GENERA TABLAS HUFFMAN DE CODIFICACIÓN A MEDIDA
% ---------------------------------------------------------------------------------

% Construye las tablas Huffman para Luminancia y Crominancia mediante
% las frecuencias calculadas en el paso anterior.
% La variable ehuf_X_X es la concatenación [EHUFCO EHUFSI].

% Tablas de luminancia: 
% Tabla Y_DC 
[ehuf_Y_DC,BITS_Y_DC,HUFFVAL_Y_DC] = HufCodTables_custom(FREQ_Y_DC); 
% Tabla Y_AC 
[ehuf_Y_AC,BITS_Y_AC,HUFFVAL_Y_AC] = HufCodTables_custom(FREQ_Y_AC); 

% Tablas de crominancia: 
% Tabla C_DC 
[ehuf_C_DC,BITS_C_DC,HUFFVAL_C_DC] = HufCodTables_custom(FREQ_C_DC); 
% Tabla C_AC 
[ehuf_C_AC,BITS_C_AC,HUFFVAL_C_AC] = HufCodTables_custom(FREQ_C_AC);

% Codifica en binario cada Scan. 
% Las tablas de crominancia, ehuf_C_DC y ehuf_C_AC, se aplican, tanto a Cb,
% como a Cr.
CodedY = EncodeSingleScan(YScan, Y_DC_CP, Y_AC_ZCP, ehuf_Y_DC, ehuf_Y_AC); 
CodedCb = EncodeSingleScan(CbScan, Cb_DC_CP, Cb_AC_ZCP, ehuf_C_DC, ehuf_C_AC); 
CodedCr = EncodeSingleScan(CrScan, Cr_DC_CP, Cr_AC_ZCP, ehuf_C_DC, ehuf_C_AC);

% Tiempo de ejecución 
e=cputime-tc;

if disptext 
    disp('Componentes codificadas en binario'); 
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e)); 
    disp('Terminado EncodeScans_custom'); 
end
end
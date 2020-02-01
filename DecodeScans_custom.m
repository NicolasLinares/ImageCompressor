% Ejercicio 2 - GUIÓN DE PRÁCTICAS 4 
%--------------------------------------


function XScanrec=DecodeScans_custom(CodedY, CodedCb, CodedCr, tam, BITS_Y_DC, HUFFVAL_Y_DC, BITS_Y_AC, HUFFVAL_Y_AC, BITS_C_DC, HUFFVAL_C_DC, BITS_C_AC, HUFFVAL_C_AC)

% DecodeScans_custom: Decodifica los tres scans binarios usando las tablas Huffman a medida

% Entradas:
%   CodedY: String binario con scan Y codificado
%   CodedCb: String binario con scan Cb codificado
%   CodedCr: String binario con scan Cr codificado
%   tam: Tamaño del scan a devolver [mamp namp]
%   BITS_*: Vectores columna con el nº de palabras código de cada longitud (de 1 hasta 16)
%	HUFFVAL_*: Vectores columna con los mensajes en orden creciente de longitud de palabra
% Salidas:
%  XScanrec: Scans reconstruidos de luminancia Y y crominancia Cb y Cr: Matriz mamp x namp X 3

disptext=0; % Flag de verbosidad 
if disptext 
    disp('--------------------------------------------------'); 
    disp('Función DecodeScans_custom:'); 
end

% Instante inicial 
tc=cputime;

% ---------------------------------------------------------------------------------
% GENERA TABLAS HUFFMAN DE DECODIFICACIÓN A MEDIDA
% ---------------------------------------------------------------------------------

% Construye las tablas Huffman para Luminancia y Crominancia.

% Tablas de luminancia: 
% Tabla Y_DC 
[mincode_Y_DC,maxcode_Y_DC,valptr_Y_DC] = HufDecodTables_custom( BITS_Y_DC, HUFFVAL_Y_DC); 
% Tabla Y_AC 
[mincode_Y_AC,maxcode_Y_AC,valptr_Y_AC] = HufDecodTables_custom( BITS_Y_AC,HUFFVAL_Y_AC); 

% Tablas de crominancia:
% Tabla C_DC 
[mincode_C_DC,maxcode_C_DC,valptr_C_DC] = HufDecodTables_custom( BITS_C_DC, HUFFVAL_C_DC); 
% Tabla C_AC 
[mincode_C_AC,maxcode_C_AC,valptr_C_AC] = HufDecodTables_custom( BITS_C_AC, HUFFVAL_C_AC);

% Decodifica en binario cada Scan.
% Las tablas de crominancia se aplican, tanto a Cb, como a Cr.
YScanrec = DecodeSingleScan(CodedY,mincode_Y_DC,maxcode_Y_DC, valptr_Y_DC,HUFFVAL_Y_DC,mincode_Y_AC,maxcode_Y_AC,valptr_Y_AC, HUFFVAL_Y_AC,tam); 
CbScanrec = DecodeSingleScan(CodedCb,mincode_C_DC,maxcode_C_DC, valptr_C_DC,HUFFVAL_C_DC,mincode_C_AC,maxcode_C_AC,valptr_C_AC, HUFFVAL_C_AC,tam); 
CrScanrec = DecodeSingleScan(CodedCr,mincode_C_DC,maxcode_C_DC, valptr_C_DC,HUFFVAL_C_DC,mincode_C_AC,maxcode_C_AC,valptr_C_AC, HUFFVAL_C_AC,tam);

% Reconstruye la matriz de 3-D 
XScanrec = cat(3,YScanrec,CbScanrec,CrScanrec);

% Tiempo de ejecución 
e=cputime-tc;

if disptext 
    disp('Scans decodificados'); 
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e)); 
    disp('Terminado DecodeScans_custom'); 
end
end
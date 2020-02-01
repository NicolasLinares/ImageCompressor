
% Imágenes y factores de calidad con los que se va a experimentar
imagenes = ["img01" "img02" "img03" "img04" "img05" "img06"];
calidades = [1 25 75 100 250 500];


for img = imagenes
    % En estas listas se van a ir guardando los datos para cada imagen y así
    % poder crear la gráfica
    lista_RC_dflt = [];
    lista_MSE_dflt = [];
    lista_RC_custom = [];
    lista_MSE_custom = [];
    
    % Le pasamos a las funciones compresor el nombre de la imagen original
    nombre_orig = sprintf('%s.bmp',img);

    for caliQ = calidades 
        
        % Al nombre de la imagen le concatenamos la calidad con la que se
        % va a comprimir (la extensión la añadiremos después para cada método)    
        nombre_sinExt = sprintf('%s_%d',img, caliQ);
        
        %----------------------------
        %   HUFFMAN POR DEFECTO
        %----------------------------
        
        RC_dflt = jcom_dflt(nombre_orig, caliQ);
        
        % Añadimos la extensión de la imagen del método por defecto
        comprimida_dflt = sprintf('%s.hud',nombre_sinExt);
        
        [MSE_dflt, RC_dflt] = jdes_dflt(comprimida_dflt);
        
        lista_RC_dflt(end+1) = RC_dflt;
        lista_MSE_dflt(end+1) = MSE_dflt;
        
        %----------------------------
        %   HUFFMAN A MEDIDA
        %----------------------------
        
        RC_custom = jcom_custom(nombre_orig, caliQ);
        
        % Añadimos la extensión de la imagen del método a medida
        comprimida_custom = sprintf('%s.huc',nombre_sinExt);
        
        [MSE_custom, RC_custom] = jdes_custom(comprimida_custom);
        
        lista_RC_custom(end+1) = RC_custom;
        lista_MSE_custom(end+1) = MSE_custom;
        
    end
    
    % Dibujamos las gráficas
    figure;
    semilogy(lista_RC_dflt, lista_MSE_dflt, '-.p', lista_RC_custom, lista_MSE_custom, '-.d');
    grid on;
    title(sprintf('%s "%s"\n Factores de calidad: [1, 25, 75, 100, 250, 500]', 'MSE vs RC para la imagen', nombre_orig)); 
    xlabel('RC (%)'); 
    ylabel('MSE');
    legend('Default', 'Custom', 'Location','northwest');
    
end

disp('##########################');
disp('Fin del programa pruebas.m');
disp('##########################');


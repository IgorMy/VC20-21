%% Limpieza inicial
clear, clc, close all;

%% Adicción de carpetas
addpath('Funciones');

%% Ejecución del programa

% Sin la ampliación
Nombre = "Test_12.jpg"; % Todas las matriculas son de 7 caracteres menos Test_(02,08,09,10 y 20) y Training_(03).
Numero_Objetos = 7;
Cadena = Funcion_Reconoce_Matricula(Nombre, Numero_Objetos);


% Con la ampliación
Nombre = "04.JPG"; % Todas las matriculas son de 7 caracteres menos 06, 07 y 12.
Numero_Objetos = 7;
Cadena = Funcion_Reconoce_Matricula_con_ampliacion(Nombre, Numero_Objetos);

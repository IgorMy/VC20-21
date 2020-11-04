%% Cosas basicas de matlab

% Para escribir un comentario se usa %

% Para saber de uncomandose usa
type nombre_comando
help nombre_comando
doc nombre_comando

% Antes de iniciar un fichero .m es conviniente limpiar todo
restoredefaultpath % limpiar directorios activos
clear % borra todas las variables activas
clc % borra la ventana de comandos
close all % cierra todas las ventanas abiertas

% Información de una variable
whos nombre_de_variable 

% sumar columnas de la matriz A
sum(A)

% Inversa de una matriz
inv(A)

% Diagonal de una matriz A
diag(A)

% se usan : para un subconjunto y end que es la ultima columna

% Generación de matrices
zeros(n) % matriz de ceros de n dimensiones
ones(n) % matriz de unos de n dimensiones
eye(n) % matriz identidad de n dimensiones

% numeros aleatorios
rand
randn

% Cargar fichero
load nombre_de_fichero.mat

% Valor medio de por columnas de la matriz X
mean(X)

% Desviación tipica por columnas de la matriz X
std(X)

% Tipos de datos estandares
uint8, double, int, logical

inf % infinito
NaN % Not a Number

'hola' % cadena de texto

% Muestra en una ventana tipo figure una grafica
plot(X)
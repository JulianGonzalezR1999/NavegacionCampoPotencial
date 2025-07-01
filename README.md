# 🤖Robótica Movil 2025-1

## 🪶Autores
* Julian Andres Gonzalez Reina
* Emily Angelica Villanueva Serna
* Elvin Andres Corredor Torres

## ℹ️Navegacion por Campo Potencial (ROBOT ePuck)

### 🏁Objetivos
* Ejecutar las etapas necesarias para la solución y simulación de una misión de robot con ruedas utilizando el método de navegación por campo potencial.

### Modelo cinematico
Para realizar el modelo cinematico se toma el radio de la rueda como 0.02122 m y el espacio entre las ruedas , es decir la trocha como 0.053 m . El modelo cinematico para el robot ePuck es el siguiente 

Modelo cinemático del ePuck

- v = (r/2) * (v_r + v_l)
- ω = (r/L) * (v_r - v_l)

Modelo Cinemático Inverso 

- v_r = (2v + ωL) / (2r)
- v_l = (2v - ωL) / (2r)

### Mapas


<p align="center">
  <img src="https://github.com/user-attachments/assets/54d38593-0935-4a7b-bf25-1f71a3dd2b8f" alt="Mapa " width="500"/>
</p>

### Navegación por Campo Potencial


<p align="center">
  <img src="https://github.com/user-attachments/assets/c37a3248-059b-4067-bcb6-c6f07a720a5c" alt="Mapa " width="500"/>
</p>

### Planeacion PRM

Una vez con el mapa inflado utilizamos el algoritmo PRM para realizar la planeacion de la ruta asignada (Inicio Superior Izquieda -Salida Inferior Derecha). Para este algoritmo utilizamos la funcion "mobileRobotPRM" la cual establece dentro de un mapa una serie de nodos conectados y junto con la funcion "findpath" calcula una ruta óptima entre dos puntos usando el grafo generado por el planificador PRM (mobileRobotPRM). Los valores de los parametros usados se listan a continuacion:

* prm.NumNodes = 300
* prm.ConnectionDistance = 0.2
* StartLocation = [0, 1.2]
* EndLocation = [1.2, 0]

La ruta optima encontrada por el algoritmo segun los parametros se presenta en la siguiente tabla.

| Index |    X    |    Y    |
|:-----:|:-------:|:-------:|
|   1   | 0.0000  | 1.2000  |
|   2   | 0.0368  | 1.2017  |
|   3   | 0.2660  | 1.1570  |
|   4   | 0.2986  | 1.1057  |
|   5   | 0.4915  | 1.1414  |
|   6   | 0.7007  | 1.0461  |
|   7   | 0.7208  | 1.1061  |
|   8   | 0.7930  | 1.1318  |
|   9   | 0.8945  | 1.1203  |
|  10   | 0.9111  | 0.9511  |
|  11   | 0.9288  | 0.9027  |
|  12   | 1.0564  | 0.8777  |
|  13   | 1.2170  | 0.9440  |
|  14   | 1.2037  | 0.8203  |
|  15   | 1.2053  | 0.6428  |
|  16   | 1.2240  | 0.3914  |
|  17   | 1.1581  | 0.3726  |
|  18   | 1.1279  | 0.3412  |
|  19   | 1.1535  | 0.2361  |
|  20   | 1.2158  | 0.0073  |
|  21   | 1.2000  | 0.0000  |

### Función de coste de PRM
La funcion de costo que se utiliza para cada arista del roadmap es la distancia euclídea entre los dos nodos conectados. "path = findpath(prm, startLocation, endLocation);"
Por defecto, `mobileRobotPRM` emplea la **distancia euclídea** como función de coste.

El planificador:
* Construye un grafo cuyos vértices son las muestras en el espacio libre del mapa inflado.
* Conecta cada par de nodos cuya separación sea menor o igual a ConnectionDistance.
* Asigna a cada arista un peso igual a la distancia euclídea entre sus dos extremos.
* Ejecuta Dijkstra (o un algoritmo equivalente de camino mínimo) sobre ese grafo para encontrar la ruta de coste mínimo.

Finalmente la funcion de coste corresponde a: Coste(path) = Σ_{i=1 to N-1} √[ (x_{i+1} - x_i)^2 + (y_{i+1} - y_i)^2 ]
Donde cada término es la distancia euclídea entre el nodo i y el nodo i+1.  
A continuacion se presenta las graficas del algoritmo PRM y la ruta encontrada.

| Fig 3 **Grafos algoritmo PRM y ruta solucion** |
|:-----------------:|
|![Figura3](https://github.com/user-attachments/assets/82926b42-8b55-4b25-ac42-32bc4fa68336)|

### Planeacion PRM

De igual forma se realizaron pruebas con el algoritmo RRT. Para crear este planificador se uso la libreria de Matlab *plannerRRT* en la cual se consideran los siguientes parametros;
* planner.MaxIterations = 100000
* planner.MaxConnectionDistance = 0.5

A continuacion se presenta las graficas del algoritmo RRT y la ruta encontrada.
| Fig 4 **Grafos algoritmo RRT y ruta solucion** |
|:-----------------:|
|![Figura4](https://github.com/user-attachments/assets/93a33efd-4ecc-4d60-ab58-d5bf5542da0b)|

### Simulacion en CoppeliaSim

Una vez realizadas los algoritmos de planeacion integramos el mapa del laberinto a CoppeliaSim. Como se puede ver en la siguiente Figura.

| Fig 5 **Mapa del robot en CoppeliaSim ** |
|:-----------------:|
|![ROBOTCOPELIASIM](https://github.com/user-attachments/assets/19d366f5-53b1-4f0b-b317-54b1b292d00b)|

### Simulación Matlab y CoppeliaSim

Para la simulación se selecciona la ruta obtenida a travez del metodo PRM  y se utiliza el codigo  [CoppeliaMatlab.py](CoppeliaMatlab.m) y  el script en coppeliaSim [Mapa.ttt](Pruebagiro.ttt)

https://github.com/user-attachments/assets/b9a6431f-b54f-4d1b-bedf-6477636e013f

### Conclusiones
* Inflado de obstáculos y seguridad: Inflar el mapa en función del radio del robot (hábito imprescindibe) garantiza que las rutas generadas sean seguras, sin riesgo de colisión con las paredes.
* En PRM, NumNodes y ConnectionDistance regulan el equilibrio entre cobertura del espacio y coste del grafo.
* En RRT, MaxIterations y MaxConnectionDistance influyen en la velocidad de convergencia y la complejidad de la ruta.

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

Usando el algoritmo [Codigo_LidarScan_BuildMap.m](archivos_matlab/Codigo_LidarScan_BuildMap.m)

<p align="center">
  <img src="https://github.com/user-attachments/assets/54d38593-0935-4a7b-bf25-1f71a3dd2b8f" alt="Mapa " width="500"/>
</p>

### Navegación por Campo Potencial


<p align="center">
  <img src="https://github.com/user-attachments/assets/c37a3248-059b-4067-bcb6-c6f07a720a5c" alt="Mapa " width="500"/>
</p>


###  Gradiente del Campo Potencial


| Fig 1 **Mapa Original** | Fig 2**Mapa Inflado** |
|:-----------------:|:----------------:|
| ![MapaEscala](https://github.com/user-attachments/assets/9c5e2f23-ceb0-45de-bcd2-8113b2d115c7) | ![Mapa Sigmoid](https://github.com/user-attachments/assets/f28557e3-9cc1-49fa-a524-00fb24ede813) |

### Simulación en CoppeliaSim

<p align="center">
  <img src="https://github.com/user-attachments/assets/6e6eaf3d-70a7-4ce2-b102-103a9c7d7e38" alt="Mapa " width="500"/>
</p>



https://github.com/user-attachments/assets/9f0277a1-e887-4189-a2eb-15a5bc735281






| Fig 3 **Grafos algoritmo PRM y ruta solucion** |
|:-----------------:|
|![Figura3](https://github.com/user-attachments/assets/82926b42-8b55-4b25-ac42-32bc4fa68336)|



### Conclusiones
* Inflado de obstáculos y seguridad: Inflar el mapa en función del radio del robot (hábito imprescindibe) garantiza que las rutas generadas sean seguras, sin riesgo de colisión con las paredes.
* En PRM, NumNodes y ConnectionDistance regulan el equilibrio entre cobertura del espacio y coste del grafo.
* En RRT, MaxIterations y MaxConnectionDistance influyen en la velocidad de convergencia y la complejidad de la ruta.

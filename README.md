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

Usando el algoritmo para redimensionar los obstaculos suministrado en la guia del laboratorio [mapa.m](mapa.m) se multiplica el valor de K por 0.04 que seria el radio que abarca toda la zona del robot epuck incluyendo sus ruedas , dando como resultado la siguiente imagen .

<p align="center">
  <img src="https://github.com/user-attachments/assets/54d38593-0935-4a7b-bf25-1f71a3dd2b8f" alt="Mapa " width="500"/>
</p>

### Navegación por Campo Potencial

Para la navegación por campo potencial se tienen en cuenta las ecuaciones de repulsion y atraccion .

Fuerza de atracción

 $$U_{att}(q)= \frac{1}{2}\zeta \left\|q-q_f \right\|^2$$

 $$F_{att}(q)= -\triangledown  U_{att}(q)$$

Fuerza de repulsión 

$$ \frac{1}{2}\eta \left ( \frac{1}{\rho (q)}-\frac{1}{Q^*} \right )^2 $$ 

cuando 

$$, \rho (q)\leq Q^*  $$

$$ 0 , \rho (q)> Q^* $$

$$F_{rep}(q)= -\triangledown  U_{rep}(q)$$

Gradiente total 

$$ F_{total}= F_{att} + \Sigma F_{rep} $$

En la siguiente gráfica se muestran las trayectorias resultantes a partir de la suma de gradientes utilizando el codigo [Trayectorias.m](AlgoritmoTrayectoriasDiferentes.m)

<p align="center">
  <img src="https://github.com/user-attachments/assets/c37a3248-059b-4067-bcb6-c6f07a720a5c" alt="Mapa " width="500"/>
</p>

Se ajusta el algoritmo mencionado anteriormente para lograr que el robot cumpla su objetivo y realice la trayectoria hasta la meta

|Parámetro|Valor|Descripción|
|----|------|-----------|
|Zeta|50|	Atracción a la meta|
|eta|0.01|Repulsión de obstáculos|
|dsStar|0.3|Umbral atracción|
|Qstar|0.22|Alcance repulsión|


###  Gradiente del Campo Potencial

Las siguientes imagenes estan elaborados con el código [Campo Potencial.m](CampoPotencialGrafica.m) y [Gradiente.m](CampoPotencial.m) , la imágen del lado izquierdo es la representación en escala logarítimica de la atracción y repulsión que ejerce la meta y los obstaculos respectivamente , mientras que la imágen de la derecha intenta mostrar los vectores de repulsión y atracción usando la función sigmoidal 
Función sigmoidal

$$ \frac{1}{1+e^{-x}} $$

| Fig 1 **Mapa Original** | Fig 2**Mapa Inflado** |
|:-----------------:|:----------------:|
| ![MapaEscala](https://github.com/user-attachments/assets/9c5e2f23-ceb0-45de-bcd2-8113b2d115c7) | ![Mapa Sigmoid](https://github.com/user-attachments/assets/f28557e3-9cc1-49fa-a524-00fb24ede813) |

### Simulación en CoppeliaSim
Para la simulación en coppeliaSim se agregan cilindros correspondientes a los obstaculos y se fijan con un force sensor , la ubicación y radio de los obstaculos estan dados por el código [mapa.m](mapa.m) , la demostración se encuentra en la siguiente imágen donde el robot tiene la sigiente pose [-0.36,-0.36,45]
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

# 🤖Robótica Movil 2025-1

## 🪶Autores
* Julian Andres Gonzalez Reina
* Elvin Andres Corredor Torres
* Emily Angelica Villanueva Serna

## ℹ️Navegacion por Campo Potencial (ROBOT ePuck)

### 🏁Objetivos
* Ejecutar las etapas necesarias para la solución y simulación de una misión de robot con ruedas utilizando el método de navegación por campo potencial.

### Modelo cinemático
Para realizar el modelo cinemático se toma el radio de la rueda como 0.02122 m y el espacio entre las ruedas, es decir la trocha como 0,053 m. El modelo cinemático para el robot e-puck es el siguiente 

Modelo cinemático del e-puck

- v = (r/2) * (v_r + v_l)
- ω = (r/L) * (v_r - v_l)

Modelo Cinemático Inverso 

- v_r = (2v + ωL) / (2r)
- v_l = (2v - ωL) / (2r)

### Mapas

Usando el algoritmo para redimensionar los obstáculos suministrado en la guía del laboratorio [mapa.m](mapa.m) se multiplica el valor de K por 0,04 que sería el radio que abarca toda la zona del robot e-puck incluyendo sus ruedas, dando como resultado la siguiente imagen.

<p align="center">
  <img src="https://github.com/user-attachments/assets/54d38593-0935-4a7b-bf25-1f71a3dd2b8f" alt="Mapa " width="500"/>
</p>

### Navegación por Campo Potencial

Para la navegación por campo potencial se tienen en cuenta las ecuaciones de repulsión y atracción .

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

En la siguiente gráfica se muestran las trayectorias resultantes a partir de la suma de gradientes utilizando el código [Trayectorias.m](AlgoritmoTrayectoriasDiferentes.m)

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

Las siguientes imágenes están elaborados con el código [Campo Potencial.m](CampoPotencialGrafica.m) y [Gradiente.m](CampoPotencial.m) , la imagen del lado izquierdo es la representación en escala logarítmica de la atracción y repulsión que ejerce la meta y los obstáculos respectivamente, mientras que la imagen de la derecha intenta mostrar los vectores de repulsión y atracción usando la función sigmoidal.
Función sigmoidal

$$ \frac{1}{1+e^{-x}} $$

| Fig 1 **Mapa Original** | Fig 2**Mapa Inflado** |
|:-----------------:|:----------------:|
| ![MapaEscala](https://github.com/user-attachments/assets/9c5e2f23-ceb0-45de-bcd2-8113b2d115c7) | ![Mapa Sigmoid](https://github.com/user-attachments/assets/f28557e3-9cc1-49fa-a524-00fb24ede813) |

### Simulación en CoppeliaSim
Para la simulación en CoppeliaSim se agregan cilindros correspondientes a los obstáculos y se fijan con un force sensor, la ubicación y radio de los obstáculos están dados por el código [mapa.m](mapa.m), la demostración se encuentra en la siguiente imagen donde el robot tiene la siguiente pose [-0.36,-0.36,45]
<p align="center">
  <img src="https://github.com/user-attachments/assets/6e6eaf3d-70a7-4ce2-b102-103a9c7d7e38" alt="Mapa " width="500"/>
</p>

Finalmente, el siguiente video hace la demostración del movimiento del robot para intentar seguir la trayectoria generada para una orientación de 45 grados.

https://github.com/user-attachments/assets/9f0277a1-e887-4189-a2eb-15a5bc735281



### Conclusiones
* Una de las dificultades más notorias para realizar esta navegación fue el hecho de tener que cuadrar parámetros a prueba y error para lograr que el robot lograra cumplir con su misión. Al inicio si la repulsión era muy grande el robot solo avanzaba unos pocos milímetros y quedaba en un mínimo local donde dejaba de moverse asumiendo haber llegado al objetivo, por otra parte, en caso de tener una atracción muy grande la trayectoria pasaba por encima de los obstáculos. 
* Durante la simulación en CoppeliaSim a diferencia del código en Matlab, el robot hacia giros extraños como rebotando con los obstáculos por el efecto de repulsión, es una de las desventajas de utilizar este método de navegación, es que los parámetros son muy sensibles y pueden causar dinámicas no deseadas al momento de la implementación.
* Aunque el concepto es sencillo de entender es posible que en algunos casos pueda existir la posibilidad de no poder llegar o encontrar la meta así exista un camino disponible.
* En ese caso para el robot e-puck fue necesario colocar un parámetro de atracción muy grande respecto al de repulsión ya que con nuestro algoritmo siempre se quedaba en mínimos locales antes de llegar al objetivo, asumiendo que el problema estaba en los parámetros decidimos agrandar la atracción realizada por la meta para lograr cumplir con la misión.

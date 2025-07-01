# 🤖Robótica Movil 2025-1

## 🪶Autores
* Julian Andres Gonzalez Reina
* Elvin Andres Corredor Torres
* Emily Angelica Villanueva Serna

## ℹ️Navegacion por Campo Potencial (ROBOT e-puck)

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

De igual manera se realiza una simulación del sistema, pero en este caso con cinemática directa.

Para la resolución de esta tarea se buscaron las medidas del robot asignado para poder crear el mapa de obstáculos en Matlab, siendo los siguientes datos los correspondientes al robot e-puck.

Diámetro de Ruedas = 4 mm

Distancia entre Ruedas = 53 mm

Diámetro = 70 mm

Altura = 55 mm

Se determinan las ecuaciones de cinemática directa del robot de acuerdo a las velocidades angulares del robot.


![image-removebg-preview (1)](https://github.com/user-attachments/assets/8f17458c-2d36-4bdc-916a-7355bdaee6a8)

Y para resolver la posición y orientación del robot, usamos el método de integración de Euler, el cual fue el siguiente 

![image-removebg-preview (2)](https://github.com/user-attachments/assets/be92901e-9c28-4bb6-882c-c2cda68ec035)

Siendo
R: radio de las ruedas
L: distancia entre ruedas
ωR, ωL: velocidades angulares de la rueda derecha e izquierda
x, y: posición del robot
θ: orientación
dt: paso de tiempo

Posterior a esto se aplica el algoritmo arena2025.m para obtener el mapa de obstáculos como se ve a continuación.

![image](https://github.com/user-attachments/assets/35937b50-c8d1-415e-9ded-adbe7d0bf2fa)

Usando la función sigmoidal transformamos este mapa en un campo potencial repulsivo, también se agrega una repulsión en los bordes pensada para que el robot conozca los límites de movimiento sobre el que puede avanzar, en la visualización de este mapa se usan colores para identificar las zonas de mayor repulsión de campo en Matlab.


![image](https://github.com/user-attachments/assets/b266c3e7-8565-4700-a74e-5553cc34d0c2)


A continuación, se crea el campo potencial atractivo de la meta y se suman ambos campos para obtener el campo de potencial total.


![image](https://github.com/user-attachments/assets/9c798889-94b6-4b78-949e-26fa5dbd5397)

Este será el campo el cual el robot deberá utilizar para llegar a la meta. Luego de pruebas de simulación se logra llegar a las tres soluciones de salida, con los siguientes parámetros.

![image](https://github.com/user-attachments/assets/dac7a8de-6c7b-48a8-a681-499e54a1e761)

Estos valores fueron elegidos debido a varias características:
•	Un valor inicial de Lambda = 15 generaba un campo de repulsión más fuerte  a medida que se acercaba el robot, generando que en la condición de 30° el robot quedara girando sin poder llegar a la meta.
•	La distancia de repulsión se redujo para que el robot pudiera acercarse más a los obstáculos antes de ser desviado de su trayectoria.
•	Se aumentó la intensidad del campo atractivo, inicialmente en un valor Alpha = 0,01 en condiciones que nuevamente quedaba girando el robot sin llegar a la meta.

Con estas características se muestra a continuación los resultados obtenidos con los valores de ángulo inicial.

Trayectoria a 30°

![image](https://github.com/user-attachments/assets/80227c30-0d2d-4a2c-99f0-57fe9fea4b9c)

Trayectoria a 45°

![image](https://github.com/user-attachments/assets/9a923662-e58b-4614-8412-aaccd94f619d)

Trayectoria a 60°

![image](https://github.com/user-attachments/assets/df4be1e2-109f-4eee-949b-d8f42775b333)

Aunque no es muy visible la diferencia entre 30° y 45° esta se nota justamente al inicio, luego de esto el campo de repulsión de ambas toma la misma trayectoria, mientras que en la trayectoria a 60° si es visible la diferencia además de que en un punto queda girando el robot, esto conocido como un mínimo local, solucionado de manera que se le da un giro aleatorio para poder salir del mínimo local.




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

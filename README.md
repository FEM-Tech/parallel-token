# parallel-token
Programación de token highlighter haciendo uso de futures.

El programa tarda 58430 milisegundos (58 segundos) en leer y traducir todos los archivos de prueba que nos fueron proporcionados.


Segunda ejecución: 71373 milisegundos (71 segundos) en leer y traducir los archivos proporcionados


Al igual que en la implementación secuencial de la actividad pasada, en este programa, en el cual ahora se hace uso de “futures”, al no dividir el trabajo del programa en diferentes núcleos, la complejidad nuevamente es lineal y dependiente del número de archivos leídos, así como también de la longitud de estos archivos. Si el trabajo se dividiera en núcleos de procesamiento, la complejidad del trabajo del programa disminuiría y sería logarítmica, tomando menos tiempo real de ejecución la distribución del procesamiento en los múltiples núcleos.

Plasma en un breve reporte de una página las conclusiones de tu reflexión en los puntos 5 y 6. Agrega además una breve reflexión sobre las implicaciones éticas que el tipo de tecnología que desarrollaste pudiera tener en la sociedad.

Reflexión: Implicaciones éticas del programa

	La programación paralela permite optimizar los tiempos reales de ejecución de un programa, pues en esta se divide el procesamiento de una tarea en diferentes núcleos . Por lo tanto, esto conlleva implicaciones éticas, pues esto puede ser aplicado para ataques cibernéticos hacia computadoras, servidores, páginas web o redes, pues tomaría menos tiempo llevar a cabo un ataque debido a la distribución del procesamiento de un ataque en diferentes  núcleos. Por ejemplo, en un ataque DDoS, donde se utilizan máquinas zombies para atacar un sitio y que deje de funcionar, donde esta programación puede ser utilizada para disminuir el tiempo en que se lleva a cabo este ataque y además dividiendo la ejecución en múltiples equipos de terminales de cómputo.  

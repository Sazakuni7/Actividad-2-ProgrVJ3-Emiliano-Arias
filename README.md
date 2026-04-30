# AriasEmiliano Actividad 2

Proyecto de Godot para la Actividad 2 de Programacion de Videojuegos III.

## Controles

- Flechas: mover al jugador en modo topdown.
- Espacio: disparar.
- R: reiniciar la escena.

## Puntos cumplidos de la actividad

- Personaje controlable en modo topdown con movimiento en 8 direcciones.
- Movimiento suave mediante aceleracion, velocidad maxima y frenado.
- Movimiento diagonal normalizado para evitar mayor velocidad en diagonal.
- Deslizamiento por paredes usando `move_and_slide()`.
- Enemigos con patrullas propias y persecucion del jugador.
- Disparos instanciados desde una escena externa.
- Uso de `Area2D` para balas, zona de victoria y deteccion de contacto enemigo-jugador.
- Obstaculos moviles con `AnimatableBody2D`.
- Parametros de movimiento expuestos al editor para jugador y enemigos.
- Instanciado de escenas externas para balas, enemigos, cajas, obstaculos, zona de meta y cuerpos de enemigos derrotados.
- Objetos fisicos dinamicos empujables mediante `RigidBody2D`.
- Enemigos derrotados convertidos en cuerpos fisicos grises que ya no hacen danio y pueden empujarse.
- Comunicacion por seniales para derrota del jugador, enemigos eliminados y condicion de victoria.
- Condicion de victoria: eliminar todos los enemigos y entrar a la zona verde.
- Condicion de derrota: ser tocado por un enemigo activo.

## Referencias usadas

El proyecto toma como referencia la demo entregada por la catedra, especialmente en:

- Uso de `CharacterBody2D`.
- Variables exportadas para ajustar parametros desde el editor.
- Uso de seniales para comunicar eventos de juego.
- Uso de grupos como `"player"` y `"enemy"`.
- Areas conectadas por `body_entered`.
- Escena principal encargada de administrar condiciones de juego.

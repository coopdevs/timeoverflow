TimeOverflow
============

[![Build Status](https://travis-ci.org/coopdevs/timeoverflow.png)](https://travis-ci.org/coopdevs/timeoverflow)
[![Code Climate](https://codeclimate.com/github/timeoverflow/timeoverflow.png)](https://codeclimate.com/github/timeoverflow/timeoverflow)

Sistema de Banco de Tiempo.

Mira la nueva página de TimeOverflow: <http://coopdevs.github.io/timeoverflow/>

TimeOverflow es un software desarrollado de manera altruista para ofrecer un sistema que facilite la interacción
de los miembros y la gestión de los Bancos de Tiempo. El modelo sobre el que se trabaja está guiado por las necesidades de los Bancos de Tiempo
que hacen uso de él y está preparado para poder albergar varios Bancos de Tiempo en una sola instalación, para ello cuenta
con tres niveles de privilegios: superadmin, admin (solo gestiona un Banco) y miembros de un Banco.

TimeOverflow está dividido en 2 grandes bloques:
* **Sistema de gestión**
* **Red social y banca on-line**

*NOTA: Un Banco de Tiempo físico puede funcionar solo con el bloque de gestión, podría ocurrir, por ejemplo, que la inmensa*
*mayoria de sus miembros no usen Internet y podrían querer funcionar solo con listados, cheques y una oficina de gestión*

## Sistema de gestión
Los Bancos de Tiempo físicos (a los que principalmente se enfoca TimeOverflow) a menudo funcionan sin internet, se realizan
unos listados de servicios y de miembros y se pagan las horas con talones que finalmente se ingresan en la oficina, por tanto
el sistema de gestión nos permite gestionar los miembros y sus servicios, sacar listados y llevar la contabilidad. También
es importante que los gestores del Banco (admin), tengan información útil sobre la comunidad para poder actuar sobre ella
(por ejemplo, estadísticas sobre usuarios poco activos, gestión de incidencias, equilibrio de las cuentas, etc)

## Red social y banca on-line
La red social facilita a los miembros encontrarse y conocerse fuera de los eventos programados por el Banco de Tiempo,
así como poder publicar anuncios de ofertas/demandas explicados en detalle.

Por otro lado los miembros pueden pagarse los servicios de manera virtual para ahorrarse el paso por la oficina del Banco
de Tiempo y también tienen la posibilidad de consultar el extracto de su cuenta.


ERD
===

Entity-relation diagram written using

    bundle exec rake erd filetype=png inheritance=false polymorphism=true indirect=false

![ERD](./erd.png)


License
=======

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org/>

Wireframes
=======

https://moqups.com/sseerrggii/JIu1Z1eD/




Notas para desarrollo
=====================
Únete al equipo de colaboradores!! Gestionamos las tareas en Redbooth.com https://redbooth.com/public/timeoverflow

Si quieres probar la plataforma en local, necesitas PostgreSQL y ruby en sus últimas versiones.

Para más información visita la guia para empezar a desarrollar para timeoverflow en https://github.com/coopdevs/timeoverflow/wiki/Getting-started

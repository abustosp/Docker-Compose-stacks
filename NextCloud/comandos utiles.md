# Comandos útiles para Nextcloud

## Abrir la terminal

```docker exec -ti ConteinerIDdeDocker sh```

## Cambiar los Permisos de los archivos de las carpetas de los usuarios

1. ir a la carpeta donde se encuentran los datos de los usuarios <br>
```cd /var/www/html```
2. Cambiar los permisos de los archivos de los usuarios 644 (Con este permiso el propietario puede leer y escribir en el archivo mientras los demás solo pueden leer) o 777 (Esta opción permite que todos los usuarios puedan leer, escribir y ejecutar en el archivo o carpeta) <br>
```chmod -R 644 data```
```chmod -R 777 data```
3. Con el siguiente comando se cambia el propietario de la carpeta `data` al usuario `www-data` <br>
```chown -R www-data data```

## Para que Nextcloud escanee los cambios en los archivos

```docker exec -u www-data -it ConteinerIDdeDocker php occ files:scan --all```
<br>o<br>
```docker exec -ti --user www-data ConteinerIDdeDocker /var/www/html/occ files:scan --all```



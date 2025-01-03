Acá van algunos comandos que me parecen interesantes para docker que pueden ser útiles en algún momento.

### Eliminar todas las imágenes con tag `<none>`

```bash
 docker rmi $(docker images -f 'dangling=true' -q)
``` 

### Listar todos los contenedores que usan un volumen

```bash
#!/bin/sh

volumes=$(docker volume ls  --format '{{.Name}}')

for volume in $volumes
do
  echo $volume
  docker ps -a --filter volume="$volume"  --format '{{.Names}}' | sed 's/^/  /'
done
```


Listador v2
```bash
#!/bin/bash

# Obtener una lista de todos los contenedores en ejecución
containers=$(docker ps -q)

# Iterar sobre cada contenedor
for container_id in $containers; do
    # Obtener el nombre del contenedor
    container_name=$(docker inspect --format='{{.Name}}' $container_id 2>/dev/null | sed 's#^/>

    echo "Contenedor ID: $container_id"
    echo "Nombre del contenedor: $container_name"

    # Obtener una lista de todos los volúmenes montados en este contenedor
    volumes=$(docker inspect --format='{{range .Mounts}}{{printf "%s" .Name}}{{end}}' $contain>

    # Verificar si el contenedor utiliza algún volumen
    if [ -n "$volumes" ]; then
        echo "Volúmenes utilizados por el contenedor:"
        echo "$volumes"
    else
        echo "El contenedor no utiliza ningún volumen."
    fi
    echo "----------------------------------------"
done
```

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


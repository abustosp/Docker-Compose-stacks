Acá van algunos comandos que me parecen interesantes para docker que pueden ser útiles en algún momento.

### Eliminar todas las imágenes con tag `<none>`

```bash
 docker rmi $(docker images -f 'dangling=true' -q)
``` 
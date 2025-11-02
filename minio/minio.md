## Recomendaciones para la creación de accesos

Al diseñar y crear accesos, es importante tener en cuenta las siguientes recomendaciones para garantizar la seguridad, funcionalidad de los accesos de los buckets de MinIO y la eficiencia en la gestión de los mismos:

1. **Uso de Políticas de Acceso**: Define políticas de acceso claras y específicas para cada bucket. Utiliza políticas basadas en roles para limitar el acceso según las necesidades del usuario o aplicación.

2. **Autenticación Segura**: Implementa mecanismos de autenticación robustos, como el uso de claves de acceso y secretos, para asegurar que solo usuarios autorizados puedan acceder a los recursos.

3. **Creación de Usuarios y Grupos**: Organiza a los usuarios en grupos según sus roles y responsabilidades. Esto facilita la gestión de permisos y asegura que los usuarios tengan acceso solo a lo que necesitan.

Aclaración: lo recomentable es agregar un sufijo a los elementos para identificarlos ej facturas_usuario, facturas_policy

### Pasos recomendados para crear accesos en MinIO

1. **Crear un bucket**:
   - Accede a la consola de MinIO.
   - Navega a la sección de "Buckets" y selecciona "Crear Bucket".
   - Asigna un nombre único y configura las opciones según tus necesidades.

2. **Definir políticas de acceso**:
   - Ve a la sección de "Políticas" en la consola de MinIO.
   - Crea una nueva política o edita una existente para definir los permisos de acceso al bucket.
   - Asigna la política al bucket correspondiente.

ejemplo de politica JSON;
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::tu-bucket",
                "arn:aws:s3:::tu-bucket/*"
            ]
        }
    ]
}
```

Ejemplo 2: 
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketLocation",
                "s3:ListBucket",
                "s3:ListBucketMultipartUploads"
            ],
            "Resource": [
                "arn:aws:s3:::tu-bucket"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:AbortMultipartUpload",
                "s3:GetObject",
                "s3:ListMultipartUploadParts",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::tu-bucket/*"
            ]
        }
    ]
}
```

3. **Crear usuarios y asignar políticas**:
   - Dirígete a la sección de "Usuarios" en la consola de MinIO.
   - Crea un nuevo usuario y asigna una política de acceso adecuada.
   - Proporciona las credenciales al usuario para que pueda acceder al bucket.



# 📘 Recomendaciones para la Creación y Gestión de Accesos en MinIO

La gestión correcta de accesos en **MinIO** es esencial para garantizar la **seguridad**, **aislamiento**, y **eficiencia operativa** del entorno.  
A continuación se detallan las **mejores prácticas**, **diferencias entre políticas**, y los **parámetros más habituales** a tener en cuenta al diseñar y administrar accesos.

---

## 🔐 Principios Generales

1. ### **Uso de Políticas de Acceso**
   - Define **políticas específicas por bucket o grupo de recursos**, evitando permisos globales innecesarios.  
   - Las políticas pueden ser **basadas en roles (RBAC)** o **por recurso (resource-based)**.
   - Las políticas son expresadas en formato **JSON**, similar a las de AWS IAM, con una estructura basada en “Statements” de tipo *Allow* o *Deny*.

2. ### **Autenticación Segura**
   - Utiliza **Access Key** y **Secret Key** únicos por usuario o servicio.
   - Evita compartir credenciales entre aplicaciones.
   - Implementa **rotación periódica** de claves y registra los accesos mediante logs del servidor MinIO (`mc admin trace`).

3. ### **Creación de Usuarios y Grupos**
   - Crea **grupos** para roles comunes (ej. `lectores`, `subidores`, `analistas`) y asigna políticas a nivel de grupo.
   - Los **usuarios** heredan permisos de grupo, pero pueden tener políticas adicionales si es necesario.
   - Utiliza **nombres descriptivos y sufijos** (ej. `facturas_usuario`, `facturas_policy`) para facilitar la administración.

---

## ⚙️ Pasos Recomendados para Crear Accesos

### 1. Crear un Bucket
1. Ingresa a la consola web de MinIO (`http://<host>:9001`).
2. Ve a **Buckets → Crear Bucket**.
3. Define un **nombre único** (sin espacios, minúsculas).
4. Configura las opciones:
   - **Versioning** (para mantener historial de objetos).
   - **Locking** (retención legal o compliance).
   - **Public Access** (evitar habilitar salvo entornos de prueba).

---

### 2. Definir Políticas de Acceso

Las políticas controlan **qué acciones pueden realizarse** sobre un bucket y **desde qué contexto (recurso)**.

#### 🔹 Ejemplo 1 – Política Básica de Lectura y Escritura
```json
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
````

**Explicación:**

* `s3:GetObject`: permite descargar archivos.
* `s3:PutObject`: permite subir archivos.
* `s3:ListBucket`: permite listar los objetos dentro del bucket.
* Es ideal para **bots o scripts** que necesitan leer y subir archivos, pero no eliminar.

---

#### 🔹 Ejemplo 2 – Política Ampliada (para cargas multipart y administración)

```json
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

**Explicación:**

* Incluye permisos para **cargas multipart** (necesarios cuando los archivos superan ciertos tamaños).
* `s3:GetBucketLocation`: permite conocer la región del bucket.
* Recomendado para **servicios de backend** o **pipelines de carga masiva** (ej. ETL, bots de scraping o generación de documentos).

---

### 3. Crear Usuarios y Asignar Políticas

1. Ve a **Usuarios → Crear Usuario**.
2. Ingresa un nombre y genera **Access Key / Secret Key**.
3. Asigna la política deseada o el grupo que ya la posea.
4. Guarda las credenciales (no podrán visualizarse nuevamente).
5. Opcionalmente, prueba con el cliente `mc`:

   ```bash
   mc alias set test http://<host>:9000 ACCESS_KEY SECRET_KEY
   mc ls test/tu-bucket
   ```

---

## 📊 Comparativa de Políticas Habituales

| Tipo de Política      | Permisos Principales                                           | Uso Recomendado                        | Ventajas                                   | Riesgos / Limitaciones            |
| --------------------- | -------------------------------------------------------------- | -------------------------------------- | ------------------------------------------ | --------------------------------- |
| **Lectura**           | `s3:GetObject`, `s3:ListBucket`                                | Visualización de reportes o logs       | Alta seguridad, acceso mínimo              | No permite subir archivos         |
| **Lectura/Escritura** | `s3:GetObject`, `s3:PutObject`, `s3:ListBucket`                | Bots o APIs que generan archivos       | Equilibrio entre seguridad y funcionalidad | No permite eliminar archivos      |
| **Completa (admin)**  | Todos los `s3:*`                                               | Administradores o CI/CD                | Máxima flexibilidad                        | Riesgo de eliminación accidental  |
| **Multipart Upload**  | `s3:AbortMultipartUpload`, `s3:ListMultipartUploadParts`, etc. | Procesos de subida de archivos grandes | Permite cargas optimizadas                 | Complejidad en manejo de permisos |
| **Solo Bucket**       | `s3:ListBucket`, `s3:GetBucketLocation`                        | Monitoreo o auditorías                 | Bajo impacto en seguridad                  | No puede manipular objetos        |

---

## ⚖️ Pros y Contras de las Configuraciones

| Aspecto              | Configuración Restringida       | Configuración Ampliada             |
| -------------------- | ------------------------------- | ---------------------------------- |
| **Seguridad**        | Alta, menor riesgo de fuga      | Menor, más exposición              |
| **Facilidad de uso** | Requiere ajustes por rol        | Acceso directo y simple            |
| **Mantenimiento**    | Más granular, más trabajo       | Centralizada, más rápida           |
| **Escalabilidad**    | Ideal para entornos productivos | Ideal para entornos de desarrollo  |
| **Auditoría**        | Permite rastrear cada usuario   | Más difícil distinguir actividades |

---

## ⚙️ Parámetros Habituales en Políticas

| Campo                    | Descripción                                               | Ejemplo                                           |
| ------------------------ | --------------------------------------------------------- | ------------------------------------------------- |
| `Version`                | Versión del formato de política (mantener `"2012-10-17"`) | `"2012-10-17"`                                    |
| `Statement`              | Lista de reglas dentro de la política                     | `[{...}, {...}]`                                  |
| `Effect`                 | Acción: `"Allow"` o `"Deny"`                              | `"Allow"`                                         |
| `Action`                 | Operaciones permitidas o denegadas                        | `"s3:GetObject"`                                  |
| `Resource`               | ARN del recurso afectado (bucket u objeto)                | `"arn:aws:s3:::bucket/*"`                         |
| `Condition` *(opcional)* | Filtros adicionales (por IP, usuario, prefijo, etc.)      | `"IpAddress": {"aws:SourceIp": "192.168.0.0/16"}` |

---

## 🧩 Buenas Prácticas Adicionales

* Usa **prefijos o sufijos** para diferenciar usuarios, políticas y buckets (`ventas_policy`, `reportes_user`).
* Evita políticas con `"Action": "s3:*"` salvo en administración.
* Realiza **backups de configuración** con:

  ```bash
  mc admin info
  mc admin policy list
  mc admin user list
  ```
* Implementa **rotación de claves** y **alertas de acceso fallido** si tu infraestructura lo permite.




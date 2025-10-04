# 🚀 Guía: Construir APK con GitHub Actions

## 📋 Pasos para usar GitHub Actions

### 1️⃣ Crear Repositorio en GitHub

1. Ve a https://github.com y crea un nuevo repositorio
2. Nombre sugerido: `lavianda-operaciones-flutter`
3. Marca como **Privado** si no quieres que sea público
4. **NO** inicialices con README (ya tienes código)

---

### 2️⃣ Subir tu Código a GitHub

Ejecuta estos comandos en tu terminal:

```bash
cd /home/fabricciodev21/Documentos/operaciones.lavianda/operaciones_flutter

# Inicializar Git (si no está inicializado)
git init

# Agregar todos los archivos
git add .

# Hacer el primer commit
git commit -m "Initial commit - LaVianda Operaciones Flutter App"

# Conectar con tu repositorio de GitHub
# Reemplaza <tu-usuario> con tu nombre de usuario de GitHub
git remote add origin https://github.com/<tu-usuario>/lavianda-operaciones-flutter.git

# Subir el código
git branch -M main
git push -u origin main
```

---

### 3️⃣ GitHub Actions se Ejecutará Automáticamente

Una vez que hagas `git push`, GitHub Actions:

1. ✅ Instalará Flutter automáticamente
2. ✅ Descargará las dependencias
3. ✅ Construirá el APK Debug
4. ✅ Construirá el APK Release
5. ✅ Creará una Release con ambos APKs

**Tiempo estimado:** 5-10 minutos

---

### 4️⃣ Descargar el APK

#### Opción A: Desde la pestaña Actions

1. Ve a tu repositorio en GitHub
2. Haz clic en la pestaña **"Actions"**
3. Verás el workflow ejecutándose
4. Una vez completado, haz clic en el workflow
5. En **"Artifacts"** encontrarás:
   - `app-debug.apk`
   - `app-release.apk`
6. Descárgalo y transfiérelo a tu teléfono

#### Opción B: Desde Releases

1. Ve a la pestaña **"Releases"** en tu repositorio
2. Verás una nueva release creada automáticamente
3. Descarga el APK desde ahí

---

### 5️⃣ Instalar en tu Teléfono

1. Transfiere el APK a tu teléfono (USB, WhatsApp, Drive, etc.)
2. En tu teléfono, abre el archivo APK
3. Android te pedirá permiso para instalar apps desconocidas
4. Acepta y la app se instalará

---

## 🔄 Para Futuras Actualizaciones

Cada vez que hagas cambios:

```bash
cd /home/fabricciodev21/Documentos/operaciones.lavianda/operaciones_flutter

# Agregar cambios
git add .

# Hacer commit
git commit -m "Descripción de los cambios"

# Subir
git push
```

GitHub Actions construirá un nuevo APK automáticamente.

---

## 📝 Comandos Útiles de Git

```bash
# Ver estado de archivos
git status

# Ver historial de commits
git log --oneline

# Ver diferencias
git diff

# Crear nueva rama
git checkout -b nombre-rama

# Cambiar de rama
git checkout main
```

---

## 🎯 Alternativa: Ejecutar Workflow Manualmente

1. Ve a la pestaña **"Actions"** en GitHub
2. Selecciona **"Build Flutter APK"** en la lista de workflows
3. Haz clic en **"Run workflow"**
4. Selecciona la rama (main)
5. Haz clic en **"Run workflow"**

GitHub construirá el APK sin necesidad de hacer push.

---

## 🔐 Si tu Repo es Privado

Para clonar o hacer push con un repo privado, necesitarás:

1. **Personal Access Token** en lugar de contraseña
2. O configurar **SSH keys**

### Crear Personal Access Token:

1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token
3. Marca: `repo`, `workflow`
4. Copia el token
5. Úsalo como contraseña cuando hagas `git push`

---

## ⚡ Verificar que GitHub Actions Funciona

Después de hacer `git push`, ve a:

```
https://github.com/<tu-usuario>/lavianda-operaciones-flutter/actions
```

Verás el workflow ejecutándose en tiempo real con una barra de progreso.

---

## 🎉 ¡Listo!

Con esto tendrás APKs construidos automáticamente cada vez que hagas cambios en tu código.

**Próximos pasos:**
1. Crea tu repositorio en GitHub
2. Ejecuta los comandos de Git
3. Espera 5-10 minutos
4. Descarga el APK
5. Instálalo en tu teléfono

---

**¿Necesitas ayuda configurando Git o GitHub?** Puedo guiarte paso a paso. 🚀

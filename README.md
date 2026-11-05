# InterFind

App iOS (UIKit) para descubrir pasantías, 100% local: sin servidor, sin Firebase y sin cuentas en la nube.

> InterFind es una versión rediseñada y personal de **PasaFinder**, un proyecto universitario desarrollado en equipo.
> Esta versión parte de ese código y lo adapta para funcionar sin conexión, como proyecto de portafolio.

## Qué cambió respecto al original

- **Sin backend:** el servidor remoto se reemplazó por `LocalStore`, que guarda pasantías en JSON, imágenes en el dispositivo y cuentas con contraseña hasheada (SHA-256 + sal).
- **Sin Firebase:** se eliminó el SDK y su configuración.
- **Banners Big Tech:** los anuncios se reemplazaron por tarjetas que abren las páginas oficiales de programas para estudiantes (Google, Microsoft, Apple, Amazon, Meta, NVIDIA).
- **Datos de ejemplo:** `internships.json` incluye pasantías de empresas ficticias para la primera ejecución.
- **Rebranding:** proyecto, bundle ID y prefijo de componentes `IF`.
- **Nuevo flujo:** el onboarding solo aparece la primera vez, hay botón de entrada demo y se puede cerrar sesión.
- **Pestañas rediseñadas:** Inicio, Buscar, Guardados y Perfil, con íconos rellenos al seleccionar.
- **Avatar por defecto:** inicial del nombre en lugar de una imagen fija.

## Cuenta demo

| Usuario | Correo | Contraseña |
|---|---|---|
| Daiv | `daiv@interfind.app` | `interfind` |

También puedes tocar **"Entrar como Daiv (demo)"** en el login. Es la cuenta administradora: puede publicar y eliminar pasantías.

## Funcionalidades

- Onboarding, registro e inicio de sesión locales
- Inicio con pasantías urgentes y recientes, búsqueda y detalle
- Favoritos guardados con Core Data
- Publicar y eliminar pasantías con imagen desde la galería
- Perfil editable

## Requisitos

- Xcode 16 o superior
- iOS 16.6+

Abre `InterFind/InterFind.xcodeproj`, elige un simulador y ejecuta. Para un dispositivo físico, selecciona tu propio equipo de desarrollo en *Signing & Capabilities*.

## Créditos

Basado en PasaFinder, desarrollado originalmente en equipo. Los autores originales se conservan en los encabezados de los archivos y en `LICENSE`.

## Licencia

MIT. Ver [LICENSE](LICENSE).

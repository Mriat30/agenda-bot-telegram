# Agenda Bot - Interfaz de Cliente

Bot de Telegram desarrollado en **Ruby** que sirve como interfaz principal para que los usuarios finales interactúen con la **Agenda API**.

## 🛠️ Stack Técnico
- **Lenguaje:** Ruby
- **Comunicación:** REST API (consumiendo Agenda-API)
- **Testing:** RSpec para pruebas unitarias y de integración.
- **Contenerización:** Docker & Docker Compose para ambientes locales de desarrollo.

## 🚀 Ejecución de la Aplicación

Para iniciar el bot en modo manual o dentro del contenedor

```bash
  ./start_app.sh 
  ```
## ⚙️ Desarrollo

Este componente está diseñado para operar en un entorno de desarrollo estandarizado y cuenta con una suite de validación técnica basada en estándares de la comunidad Ruby.

🐳 Entorno de Desarrollo (Remote Development)

El proyecto utiliza Docker y Dev Containers para garantizar un ambiente consistente.


- **Levantar el entorno:** 
```bash
  ./start_dev_container.sh 
  ```
- **Uso en VS Code**: Al abrir la carpeta, el editor sugerirá automáticamente "Reopen in Container". Esto instalará todas las dependencias y configurará TypeScript y Prisma sin necesidad de instalaciones locales.

## 🧪 Ejecución de Tests y Calidad

- **Suite completa:** Ejecuta por defecto las pruebas (spec) y el linter **(rubocop).**
```bash
  bundle exec rake
  ```

- **Unitarios:** Ejecuta la suite de pruebas con **RSpec.**
```bash
  bundle exec rspec
  ```


- **Aceptacion:** Valida historias de usuario utilizando Cucumber-js (Gherkin).
```bash
  bundle exec cucumber
  ```


- **Linter:** Analiza el código buscando infracciones de estilo y mejores prácticas..
```bash
  bundle exec rubocop
  ```


# Auditoría básica de sistema (PowerShell)

Script que recopila información de salud de un equipo Windows: datos del sistema
operativo, espacio libre en disco y servicios automáticos que deberían estar en
ejecución y no lo están. Genera informes en CSV y muestra un resumen en consola
con codificación por colores (OK / Aviso / Error).

## Qué revisa
- Información del sistema operativo (Get-ComputerInfo)
- Porcentaje de espacio libre en disco C, con aviso si baja del 15%
- Servicios con arranque "Automático" que están detenidos

## Uso
1. Ejecutar `.\informe_sistema.ps1` en PowerShell
2. Revisar los CSV generados: `informe_sistema.csv`, `informe_disco.csv`,
   `servicios_criticos_parados.csv` (este último solo si hay servicios detenidos)

## Notas
El listado de servicios detenidos es una primera pasada de detección; incluye
servicios no críticos (impresión, Bluetooth, etc.) que no requieren acción.
Próxima mejora: excluir servicios no esenciales conocidos para reducir falsos positivos.

## Próximos pasos
Integrar con envío de alertas por email o Teams cuando se detecten condiciones
críticas (disco por debajo de un umbral, servicios esenciales caídos).

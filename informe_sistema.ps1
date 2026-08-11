# ============================================
# Script: informe_sistema.ps1
# Descripcion: Recoge informacion basica de salud del equipo local
# (sistema operativo, espacio en disco, servicios criticos parados)
# y genera informes en CSV para revision o archivo.
# ============================================

Write-Host "Iniciando auditoria del sistema..." -ForegroundColor Cyan
Write-Host ""

# ---------- 1. Informacion del sistema operativo ----------
try {
    $infoSistema = Get-ComputerInfo | Select-Object CsName, WindowsProductName, OsArchitecture, WindowsVersion
    $infoSistema | Export-Csv -Path "informe_sistema.csv" -NoTypeInformation
    Write-Host "OK - Informacion del sistema exportada a informe_sistema.csv" -ForegroundColor Green
} catch {
    Write-Host "ERROR al obtener informacion del sistema: $_" -ForegroundColor Red
}

# ---------- 2. Espacio en disco ----------
try {
    $disco = Get-PSDrive C | Select-Object Name,
        @{Name="UsadoGB"; Expression={[math]::Round($_.Used / 1GB, 2)}},
        @{Name="LibreGB"; Expression={[math]::Round($_.Free / 1GB, 2)}}

    $disco | Export-Csv -Path "informe_disco.csv" -NoTypeInformation

    $porcentajeLibre = [math]::Round(($disco.LibreGB / ($disco.UsadoGB + $disco.LibreGB)) * 100, 1)

    if ($porcentajeLibre -lt 15) {
        Write-Host "AVISO - Espacio libre en disco C: bajo ($porcentajeLibre%)" -ForegroundColor Yellow
    } else {
        Write-Host "OK - Espacio en disco C: dentro de rango normal ($porcentajeLibre% libre)" -ForegroundColor Green
    }
} catch {
    Write-Host "ERROR al comprobar el disco: $_" -ForegroundColor Red
}

# ---------- 3. Servicios criticos detenidos ----------
try {
    $serviciosParados = Get-Service |
        Where-Object { $_.Status -eq "Stopped" -and $_.StartType -eq "Automatic" } |
        Select-Object Name, DisplayName, Status

    if ($serviciosParados.Count -gt 0) {
        $serviciosParados | Export-Csv -Path "servicios_criticos_parados.csv" -NoTypeInformation
        Write-Host "AVISO - $($serviciosParados.Count) servicio(s) automatico(s) detenido(s). Ver servicios_criticos_parados.csv" -ForegroundColor Yellow
    } else {
        Write-Host "OK - Todos los servicios automaticos estan en ejecucion" -ForegroundColor Green
    }
} catch {
    Write-Host "ERROR al comprobar servicios: $_" -ForegroundColor Red
}

# ---------- Resumen ----------
Write-Host ""
Write-Host "===== AUDITORIA COMPLETADA =====" -ForegroundColor Cyan
Write-Host "Informes generados en la carpeta actual."
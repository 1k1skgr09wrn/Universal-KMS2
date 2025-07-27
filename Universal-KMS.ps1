# ==========================
#  УНИВЕРСАЛЬНЫЙ KMS АКТИВАТОР
# ==========================

function Show-Header {
    Clear-Host
    Write-Host ""
    Write-Host "╔═══════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║           УНИВЕРСАЛЬНЫЙ KMS АКТИВАТОР WINDOWS         ║" -ForegroundColor Green
    Write-Host "╚═══════════════════════════════════════════════════════╝" -ForegroundColor Green
}

function Get-CurrentKey {
    $line = (cscript.exe //nologo slmgr.vbs /dli | Select-String "Partial Product Key").Line
    if ($line) { return $line }
    return $null
}

function Is-Activated {
    $status = (cscript.exe //nologo slmgr.vbs /xpr | Out-String)
    return ($status -notmatch "не")
}

function Get-KeyForOS {
    $os = (Get-CimInstance Win32_OperatingSystem).Caption
    $keys = @{
        "Windows 7 Professional"            = "FJ82H-XT6CR-J8D7P-XQJJ2-GPDD4"
        "Windows 7 Enterprise"              = "33PXH-7Y6KF-2VJC9-XBBR8-HVTHH"
        "Windows 10 Pro"                    = "W269N-WFGWX-YVC9B-4J6C9-T83GX"
        "Windows 10 Enterprise"             = "NPPR9-FWDCX-D2C8J-H872K-2YT43"
        "Windows 11 Pro"                    = "W269N-WFGWX-YVC9B-4J6C9-T83GX"
        "Windows 11 Enterprise"             = "NPPR9-FWDCX-D2C8J-H872K-2YT43"
        "Windows Server 2016 Datacenter"    = "CB7KF-BWN84-R7R2Y-793K2-8XDDG"
        "Windows Server 2019 Datacenter"    = "WMDGN-G9PQG-XVVXX-R3X43-63DFG"
        "Windows Server 2022 Datacenter"    = "WX4NM-KYWYW-QJJR4-XV3QB-6VM33"
        "Windows Server 2025 Datacenter"    = "H7X92-3W8N6-FG6G4-W6G3X-3W6R7"
    }
    foreach ($k in $keys.Keys) {
        if ($os -like "*$k*") {
            return $keys[$k]
        }
    }
    return $null
}

function Activate-Windows {
    if (Is-Activated) {
        Write-Host "`n✅ Windows уже активирована." -ForegroundColor Green
        return
    }

    $key = Get-KeyForOS
    if (-not $key) {
        Write-Host "❌ Ключ для вашей ОС не найден." -ForegroundColor Red
        return
    }

    Write-Host "`nОбнаружен ключ: $key" -ForegroundColor Cyan
    $currentKey = Get-CurrentKey

    if ($currentKey -match $key.Substring($key.Length - 5)) {
        Write-Host "✔️ Ключ уже установлен, пропускаем установку." -ForegroundColor Yellow
    } else {
        Write-Host "🔑 Установка нового ключа..." -ForegroundColor Yellow
        slmgr.vbs /ipk $key
    }

    $servers = @(
        "kms.digiboy.ir",
        "kms8.msguides.com",
        "kms.loli.beer",
        "kms.lotro.cc",
        "kms.teevee.asia",
        "kms.03k.org"
    )

    foreach ($server in $servers) {
        Write-Host "🌐 Пробуем сервер: $server" -ForegroundColor DarkCyan
        slmgr.vbs /skms $server
        slmgr.vbs /ato
        Start-Sleep -Seconds 5

        if (Is-Activated) {
            Write-Host "✅ Успешная активация через $server" -ForegroundColor Green
            return
        }
    }

    Write-Host "❌ Не удалось активировать Windows." -ForegroundColor Red
}

function Remove-KMS {
    Write-Host "`n🧹 Очистка настроек KMS..." -ForegroundColor Yellow
    slmgr.vbs /ckms
    slmgr.vbs /upk
    slmgr.vbs /cpky
    Write-Host "✔️ Ключи удалены." -ForegroundColor Green
}

# === Основное меню ===
do {
    Show-Header
    if (Is-Activated) {
        Write-Host "`nСтатус: ✅ Windows активирована" -ForegroundColor Green
    } else {
        Write-Host "`nСтатус: ❌ Windows не активирована" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "1. Активировать Windows"
    Write-Host "2. Проверить статус активации"
    Write-Host "3. Удалить ключи KMS"
    Write-Host "0. Выход"
    Write-Host ""
    $choice = Read-Host "Выберите пункт"

    switch ($choice) {
        "1" { Activate-Windows; Read-Host "`nНажмите Enter для возврата в меню" }
        "2" {
            if (Is-Activated) { Write-Host "`n✅ Windows активирована" -ForegroundColor Green } 
            else { Write-Host "`n❌ Windows не активирована" -ForegroundColor Red }
            Read-Host "`nНажмите Enter для возврата в меню"
        }
        "3" { Remove-KMS; Read-Host "`nНажмите Enter для возврата в меню" }
        "0" { break }
        default { Write-Host "`n❗ Неверный выбор." -ForegroundColor Red; Start-Sleep -Seconds 2 }
    }
} while ($true)

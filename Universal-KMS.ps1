# ─── УНИВЕРСАЛЬНЫЙ KMS АКТИВАТОР (PORTABLE) ───

function Показать-Заголовок {
    Clear-Host
    Write-Host ""
    Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║        УНИВЕРСАЛЬНЫЙ KMS АКТИВАТОР WINDOWS - PORTABLE        ║" -ForegroundColor Green
    Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Green
}

function Получить-Ключ {
    param([string]$версия)

    $таблица = @{
        "Windows 7 Professional"      = "FJ82H-XT6CR-J8D7P-XQJJ2-GPDD4"
        "Windows 7 Enterprise"        = "33PXH-7Y6KF-2VJC9-XBBR8-HVTHH"
        "Windows 10 Pro"              = "W269N-WFGWX-YVC9B-4J6C9-T83GX"
        "Windows 10 Enterprise"       = "NPPR9-FWDCX-D2C8J-H872K-2YT43"
        "Windows 11 Pro"              = "W269N-WFGWX-YVC9B-4J6C9-T83GX"
        "Windows 11 Enterprise"       = "NPPR9-FWDCX-D2C8J-H872K-2YT43"
        "Windows Server 2016 Datacenter" = "CB7KF-BWN84-R7R2Y-793K2-8XDDG"
        "Windows Server 2019 Datacenter" = "WMDGN-G9PQG-XVVXX-R3X43-63DFG"
        "Windows Server 2022 Datacenter" = "WX4NM-KYWYW-QJJR4-XV3QB-6VM33"
        "Windows Server 2025 Datacenter" = "H7X92-3W8N6-FG6G4-W6G3X-3W6R7"
    }

    foreach ($ключ in $таблица.Keys) {
        if ($версия -like "*$ключ*") {
            return $таблица[$ключ]
        }
    }

    return $null
}

function Проверить-Активацию {
    Write-Host ""
    Write-Host "🔎 Проверка активации..." -ForegroundColor Cyan
    $рез = cscript.exe //nologo slmgr.vbs /xpr | Out-String
    $ключ = (cscript.exe //nologo slmgr.vbs /dli | Select-String "Partial Product Key").Line
    Write-Host "`n📋 Установленный ключ: $ключ"
    Write-Host "📆 Статус: $рез"
}

function Попробовать-Активацию($ключ) {
    $серверы = @(
        "kms.digiboy.ir",
        "kms8.msguides.com",
        "kms.loli.beer",
        "kms.lotro.cc",
        "kms.03k.org",
        "kms.teevee.asia",
        "s8.uk.to",
        "kmsactivator.xyz",
        "kms.zhiqiang.name",
        "192.168.1.100"
    )

    Write-Host "`n⚙️ Установка ключа: $ключ" -ForegroundColor Yellow
    slmgr.vbs /ipk $ключ

    foreach ($сервер in $серверы) {
        Write-Host "🌐 Пробуем сервер: $сервер" -ForegroundColor DarkCyan
        slmgr.vbs /skms $сервер
        slmgr.vbs /ato
        Start-Sleep -Seconds 5

        $статус = (cscript.exe //nologo slmgr.vbs /xpr | Out-String)
        if ($статус -notmatch "не") {
            Write-Host "✅ УСПЕХ! Сервер активировал систему: $сервер" -ForegroundColor Green
            return
        }
    }

    Write-Host "❌ Не удалось активировать Windows. Все KMS-серверы недоступны." -ForegroundColor Red
}

function Активация {
    $версия = (Get-CimInstance Win32_OperatingSystem).Caption
    Write-Host "🔍 Обнаружена версия Windows: $версия" -ForegroundColor Cyan

    $ключ = Получить-Ключ $версия
    if (-not $ключ) {
        Write-Host "❌ Не найден ключ для этой версии Windows." -ForegroundColor Red
        return
    }

    Попробовать-Активацию $ключ
    Проверить-Активацию
}

function Удалить-Ключ {
    Write-Host "`n🧹 Удаление KMS-настроек и ключей..." -ForegroundColor Yellow
    slmgr.vbs /ckms
    slmgr.vbs /upk
    slmgr.vbs /cpky
    Write-Host "✔️ Очистка завершена." -ForegroundColor Green
}

function Меню {
    Показать-Заголовок
    Write-Host "1️⃣  Активировать Windows"
    Write-Host "2️⃣  Проверить статус активации"
    Write-Host "3️⃣  Удалить KMS-ключ и настройки"
    Write-Host "0️⃣  Выход"
    $выбор = Read-Host "Выберите действие (0-3)"

    switch ($выбор) {
        "1" { Активация }
        "2" { Проверить-Активацию }
        "3" { Удалить-Ключ }
        "0" { exit }
        default {
            Write-Host "❗ Неверный выбор, попробуйте снова." -ForegroundColor Red
        }
    }

    Pause
    Меню
}

Меню

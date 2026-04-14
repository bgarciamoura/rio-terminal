$ErrorActionPreference = 'Stop'
$src = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
$dst = "$env:SystemRoot\Fonts"
$regKey = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'

$files = Get-ChildItem -Path $src -Filter 'JetBrainsMonoNerdFont-*.ttf'

if (-not $files) {
    Write-Host "Nenhum arquivo JetBrainsMonoNerdFont-*.ttf encontrado em $src"
    exit 1
}

$nameMap = @{
    'Regular'         = 'JetBrainsMono NF Regular (TrueType)'
    'Italic'          = 'JetBrainsMono NF Italic (TrueType)'
    'Bold'            = 'JetBrainsMono NF Bold (TrueType)'
    'BoldItalic'      = 'JetBrainsMono NF Bold Italic (TrueType)'
    'Light'           = 'JetBrainsMono NF Light (TrueType)'
    'LightItalic'     = 'JetBrainsMono NF Light Italic (TrueType)'
    'Medium'          = 'JetBrainsMono NF Medium (TrueType)'
    'MediumItalic'    = 'JetBrainsMono NF Medium Italic (TrueType)'
    'SemiBold'        = 'JetBrainsMono NF SemiBold (TrueType)'
    'SemiBoldItalic'  = 'JetBrainsMono NF SemiBold Italic (TrueType)'
    'ExtraBold'       = 'JetBrainsMono NF ExtraBold (TrueType)'
    'ExtraBoldItalic' = 'JetBrainsMono NF ExtraBold Italic (TrueType)'
    'ExtraLight'      = 'JetBrainsMono NF ExtraLight (TrueType)'
    'ExtraLightItalic'= 'JetBrainsMono NF ExtraLight Italic (TrueType)'
    'Thin'            = 'JetBrainsMono NF Thin (TrueType)'
    'ThinItalic'      = 'JetBrainsMono NF Thin Italic (TrueType)'
}

foreach ($f in $files) {
    $variant = $f.BaseName -replace '^JetBrainsMonoNerdFont-', ''
    $regName = $nameMap[$variant]
    if (-not $regName) {
        Write-Host "Pulando variante desconhecida: $variant"
        continue
    }
    $target = Join-Path $dst $f.Name
    Copy-Item -Path $f.FullName -Destination $target -Force
    New-ItemProperty -Path $regKey -Name $regName -Value $f.Name -PropertyType String -Force | Out-Null
    Write-Host "Instalado: $regName -> $($f.Name)"
}

Write-Host ""
Write-Host "Concluido. Reinicie o Rio para aplicar."

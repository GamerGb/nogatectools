Set-ExecutionPolicy Bypass -Scope Process -Force;

Function Cor {
	
	# Definir tema para modo claro
#Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 1
#Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 1

# Ativar cores em Iniciar, barra de tarefas e central de ações, e Barra de títulos e bordas da janela
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name "ColorPrevalence" -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "ColorPrevalence" -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableWindowColorization" -Value 1

# Ativar efeitos de transparência
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 1

# Caminho dos registros de cores
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent"

# Função para converter a paleta de cores em formato binário
function ConvertTo-BinaryArray {
    param (
        [string]$hexString
    )
    $hexString.Split(',') | ForEach-Object { [byte]("0x$_") }
}

# Definir a cor do menu
$AccentColorMenuKey = @{
    Key   = 'AccentColorMenu';
    Type  = "DWORD";
    Value = '0xff484a4c'
}
If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $AccentColorMenuKey.Key -ErrorAction SilentlyContinue)) {
    New-ItemProperty -Path $RegPath -Name $AccentColorMenuKey.Key -Value $AccentColorMenuKey.Value -PropertyType $AccentColorMenuKey.Type -Force
} Else {
    Set-ItemProperty -Path $RegPath -Name $AccentColorMenuKey.Key -Value $AccentColorMenuKey.Value -Force
}

# Definir a paleta de cores
$AccentPaletteKey = @{
    Key   = 'AccentPalette';
    Type  = "BINARY";
    Value = '9b,9a,99,00,84,83,81,00,6d,6b,6a,00,4c,4a,48,00,36,35,33,00,26,25,24,00,19,19,19,00,10,7c,10,00'
}
$binaryValue = ConvertTo-BinaryArray $AccentPaletteKey.Value
If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $AccentPaletteKey.Key -ErrorAction SilentlyContinue)) {
    New-ItemProperty -Path $RegPath -Name $AccentPaletteKey.Key -PropertyType Binary -Value $binaryValue
} Else {
    Set-ItemProperty -Path $RegPath -Name $AccentPaletteKey.Key -Value $binaryValue -Force
}

# Definir a cor de movimento
$MotionAccentIdKey = @{
    Key   = 'MotionAccentId_v1.00';
    Type  = "DWORD";
    Value = '0x000000db'
}
If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $MotionAccentIdKey.Key -ErrorAction SilentlyContinue)) {
    New-ItemProperty -Path $RegPath -Name $MotionAccentIdKey.Key -Value $MotionAccentIdKey.Value -PropertyType $MotionAccentIdKey.Type -Force
} Else {
    Set-ItemProperty -Path $RegPath -Name $MotionAccentIdKey.Key -Value $MotionAccentIdKey.Value -Force
}

# Definir a cor do menu Iniciar
$StartMenuKey = @{
    Key   = 'StartColorMenu';
    Type  = "DWORD";
    Value = '0xff3f3326'
}
If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $StartMenuKey.Key -ErrorAction SilentlyContinue)) {
    New-ItemProperty -Path $RegPath -Name $StartMenuKey.Key -Value $StartMenuKey.Value -PropertyType $StartMenuKey.Type -Force
} Else {
    Set-ItemProperty -Path $RegPath -Name $StartMenuKey.Key -Value $StartMenuKey.Value -Force
}

# Reiniciar o explorer para aplicar as mudanças
Stop-Process -ProcessName explorer -Force -ErrorAction SilentlyContinue
Start-Process explorer

Write-Host "Tema e cores configurados com sucesso!"


}


function RemoverAtalhosTaskbar {
    param (
        [string[]]$AtalhosRemover
    )

    $TaskbarPath = "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"
    $Shell = New-Object -ComObject Shell.Application

    foreach ($Atalho in $AtalhosRemover) {
        $AtalhoPath = Join-Path $TaskbarPath $Atalho
        if (Test-Path $AtalhoPath) {
            $Folder = $Shell.Namespace((Get-Item $AtalhoPath).DirectoryName)
            $Item = $Folder.ParseName((Get-Item $AtalhoPath).Name)
            $Item.InvokeVerb("Unpin from Taskbar")
            Write-Output "Removido da barra de tarefas: $Atalho"
        } else {
            Write-Output "Atalho não encontrado: $Atalho"
        }
    }

    # Reiniciar o Explorer para aplicar as mudanças
    Stop-Process -Name explorer -Force
    Start-Process explorer
}

# Chamando a função com os atalhos que deseja remover



# Main function invocation

Cor;
RemoverAtalhosTaskbar -AtalhosRemover @("Copilot.lnk", "Microsoft Store.lnk", "Microsoft Edge.lnk")

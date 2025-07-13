@echo off

:: Verifica se o script está sendo executado como administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

rem Codificação UTF-8 
chcp 65001 >nul
mode con: cols=120 lines=45
color F
title Nogatec Tools



:: Cores Normais
set RED=[91m
set GREEN=[92m
set YELLOW=[93m
set BLUE=[34m
set RESET=[0m
set BLACK=[30m
set WHITE=[97m
:: Cores com Background
set BRED=[41m
set BGREEN=[102m
set BBLUE=[106m
set BWHITE=[107m




:MENU
powercfg /S SCHEME_MIN
powercfg -change -monitor-timeout-ac 0
powercfg -change -monitor-timeout-dc 0
powercfg -change -disk-timeout-ac 0
powercfg -change -disk-timeout-dc 0
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 0
powercfg -change -hibernate-timeout-ac 0
powercfg -change -hibernate-timeout-dc 0
setlocal EnableDelayedExpansion
:: Verifica a arquitetura do sistema
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
    set "ARQUITETURA_SISTEMA=32 bits"
) else if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    set "ARQUITETURA_SISTEMA=64 bits"
) else if "%PROCESSOR_ARCHITEW6432%"=="AMD64" (
    set "ARQUITETURA_SISTEMA=64 bits"
) else if "%PROCESSOR_ARCHITECTURE%"=="ARM" (
    set "ARQUITETURA_SISTEMA=ARM"
) else if "%PROCESSOR_ARCHITECTURE%"=="ARM64" (
    set "ARQUITETURA_SISTEMA=ARM64"
) else (
    set "ARQUITETURA_SISTEMA=Arquitetura desconhecida"
)
:: Obtém a versão do Windows
for /f "usebackq tokens=*" %%i in (`powershell -command "(Get-WmiObject Win32_OperatingSystem).Caption"`) do (
    if not defined VERSAO_WINDOWS set "VERSAO_WINDOWS=%%i"
)

where gpedit.msc > nul 2>&1
if %errorlevel%==0 (
	    set INST=%BGREEN%%BLACK%INSTALADO%RESET%  ║
) else ( 
    set INST=           ║	
)
cls
call :banner
echo %WHITE%Computador:%RESET% %GREEN%%computername%%RESET%        %WHITE%Usuário: %RESET%%GREEN%%username%%RESET%        %WHITE%Windows:%RESET% %GREEN%%VERSAO_WINDOWS% %ARQUITETURA_SISTEMA% %RESET%
echo.
echo.
echo 				╔═════════════════════════════════════════╗
echo 				║        Gerenciador de Instalação        ║
echo 				║═════════════════════════════════════════║
echo 				║     1 - Instalação de Programas         ║
echo 				║     2 - Instalar gpedit.msc  %INST%  
echo 				║     3 - Configurações e Otimizações     ║
echo 				║     4 - Instalação de Drivers           ║          
echo 				║     5 - Utilitários                     ║
echo 				║     6 - Sair                            ║
echo 				╚═════════════════════════════════════════╝
echo.
echo.
choice /c 123456 /n /m "Escolha uma opção: "
set choice=%errorlevel%

if "%choice%"=="1" goto MENU_INSTALACAO
if "%choice%"=="2" goto GPEDIT
if "%choice%"=="3" goto MENU_CONFIG
if "%choice%"=="4" goto MENU_DRIVERS
if "%choice%"=="5" goto MENU_UTILITARIOS
if "%choice%"=="6" exit
goto MENU

rem 1 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rem 1 - Instalação de Programas
:MENU_INSTALACAO
cls
if not "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    echo %BBLUE%%BLACK%Instalação funciona somente em sistemas x64. %RESET%
    pause
    exit /b
)
call :banner
echo                ╔════════════════════════════════════════════════════════════════════════════╗
echo                ║                          Instalação de Programas                           ║
echo                ║════════════════════════════════════════════════════════════════════════════║
echo                ║     1 - Básica (Aplicativos Essenciais + Ativação + Office 2021)           ║
echo                ║     2 - Jogos (Básica + Drivers e Ferramentas para Games)                  ║
echo                ║     %BRED%%BLACK%3 - Design (Básica + Drivers e Ferramentas de Design)%RESET%                  ║
echo                ║     4 - Teracopy                                                           ║
echo                ║     5 - Ativações                                                          ║
echo                ║     6 - Programas Torrents%RESET%                                                 ║
echo                ║     7 - Voltar ao Menu Principal                                           ║
echo                ╚════════════════════════════════════════════════════════════════════════════╝
echo.
echo.
choice /c 1234567 /n /m "Escolha uma opção: "
set install_choice=%errorlevel%

if "%install_choice%"=="1" goto MENU_INSTALACAO_BASICA
if "%install_choice%"=="2" goto MENU_INSTALACAO_GAMER
if "%install_choice%"=="" goto MENU_INSTALACAO_DESIGN
if "%install_choice%"=="4" goto MENU_INSTALACAO_TERACOPY
if "%install_choice%"=="5" goto MENU_INSTALACAO_WINDOWS
if "%install_choice%"=="6" goto MENU_INSTALACAO_TORRENTS
if "%install_choice%"=="7" goto MENU
goto MENU_INSTALACAO

:MENU_INSTALACAO_BASICA
cls
call :banner
setlocal EnableDelayedExpansion

powercfg /S SCHEME_MIN
ping -n 1 127.0.0.1 > nul
powercfg -change -monitor-timeout-ac 0
powercfg -change -monitor-timeout-dc 0
powercfg -change -disk-timeout-ac 0
powercfg -change -disk-timeout-dc 0
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 0
powercfg -change -hibernate-timeout-ac 0
powercfg -change -hibernate-timeout-dc 0

echo %BRED%%BLACK%Abrindo Windows Update... %RESET%
start ms-settings:windowsupdate
echo %BGREEN%%BLACK%Windows Update aberto com sucesso! %RESET%
pause


rem INPUT BOX
:: Abre uma caixa de entrada para o usuário digitar um conteúdo
:: for /f "delims=" %%a in ('powershell -Command "Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.Interaction]::InputBox('Digite o conteúdo:', 'Entrada de Texto', 'Valor padrão')"') do set resultado=%%a
:: echo O conteúdo digitado foi: %resultado%
:: pause

rem SIM OU NAO BOX
:: setlocal
:: Exibe a caixa de mensagem usando System.Windows.Forms
:: powershell -Command "Add-Type -AssemblyName System.Windows.Forms; $result = [System.Windows.Forms.MessageBox]::Show('Deseja continuar?', 'Confirmação', [System.Windows.Forms.MessageBoxButtons]::YesNo); if ($result -eq [System.Windows.Forms.DialogResult]::Yes) { exit 1 } else { exit 0 }"
:: if %ERRORLEVEL%==1 (
::     echo Você escolheu SIM.
:: ) else (
::     echo Você escolheu NÃO.
:: )



rem MESSAGEBOX
:: setlocal
:: Exibe a caixa de mensagem com apenas o botão OK
:: powershell -Command "Add-Type -AssemblyName System.Windows.Forms; $result = [System.Windows.Forms.MessageBox]::Show('Operação confirmada!', 'Confirmação', [System.Windows.Forms.MessageBoxButtons]::OK); if ($result -eq [System.Windows.Forms.DialogResult]::OK) { exit 1 } else { exit 0 }"
:: if %ERRORLEVEL%==1 (
::    echo Você confirmou a ação.
:: ) else (
::     echo Nenhuma ação foi confirmada.
:: )




powershell -Command "Add-Type -AssemblyName System.Windows.Forms; $result = [System.Windows.Forms.MessageBox]::Show('Deseja instalar as dependências?', 'Confirmação', [System.Windows.Forms.MessageBoxButtons]::YesNo); if ($result -eq [System.Windows.Forms.DialogResult]::Yes) { exit 1 } else { exit 0 }"
if %ERRORLEVEL%==1 (
    rem Coloque aqui os comandos para instalar as dependências
    call :Depend2
    rem Exemplo: call instalar_dependencias.bat
) else (
    echo %BBLUE%%BLACK%As dependências não serão instaladas! %RESET%
)

cls
call :banner

winget install --id "RARLab.WinRAR" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash


rem Baixar Aplicativos usando Curl
curl --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo %BRED%%BLACK%O curl não está instalado ou não está no PATH.%RESET%
    echo %BRED%%BLACK%Instalando cURL... %RESET%
    winget install --id=cURL.cURL -e --accept-source-agreements --accept-package-agreements
    if %ERRORLEVEL% NEQ 0 (
        echo %BBLUE%%BLACK%Falha ao instalar o cURL.%RESET%
        pause
        goto :MENU
    )
    echo %BGREEN%%BLACK%cURL instalado com sucesso! %RESET%
) else (
    echo %BGREEN%%BLACK%cURL já está instalado! %RESET%
)

rem Definir variáveis de pasta e arquivos
set "pasta_instalacao=%USERPROFILE%\Desktop\Nova Pasta"
set "pasta_office=%pasta_instalacao%\Office 2021"
set "pasta_aact=%pasta_instalacao%\AAct_Network_x64"
set "arquivo_rar=%pasta_instalacao%\Arquivos.rar"
set "arquivo_windef=%pasta_instalacao%\WinDef.rar"
set "pasta_windef=%pasta_instalacao%\WinDef\"
set "link_dropbox=https://www.dropbox.com/s/geisbvplfws907e/Arquivos.rar?st=7d958qjl&dl=1" 

rem Verifica se a pasta de instalação já existe, caso contrário cria
if not exist "%pasta_instalacao%" (
    echo %BRED%%BLACK%Criando pasta da instalação dos programas...%RESET%
    md "%pasta_instalacao%" >nul 2>&1
        echo %BGREEN%%BLACK%Pasta criada com sucesso! %RESET%
)

ping -n 2 127.0.0.1 > nul

rem Baixando o arquivo Arquivos.rar
echo %BRED%%BLACK%Baixando o arquivo Arquivos.rar... %RESET%
curl -L -o "%arquivo_rar%" "%link_dropbox%"
if %ERRORLEVEL% NEQ 0 (
    echo %BBLUE%%BLACK%Falha ao baixar o arquivo Arquivos.rar.%RESET%
    pause
    goto :MENU
) else (
echo %BGREEN%%BLACK%Arquivo Arquivos.rar baixado com sucesso! %RESET%
)

ping -n 5 127.0.0.1 > nul
winget settings --enable InstallerHashOverride
winget install --id "RARLab.WinRAR" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 5 127.0.0.1 > nul

echo %BRED%%BLACK%Abrindo painel do Windows Defender, por favor, desativa-lo...%RESET%
start windowsdefender://threat
pause

ping -n 5 127.0.0.1 > nul

rem Extraindo Arquivos.rar para a pasta de instalação
echo %BRED%%BLACK%Extraindo Arquivos.rar...%RESET%
"C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%arquivo_rar%" "%pasta_instalacao%\" 
if %ERRORLEVEL% NEQ 0 (
    echo %BBLUE%%BLACK%Falha ao extrair o arquivo Arquivos.rar.%RESET%
    pause
) else (
echo %BGREEN%%BLACK%Arquivos RAR extraídos com sucesso! %RESET%
)

rem Extraindo Defender Blocker para desativar o Defender
if exist "%pasta_instalacao%\WinDef.rar" (
    echo %BRED%%BLACK%Extraindo WinDef.rar...%RESET%
    "C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%pasta_instalacao%\WinDef.rar" "%pasta_windef%\"
    if %ERRORLEVEL% NEQ 0 (
        echo %BBLUE%%BLACK%Falha ao extrair o arquivo WinDef.rar.%RESET%
        pause
    ) else (
        echo %BGREEN%%BLACK%Defender Control extraído com sucesso! %RESET%
        echo %BRED%%BLACK%Abrindo Defender Control...%RESET%
        :: powershell -Command "Start-Process '%pasta_windef%\WinDef\dControl.exe' -Verb runAs"
		start "" "%pasta_windef%\WinDef\dControl.exe"
        echo %BGREEN%%BLACK%Defender Control aberto com sucesso! %RESET%
		pause
    )
) else (
    echo %BBLUE%%BLACK%Arquivo WinDef.rar não encontrado.%RESET%
)

ping -n 5 127.0.0.1 > nul

echo %BRED%%BLACK%Copiando Wallpaper para a raiz do C:...%RESET%
copy "%pasta_instalacao%\Wallpaper.jpg" C:\ >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo %BRED%%BLACK%Falha ao copiar o Wallpaper.%RESET%
) else (
    echo %BGREEN%%BLACK%Wallpaper copiado com sucesso! %RESET%
)
ping -n 3 127.0.0.1 > nul

rem Instalação dos Programas: Firefox, Chrome, K-LiteCodecPack Full, Skype, Winrar, Adobe Acrobat Reader, AnyDesk e Java
echo %BRED%%BLACK%Instalando Programas...%RESET%
winget settings --enable InstallerHashOverride 

ping -n 6 127.0.0.1 > nul
winget install --id "RARLab.WinRAR" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 6 127.0.0.1 > nul
winget install --id "Mozilla.Firefox.ESR.pt-BR" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 6 127.0.0.1 > nul
winget install --id "Google.Chrome" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 6 127.0.0.1 > nul
winget install --id "Microsoft.Teams" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 6 127.0.0.1 > nul
winget install --id "CodecGuide.K-LiteCodecPack.Full" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 6 127.0.0.1 > nul
winget install --id "AnyDesk.AnyDesk" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 6 127.0.0.1 > nul
winget install --id "Adobe.Acrobat.Reader.64-bit" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 6 127.0.0.1 > nul
rem winget install --id=Microsoft.Skype -e --accept-source-agreements --accept-package-agreements
ping -n 8 127.0.0.1 > nul 
rem mata o processo do skype pois ao instalar ele ja abre sozinho
rem taskkill /f /im Skype.exe 
ping -n 6 127.0.0.1 > nul
winget install --id "Oracle.JavaRuntimeEnvironment" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 6 127.0.0.1 > nul
winget install --id "9NKSQGP7F2NH" --exact --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 6 127.0.0.1 > nul

rem Extraindo Arquivos.rar para a pasta de instalação
echo %BRED%%BLACK%Extraindo Arquivos.rar...%RESET%
"C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%arquivo_rar%" "%pasta_instalacao%\" 
if %ERRORLEVEL% NEQ 0 (
    echo %BBLUE%%BLACK%Falha ao extrair o arquivo Arquivos.rar.%RESET%
    pause    
) else (
echo %BGREEN%%BLACK%Arquivos RAR extraídos com sucesso! %RESET%
)

ping -n 5 127.0.0.1 > nul

echo %BRED%%BLACK%Iniciando a instalação dos aplicativos em 10 segundos! %RESET%
ping -n 10 127.0.0.1 > nul
echo %BRED%Instalando aplicativos...%RESET%
:: Navega pelos arquivos na pasta especificada
setlocal enabledelayedexpansion
set "encontrou=0"
set "pasta_apps=%USERPROFILE%\Desktop\Nova Pasta"
for %%f in ("%pasta_instalacao%\*.exe") do (
    set "encontrou=1"
    echo %BRED%%BLACK%Instalando %%~nxf...%RESET%
    start /wait "Instalando" "%%f" /silent /install /wait
	echo %BGREEN%%BLACK% %%~nxf instalado com sucesso! %RESET%
)
if !encontrou! equ 0 (
    echo %BRED%%BLACK%Nenhum aplicativo encontrado para instalar.%RESET%
)

ping -n 10 127.0.0.1 > nul

rem Extraindo o Office 2021.rar para a pasta "Office 2021"
if exist "%pasta_instalacao%\Office 2021.rar" (
    echo %BRED%%BLACK%Extraindo Office 2021.rar...%RESET%
    md "%pasta_office%" >nul 2>&1
    "C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%pasta_instalacao%\Office 2021.rar" "%pasta_office%\" 
    if %ERRORLEVEL% NEQ 0 (
        echo %BRED%%BLACK%Falha ao extrair o arquivo Office 2021.rar.%RESET%
        pause
        
    ) else (
    echo %BGREEN%%BLACK%Office 2021 extraído com sucesso! %RESET%
	)
) else (
    echo %BRED%%BLACK%Arquivo Office 2021.rar não encontrado.%RESET%
)

ping -n 5 127.0.0.1 > nul


echo %BRED%%BLACK%Iniciando a instalação do Office... %RESET%
"%USERPROFILE%\Desktop\Nova Pasta\Office 2021\Office 2013-2021 C2R Install v7.3.6\OInstall.exe" /configure "%USERPROFILE%\Desktop\Nova Pasta\Office 2021\Office 2013-2021 C2R Install v7.3.6\files\Configure.xml" /wait
echo %BGREEN%%BLACK%Office instalado! %RESET%
rem fechar office com taskkill
ping -n 10 127.0.0.1 > nul
echo %BRED%%BLACK%Instalando chave do office e fazendo a ativação... %RESET%
powershell -Command "& ([ScriptBlock]::Create((irm https://get.activated.win))) /Ohook /S"
echo %BGREEN%%BLACK%Office ativado com sucesso! %RESET%
ping -n 10 127.0.0.1 > nul

echo %BRED%%BLACK%Coletando informações do Windows... %RESET%
echo %BRED%%BLACK%Checando se possui licença instalada... %RESET%
rem Coletando informações sobre o status da ativação e a chave instalada
for /f %%A in ('powershell -command "(Get-CimInstance -ClassName SoftwareLicensingProduct | Where-Object { $_.Name -like '*Windows*' -and $_.PartialProductKey } | Select-Object -First 1 -ExpandProperty LicenseStatus)"') do (
    set "status=%%A"
)
rem Verificando se há uma chave de produto válida instalada
for /f %%B in ('powershell -command "(Get-CimInstance -ClassName SoftwareLicensingProduct | Where-Object { $_.Name -like '*Windows*' -and $_.LicenseStatus -eq 1 } | Select-Object -First 1 -ExpandProperty PartialProductKey)"') do (
    set "productKey=%%B"
)
rem Se o status for 1 (ativado) ou já houver uma chave válida, não ativa novamente
if "%status%"=="1" (
    echo %BBLUE%%BLACK%Windows já está ativado! %RESET%
) else if defined productKey (
    echo %BBLUE%%BLACK%Chave de produto instalada. Não será necessário a ativação digital.%RESET%
) else (
    rem Se não houver chave válida, ativa com a licença digital
    echo %BRED%%BLACK%Iniciando a ativação do Windows... %RESET%
    ping -n 5 127.0.0.1 > nul
    powershell -Command "& ([ScriptBlock]::Create((irm https://get.activated.win))) /HWID-NoEditionChange /S"
    echo %BGREEN%%BLACK%Windows ativado com sucesso! %RESET%
)


:: Google Chrome
set "chromeExe=C:\Program Files\Google\Chrome\Applicationchrome.exe"
if exist "%chromeExe%" (
    echo %BGREEN%%BLACK%Google Chrome já está instalado.%RESET%
) else (
    echo %BRED%%BLACK%Google Chrome não encontrado. Instalando em nova janela...%RESET%
	curl -L -o "%USERPROFILE%\Downloads\googlechromestandaloneenterprise64.msi" "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi"
	ping -n 5 127.0.0.1 > nul
	start "" /wait "%USERPROFILE%\Downloads\googlechromestandaloneenerprise64.msi" /quiet /norestart
)

:: Mozilla Firefox
set "firefoxExe=%ProgramFiles%\Mozilla Firefox\firefox.exe"
if exist "%firefoxExe%" (
    echo %BGREEN%%BLACK%Mozilla Firefox já está instalado.%RESET%
) else (
    echo %BRED%%BLACK%Mozilla Firefox não encontrado. Instalando em nova janela... %RESET%
	curl -L -o "%USERPROFILE%\Downloads\Firefox Setup 128.10.0esr.exe" "https://download-installer.cdn.mozilla.net/pub/firefox/releases/128.10.0esr/win64/pt-BR/Firefox%20Setup%20128.10.0esr.exe"
	ping -n 5 127.0.0.1 > nul
	start "" /wait "%USERPROFILE%\Downloads\Firefox Setup 128.10.0esr.exe" /quiet /norestart

)

:: Adobe Acrobat Reader
set "acrobatExe=C:\Program Files\Adobe\Acrobat DC\Acrobat\AcroRd32.exe"
set "acrobatExe2=C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe"
if exist "%acrobatExe%" (
    echo %BGREEN%%BLACK%Adobe Acrobat Reader já está instalado.%RESET%
) else if exist "%acrobatExe2%" (
    echo %BGREEN%%BLACK%Adobe Acrobat Reader já está instalado.%RESET%
) else (
    echo %BRED%%BLACK%Adobe Acrobat Reader não encontrado. Instalando em nova janela...%RESET%
	curl -L -o "%USERPROFILE%\Downloads\AcroRdrDCx642500120474_MUI.exe" "https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/2500120474/AcroRdrDCx642500120474_MUI.exe"
	ping -n 5 127.0.0.1 > nul
	start "" /wait "%USERPROFILE%\Downloads\AcroRdrDCx642500120474_MUI.exe" /quiet /norestart
)

:: AnyDesk
set "anydeskExe=C:\Program Files (x86)\AnyDesk\AnyDesk.exe"
if exist "%anydeskExe%" (
    echo %BGREEN%%BLACK%AnyDesk já está instalado.%RESET%
) else (
    echo %BRED%%BLACK%AnyDesk não encontrado. Instalando em nova janela...%RESET%
	curl -L -o "%USERPROFILE%\Downloads\AnyDesk.exe" "https://download.anydesk.com/AnyDesk.exe?t=20250508"
	ping -n 5 127.0.0.1 > nul
	start "" "%USERPROFILE%\Downloads\AnyDesk.exe"
)


ping -n 10 127.0.0.1 > nul
echo %BBLUE%%BLACK%Instalação Básica concluída. %RESET%
pause
goto MENU_INSTALACAO

:MENU_INSTALACAO_GAMER
cls
call :banner
setlocal EnableDelayedExpansion

powercfg /S SCHEME_MIN
ping -n 1 127.0.0.1 > nul
powercfg -change -monitor-timeout-ac 0
powercfg -change -monitor-timeout-dc 0
powercfg -change -disk-timeout-ac 0
powercfg -change -disk-timeout-dc 0
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 0
powercfg -change -hibernate-timeout-ac 0
powercfg -change -hibernate-timeout-dc 0

echo %BRED%%BLACK%Abrindo Windows Update... %RESET%
start ms-settings:windowsupdate
echo %BGREEN%%BLACK%Windows Update aberto com sucesso! %RESET%
pause

rem INPUT BOX
:: Abre uma caixa de entrada para o usuário digitar um conteúdo
:: for /f "delims=" %%a in ('powershell -Command "Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.Interaction]::InputBox('Digite o conteúdo:', 'Entrada de Texto', 'Valor padrão')"') do set resultado=%%a
:: echo O conteúdo digitado foi: %resultado%
:: pause

rem SIM OU NAO BOX
:: setlocal
:: Exibe a caixa de mensagem usando System.Windows.Forms
:: powershell -Command "Add-Type -AssemblyName System.Windows.Forms; $result = [System.Windows.Forms.MessageBox]::Show('Deseja continuar?', 'Confirmação', [System.Windows.Forms.MessageBoxButtons]::YesNo); if ($result -eq [System.Windows.Forms.DialogResult]::Yes) { exit 1 } else { exit 0 }"
:: if %ERRORLEVEL%==1 (
::     echo Você escolheu SIM.
:: ) else (
::     echo Você escolheu NÃO.
:: )



rem MESSAGEBOX
:: setlocal
:: Exibe a caixa de mensagem com apenas o botão OK
:: powershell -Command "Add-Type -AssemblyName System.Windows.Forms; $result = [System.Windows.Forms.MessageBox]::Show('Operação confirmada!', 'Confirmação', [System.Windows.Forms.MessageBoxButtons]::OK); if ($result -eq [System.Windows.Forms.DialogResult]::OK) { exit 1 } else { exit 0 }"
:: if %ERRORLEVEL%==1 (
::    echo Você confirmou a ação.
:: ) else (
::     echo Nenhuma ação foi confirmada.
:: )




powershell -Command "Add-Type -AssemblyName System.Windows.Forms; $result = [System.Windows.Forms.MessageBox]::Show('Deseja instalar as dependências?', 'Confirmação', [System.Windows.Forms.MessageBoxButtons]::YesNo); if ($result -eq [System.Windows.Forms.DialogResult]::Yes) { exit 1 } else { exit 0 }"
if %ERRORLEVEL%==1 (
    rem Coloque aqui os comandos para instalar as dependências
    call :Depend
    rem Exemplo: call instalar_dependencias.bat
) else (
    echo %BBLUE%%BLACK%As dependências não serão instaladas! %RESET%
)

winget install --id=RARLab.WinRAR -e --accept-source-agreements --accept-package-agreements

rem Baixar Aplicativos usando Curl
curl --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo %BRED%%BLACK%O curl não está instalado ou não está no PATH.%RESET%
    echo %BRED%%BLACK%Instalando cURL... %RESET%
    winget install --id=cURL.cURL -e --accept-source-agreements --accept-package-agreements
    if %ERRORLEVEL% NEQ 0 (
        echo %BBLUE%%BLACK%Falha ao instalar o cURL.%RESET%
        pause
        goto :MENU
    )
    echo %BGREEN%%BLACK%cURL instalado com sucesso! %RESET%
) else (
    echo %BGREEN%%BLACK%cURL já está instalado! %RESET%
)

rem Definir variáveis de pasta e arquivos
set "pasta_instalacao=%USERPROFILE%\Desktop\Nova Pasta"
set "pasta_office=%pasta_instalacao%\Office 2021"
set "pasta_aact=%pasta_instalacao%\AAct_Network_x64"
set "arquivo_rar=%pasta_instalacao%\Arquivos.rar"
set "arquivo_windef=%pasta_instalacao%\WinDef.rar"
set "pasta_windef=%pasta_instalacao%\WinDef\"
set "link_dropbox=https://www.dropbox.com/s/geisbvplfws907e/Arquivos.rar?st=7d958qjl&dl=1" 

rem Verifica se a pasta de instalação já existe, caso contrário cria
if not exist "%pasta_instalacao%" (
    echo %BRED%%BLACK%Criando pasta da instalação dos programas...%RESET%
    md "%pasta_instalacao%" >nul 2>&1
        echo %BGREEN%%BLACK%Pasta criada com sucesso! %RESET%
)

ping -n 2 127.0.0.1 > nul

rem Baixando o arquivo Arquivos.rar
echo %BRED%%BLACK%Baixando o arquivo Arquivos.rar... %RESET%
curl -L -o "%arquivo_rar%" "%link_dropbox%"
if %ERRORLEVEL% NEQ 0 (
    echo %BBLUE%%BLACK%Falha ao baixar o arquivo Arquivos.rar.%RESET%
    pause
    goto :MENU
) else (
echo %BGREEN%%BLACK%Arquivo Arquivos.rar baixado com sucesso! %RESET%
)

ping -n 5 127.0.0.1 > nul
winget install --id=RARLab.WinRAR -e --accept-source-agreements --accept-package-agreements
ping -n 5 127.0.0.1 > nul

echo %BRED%%BLACK%Abrindo painel do Windows Defender, por favor, desativa-lo...%RESET%
start windowsdefender://threat
pause

rem Extraindo Arquivos.rar para a pasta de instalação
echo %BRED%%BLACK%Extraindo Arquivos.rar...%RESET%
"C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%arquivo_rar%" "%pasta_instalacao%\" 
if %ERRORLEVEL% NEQ 0 (
    echo %BBLUE%%BLACK%Falha ao extrair o arquivo Arquivos.rar.%RESET%
    pause
) else (
echo %BGREEN%%BLACK%Arquivos RAR extraídos com sucesso! %RESET%
)

rem Extraindo Defender Blocker para desativar o Defender
if exist "%pasta_instalacao%\WinDef.rar" (
    echo %BRED%%BLACK%Extraindo WinDef.rar...%RESET%
    "C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%pasta_instalacao%\WinDef.rar" "%pasta_windef%\"
    if %ERRORLEVEL% NEQ 0 (
        echo %BBLUE%%BLACK%Falha ao extrair o arquivo WinDef.rar.%RESET%
        pause
    ) else (
        echo %BGREEN%%BLACK%Defender Control extraído com sucesso! %RESET%
        echo %BRED%%BLACK%Abrindo Defender Control...%RESET%
        :: powershell -Command "Start-Process '%pasta_windef%\WinDef\dControl.exe' -Verb runAs"
		start "" "%pasta_windef%\WinDef\dControl.exe"
        echo %BGREEN%%BLACK%Defender Control aberto com sucesso! %RESET%
		pause
    )
) else (
    echo %BBLUE%%BLACK%Arquivo WinDef.rar não encontrado.%RESET%
)

ping -n 5 127.0.0.1 > nul

echo %BRED%%BLACK%Copiando Wallpaper para a raiz do C:...%RESET%
copy "%pasta_instalacao%\Wallpaper.jpg" C:\ >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo %BRED%%BLACK%Falha ao copiar o Wallpaper.%RESET%
) else (
    echo %BGREEN%%BLACK%Wallpaper copiado com sucesso! %RESET%
)
ping -n 3 127.0.0.1 > nul

rem Instalação dos Programas: Firefox, Chrome, K-LiteCodecPack Full, Skype, Winrar, Adobe Acrobat Reader, AnyDesk e Java
echo %BRED%%BLACK%Instalando Programas...%RESET%
winget settings --enable InstallerHashOverride 

ping -n 6 127.0.0.1 > nul
winget install --id "RARLab.WinRAR" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 6 127.0.0.1 > nul
winget install --id "Mozilla.Firefox.ESR.pt-BR" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 6 127.0.0.1 > nul
winget install --id "Google.Chrome" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 6 127.0.0.1 > nul
winget install --id "Microsoft.Teams" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 6 127.0.0.1 > nul
winget install --id "CodecGuide.K-LiteCodecPack.Full" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 6 127.0.0.1 > nul
winget install --id "AnyDesk.AnyDesk" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 6 127.0.0.1 > nul
winget install --id "Adobe.Acrobat.Reader.64-bit" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 6 127.0.0.1 > nul
rem winget install --id=Microsoft.Skype -e --accept-source-agreements --accept-package-agreements
ping -n 8 127.0.0.1 > nul 
rem mata o processo do skype pois ao instalar ele ja abre sozinho
rem taskkill /f /im Skype.exe 
ping -n 6 127.0.0.1 > nul
winget install --id "Oracle.JavaRuntimeEnvironment" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 6 127.0.0.1 > nul
winget install --id "Microsoft.VCRedist.2005.x86" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 3 127.0.0.1 > nul
winget install --id "Microsoft.VCRedist.2005.x64" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 3 127.0.0.1 > nul
winget install --id "Microsoft.VCRedist.2008.x86" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 3 127.0.0.1 > nul
winget install --id "Microsoft.VCRedist.2008.x64" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 3 127.0.0.1 > nul
winget install --id "Microsoft.VCRedist.2010.x86" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 3 127.0.0.1 > nul
winget install --id "Microsoft.VCRedist.2010.x64" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 3 127.0.0.1 > nul
winget install --id "Microsoft.VCRedist.2012.x86" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 3 127.0.0.1 > nul
winget install --id "Microsoft.VCRedist.2012.x64" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 3 127.0.0.1 > nul
winget install --id "Microsoft.VCRedist.2013.x86" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 3 127.0.0.1 > nul
winget install --id "Microsoft.VCRedist.2013.x64" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 3 127.0.0.1 > nul
winget install --id "Microsoft.VCRedist.2015+.x86" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 3 127.0.0.1 > nul
winget install --id "Microsoft.VCRedist.2015+.x64" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 3 127.0.0.1 > nul
winget install --id "Microsoft.VCRedist.2017.x86" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 3 127.0.0.1 > nul
winget install --id "Microsoft.VCRedist.2017.x64" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 3 127.0.0.1 > nul
winget install --id "Microsoft.VCRedist.2019.x86" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 3 127.0.0.1 > nul
winget install --id "Microsoft.VCRedist.2019.x64" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 3 127.0.0.1 > nul
winget install --id "Microsoft.VCRedist.2022.x86" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 3 127.0.0.1 > nul
winget install --id "Microsoft.VCRedist.2022.x64" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 3 127.0.0.1 > nul
winget install --id "Microsoft.DotNet.Framework.DeveloperPack.4.5" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 3 127.0.0.1 > nul
winget install --id "Microsoft.DotNet.Framework.DeveloperPack.4.6" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 3 127.0.0.1 > nul
winget install --id "Microsoft.DotNet.Runtime.9" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 3 127.0.0.1 > nul
winget install --id "Valve.Steam" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 2 127.0.0.1 > nul
winget install --id "Microsoft.DirectX" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 3 127.0.0.1 > nul
winget install --id "Discord.Discord" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 3 127.0.0.1 > nul
winget install --id "9NKSQGP7F2NH" --exact --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
ping -n 5 127.0.0.1 > nul


rem Extraindo Arquivos.rar para a pasta de instalação
echo %BRED%%BLACK%Extraindo Arquivos.rar...%RESET%
"C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%arquivo_rar%" "%pasta_instalacao%\" 
if %ERRORLEVEL% NEQ 0 (
    echo %BBLUE%%BLACK%Falha ao extrair o arquivo Arquivos.rar.%RESET%
    pause    
) else (
echo %BGREEN%%BLACK%Arquivos RAR extraídos com sucesso! %RESET%
)

ping -n 5 127.0.0.1 > nul

echo %BRED%%BLACK%Iniciando a instalação dos aplicativos em 10 segundos! %RESET%
ping -n 10 127.0.0.1 > nul
echo %BRED%Instalando aplicativos...%RESET%
:: Navega pelos arquivos na pasta especificada
setlocal enabledelayedexpansion
set "encontrou=0"
set "pasta_apps=%USERPROFILE%\Desktop\Nova Pasta"
for %%f in ("%pasta_instalacao%\*.exe") do (
    set "encontrou=1"
    echo %BRED%%BLACK%Instalando %%~nxf...%RESET%
    start /wait "Instalando" "%%f" /silent /install /wait
	echo %BGREEN%%BLACK% %%~nxf instalado com sucesso! %RESET%
)
if !encontrou! equ 0 (
    echo %BRED%%BLACK%Nenhum aplicativo encontrado para instalar.%RESET%
)

ping -n 10 127.0.0.1 > nul

rem Extraindo o Office 2021.rar para a pasta "Office 2021"
if exist "%pasta_instalacao%\Office 2021.rar" (
    echo %BRED%%BLACK%Extraindo Office 2021.rar...%RESET%
    md "%pasta_office%" >nul 2>&1
    "C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%pasta_instalacao%\Office 2021.rar" "%pasta_office%\" 
    if %ERRORLEVEL% NEQ 0 (
        echo %BRED%%BLACK%Falha ao extrair o arquivo Office 2021.rar.%RESET%
        pause
        
    ) else (
    echo %BGREEN%%BLACK%Office 2021 extraído com sucesso! %RESET%
	)
) else (
    echo %BRED%%BLACK%Arquivo Office 2021.rar não encontrado.%RESET%
)

ping -n 5 127.0.0.1 > nul


echo %BRED%%BLACK%Iniciando a instalação do Office... %RESET%
"%USERPROFILE%\Desktop\Nova Pasta\Office 2021\Office 2013-2021 C2R Install v7.3.6\OInstall.exe" /configure "%USERPROFILE%\Desktop\Nova Pasta\Office 2021\Office 2013-2021 C2R Install v7.3.6\files\Configure.xml" /wait
echo %BGREEN%%BLACK%Office instalado! %RESET%
rem fechar office com taskkill
ping -n 10 127.0.0.1 > nul
echo %BRED%%BLACK%Instalando chave do office e fazendo a ativação... %RESET%
powershell -Command "& ([ScriptBlock]::Create((irm https://get.activated.win))) /Ohook /S"
echo %BGREEN%%BLACK%Office ativado com sucesso! %RESET%
ping -n 10 127.0.0.1 > nul

echo %BRED%%BLACK%Coletando informações do Windows... %RESET%
echo %BRED%%BLACK%Checando se possui licença instalada... %RESET%
rem Coletando informações sobre o status da ativação e a chave instalada
for /f %%A in ('powershell -command "(Get-CimInstance -ClassName SoftwareLicensingProduct | Where-Object { $_.Name -like '*Windows*' -and $_.PartialProductKey } | Select-Object -First 1 -ExpandProperty LicenseStatus)"') do (
    set "status=%%A"
)
rem Verificando se há uma chave de produto válida instalada
for /f %%B in ('powershell -command "(Get-CimInstance -ClassName SoftwareLicensingProduct | Where-Object { $_.Name -like '*Windows*' -and $_.LicenseStatus -eq 1 } | Select-Object -First 1 -ExpandProperty PartialProductKey)"') do (
    set "productKey=%%B"
)
rem Se o status for 1 (ativado) ou já houver uma chave válida, não ativa novamente
if "%status%"=="1" (
    echo %BBLUE%%BLACK%Windows já está ativado! %RESET%
) else if defined productKey (
    echo %BBLUE%%BLACK%Chave de produto instalada. Não será necessário a ativação digital.%RESET%
) else (
    rem Se não houver chave válida, ativa com a licença digital
    echo %BRED%%BLACK%Iniciando a ativação do Windows... %RESET%
    ping -n 5 127.0.0.1 > nul
    powershell -Command "& ([ScriptBlock]::Create((irm https://get.activated.win))) /HWID-NoEditionChange /S"
    echo %BGREEN%%BLACK%Windows ativado com sucesso! %RESET%
)

:: Google Chrome
set "chromeExe=C:\Program Files\Google\Chrome\Applicationchrome.exe"
if exist "%chromeExe%" (
    echo %BGREEN%%BLACK%Google Chrome já está instalado.%RESET%
) else (
    echo %BRED%%BLACK%Google Chrome não encontrado. Instalando em nova janela...%RESET%
	curl -L -o "%USERPROFILE%\Downloads\googlechromestandaloneenterprise64.msi" "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi"
	ping -n 5 127.0.0.1 > nul
	start "" /wait "%USERPROFILE%\Downloads\googlechromestandaloneenerprise64.msi" /quiet /norestart
)

:: Mozilla Firefox
set "firefoxExe=%ProgramFiles%\Mozilla Firefox\firefox.exe"
if exist "%firefoxExe%" (
    echo %BGREEN%%BLACK%Mozilla Firefox já está instalado.%RESET%
) else (
    echo %BRED%%BLACK%Mozilla Firefox não encontrado. Instalando em nova janela... %RESET%
	curl -L -o "%USERPROFILE%\Downloads\Firefox Setup 128.10.0esr.exe" "https://download-installer.cdn.mozilla.net/pub/firefox/releases/128.10.0esr/win64/pt-BR/Firefox%20Setup%20128.10.0esr.exe"
	ping -n 5 127.0.0.1 > nul
	start "" /wait "%USERPROFILE%\Downloads\Firefox Setup 128.10.0esr.exe" /quiet /norestart

)

:: Adobe Acrobat Reader
set "acrobatExe=C:\Program Files\Adobe\Acrobat DC\Acrobat\AcroRd32.exe"
set "acrobatExe2=C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe"
if exist "%acrobatExe%" (
    echo %BGREEN%%BLACK%Adobe Acrobat Reader já está instalado.%RESET%
) else if exist "%acrobatExe2%" (
    echo %BGREEN%%BLACK%Adobe Acrobat Reader já está instalado.%RESET%
) else (
    echo %BRED%%BLACK%Adobe Acrobat Reader não encontrado. Instalando em nova janela...%RESET%
	curl -L -o "%USERPROFILE%\Downloads\AcroRdrDCx642500120474_MUI.exe" "https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/2500120474/AcroRdrDCx642500120474_MUI.exe"
	ping -n 5 127.0.0.1 > nul
	start "" /wait "%USERPROFILE%\Downloads\AcroRdrDCx642500120474_MUI.exe" /quiet /norestart
)

:: AnyDesk
set "anydeskExe=C:\Program Files (x86)\AnyDesk\AnyDesk.exe"
if exist "%anydeskExe%" (
    echo %BGREEN%%BLACK%AnyDesk já está instalado.%RESET%
) else (
    echo %BRED%%BLACK%AnyDesk não encontrado. Instalando em nova janela...%RESET%
	curl -L -o "%USERPROFILE%\Downloads\AnyDesk.exe" "https://download.anydesk.com/AnyDesk.exe?t=20250508"
	ping -n 5 127.0.0.1 > nul
	start "" "%USERPROFILE%\Downloads\AnyDesk.exe"
)




ping -n 10 127.0.0.1 > nul
echo %BBLUE%%BLACK%Instalação Gamer concluída. %RESET%
pause
goto MENU_INSTALACAO

:MENU_INSTALACAO_DESIGN
echo Instalando Ferramentas de Design...
echo Em andamento...
REM Instalar uTorrent, Programas de edição, DirectX, Drivers

:: Exemplo de busca e cópia do arquivo .torrent
:: set SERVER_PATH=\\ip_do_servidor\shared_folder
:: set DEST_PATH=%USERPROFILE%\Downloads\torrents 
:: mkdir "%DEST_PATH%"
:: copy "%SERVER_PATH%\design_software.torrent" "%DEST_PATH%"
:: echo Arquivo .torrent copiado para %DEST_PATH%

pause
goto MENU_INSTALACAO

:MENU_INSTALACAO_TERACOPY
:: Baixe o arquivo do link fornecido para a pasta Downloads
curl -L -o "%USERPROFILE%\Downloads\TeraCopy.rar" "https://www.dropbox.com/scl/fo/2klf9ms8shwm5wo2n6bfm/ACsI_uP2igyDEYRXArFuupU?rlkey=j2j19w2kzp94qu8nwqudjtyhn&st=r18biotz&dl=1"
:: Extraia o conteúdo do arquivo baixado para a pasta Downloads (supondo que WinRAR esteja instalado)
"%ProgramFiles%\WinRAR\WinRAR.exe" x -y -o+ "%USERPROFILE%\Downloads\TeraCopy.rar" "%USERPROFILE%\Downloads\TeraCopy_Extracted\"
:: Instale o TeraCopy de forma silenciosa
start "" "%USERPROFILE%\Downloads\TeraCopy_Extracted\teracopy.exe" /silent /wait
ping -n 20 127.0.0.1 > nul
:: Copie o arquivo de licença para %AppData%\TeraCopy (ajuste se necessário)
xcopy "%USERPROFILE%\Downloads\TeraCopy_Extracted\license" "%AppData%\TeraCopy\" /Y
if errorlevel 1 (
    echo %BBLUE%%BLACK%Erro ao copiar o arquivo de licença. %RESET%
	echo|set /p=LVUWAASAAAQiZVYo1qgEjzEgz/SJHjP6eKs3QeQscXDwt2ZfS6gcS1jufZrn47Wv ul9345mlg/wka6nQzRPcvk5sB6O2L0xCgOu7BPgGfhz4dV9NnjxLqUvrKGOWxg2j 7ZpxO+Kn0hRcMynPksvmHNMw/2h5LEmMq+mouuOD5cxJelNPC8FPJXerpf3tqFHQ Q/sqNB1hTiXfuHNijVe9GB9egrXVevmn1LqAesqOU+uHoBql9e47C5eV3KOVjVEt DHFK5x3yXpA8dIwzf9xw7LZkqNFcPaZHWlcvSYxUNPf4VY4+O2/Taqj8OrvM7LrM jp5Z0Jf75M859gYplFU7rlNKxiQ7l/rBLYn2ZAZwSWt4a4VleQcEwKrCGeKvpT/p f0oYAgkMXXklHS58TQVIqWP2EVwlGUi4<nul | clip
    pause
    goto MENU_INSTALACAO
) else (
    echo %BGREEN%%BLACK%Teracopy instalado e ativado com sucesso! %RESET%
	echo|set /p=LVUWAASAAAQiZVYo1qgEjzEgz/SJHjP6eKs3QeQscXDwt2ZfS6gcS1jufZrn47Wv ul9345mlg/wka6nQzRPcvk5sB6O2L0xCgOu7BPgGfhz4dV9NnjxLqUvrKGOWxg2j 7ZpxO+Kn0hRcMynPksvmHNMw/2h5LEmMq+mouuOD5cxJelNPC8FPJXerpf3tqFHQ Q/sqNB1hTiXfuHNijVe9GB9egrXVevmn1LqAesqOU+uHoBql9e47C5eV3KOVjVEt DHFK5x3yXpA8dIwzf9xw7LZkqNFcPaZHWlcvSYxUNPf4VY4+O2/Taqj8OrvM7LrM jp5Z0Jf75M859gYplFU7rlNKxiQ7l/rBLYn2ZAZwSWt4a4VleQcEwKrCGeKvpT/p f0oYAgkMXXklHS58TQVIqWP2EVwlGUi4<nul | clip
	
)
ping -n 15 127.0.0.1 > nul
:: Limpeza de arquivos temporários
del "%USERPROFILE%\Downloads\TeraCopy.rar"
rmdir /S /Q "%USERPROFILE%\Downloads\TeraCopy_Extracted"
ping -n 2 127.0.0.1 > nul
echo %BBLUE%%BLACK%TeraCopy instalado e licença copiada com sucesso. %RESET%
pause

powershell -Command "Add-Type -AssemblyName System.Windows.Forms; $result = [System.Windows.Forms.MessageBox]::Show('Deseja acessar o servidor?', 'Confirmação', [System.Windows.Forms.MessageBoxButtons]::YesNo); if ($result -eq [System.Windows.Forms.DialogResult]::Yes) { exit 1 } else { exit 0 }"
if %ERRORLEVEL%==1 (
   echo %BRED%%BLACK%Acessando o servidor... %RESET%
   net use \\192.168.2.153 Gaiola@2024 /user:Administrador
start \\192.168.2.153
net use \\192.168.2.153 /delete
   echo %BRED%%BLACK%Conexão com o servidor feita! %RESET%
) else (
   echo %BRED%%BLACK%Prosseguindo...%RESET%
)

goto MENU_INSTALACAO

:MENU_INSTALACAO_TORRENTS

setlocal
:: Exibe a caixa de mensagem usando System.Windows.Forms
powershell -Command "Add-Type -AssemblyName System.Windows.Forms; $result = [System.Windows.Forms.MessageBox]::Show('Deseja instalar o uTorrent?', 'Confirmação', [System.Windows.Forms.MessageBoxButtons]::YesNo); if ($result -eq [System.Windows.Forms.DialogResult]::Yes) { exit 1 } else { exit 0 }"
if %ERRORLEVEL%==1 (
    echo %BRED%%BLACK%Instalando uTorrent...%RESET%
    curl -L -o "%USERPROFILE%\Downloads\utorrent_installer.exe" "https://download-hr.utorrent.com/track/stable/endpoint/utorrent/os/riserollout?filename=utorrent_installer.exe"
	start "" "%USERPROFILE%\Downloads\utorrent_installer.exe"
    echo %BGREEN%%BLACK%uTorrent foi instalado com sucesso! %RESET%
) else (
    echo %BBLUE%%BLACK%uTorrent não será instalado. %RESET%
)

endlocal

:: Caminho do banco de dados
set "banco_dados=%USERPROFILE%\Downloads\Nogatec\banco_dados.txt"

:: Verifica se a pasta Nogatec existe, caso contrário, cria
if not exist "%USERPROFILE%\Downloads\Nogatec" (
    echo %BGREEN%%BLACK%Pasta criada com sucesso! %RESET%
    mkdir "%USERPROFILE%\Downloads\Nogatec"
)

:: Agora, continua com o restante do script, como baixar o banco de dados, etc.
if not exist "%banco_dados%" (
    echo %BRED%%BLACK%Baixando banco de dados...%RESET%
    curl -L -o "%banco_dados%" "https://www.dropbox.com/scl/fi/cxbzrmiqhdmnn0fcr179n/banco_dados.txt?rlkey=ta3ib4bo77qq9aoetspkpbh3p&st=ifwes8uq&dl=0"
    echo %BGREEN%%BLACK%Banco de dados baixado com sucesso! %RESET%
)

cls
call :banner
echo                ╔════════════════════════════════════════════════════════════════════════════╗
echo                ║                                                                            ║
echo                ║     1 - Pesquisar Aplicativo                                               ║
echo                ║                                                                            ║
echo                ║     2 - Voltar ao menu anterior                                            ║
echo                ║                                                                            ║
echo                ╚════════════════════════════════════════════════════════════════════════════╝
echo.
echo.
choice /c 12 /n /m "Escolha uma opção: "
set choice=%errorlevel%
if "%opcao%"=="1" goto MENU_INSTALACAO_TORRENTS_PESQUISAR
if "%opcao%"=="2" goto MENU_INSTALACAO

:MENU_INSTALACAO_TORRENTS_PESQUISAR
cls
call :banner
set /p "nome=Digite o nome do aplicativo: "
setlocal EnableDelayedExpansion
set "encontrado=0"
set "base=%USERPROFILE%\Downloads\Torrents"

echo.

:: Procurar pastas que contenham o nome
for /d %%a in ("%base%\*%nome%*") do (
    set /a encontrado+=1
    echo !encontrado!. %%~nxa
    set "pasta_!encontrado!=%%a"
)

:: Se não encontrar nada
if !encontrado! == 0 (
    echo %BBLUE%Nenhuma pasta foi encontrada com esse nome.%RESET%
    pause
    endlocal
    goto :MENU_INSTALACAO
)

:: Selecionar pasta encontrada
set /p "escolha=Escolha uma pasta pelo numero e pressione %GREEN%ENTER%RESET%: "
set "pasta_selecionada=!pasta_%escolha%!"

:: Ler o arquivo .info da pasta selecionada
for /f "tokens=1-5 delims=|" %%a in ('type "!pasta_selecionada!\info.txt"') do (
    set "app_selecionado=%%a"
    set "tipo_selecionado=%%b"
    set "link_selecionado_1=%%c"
    set "link_selecionado_2=%%d"
    set "origem_selecionado=%%e"
)

endlocal & (
    set "app_selecionado=%app_selecionado%"
    set "tipo_selecionado=%tipo_selecionado%"
    set "link_selecionado_1=%link_selecionado_1%"
    set "link_selecionado_2=%link_selecionado_2%"
    set "origem_selecionado=%origem_selecionado%"
)

goto :MENU_INSTALACAO_TORRENTS_CONFIRMAR


:MENU_INSTALACAO_TORRENTS_CONFIRMAR
cls
call :banner
echo.
echo.
echo                %WHITE%Nome: %GREEN%!app_selecionado!         %RESET%
echo                %WHITE%Método de Ativação: %GREEN%!tipo_selecionado!         %RESET%
echo                %WHITE%Fornecedor: %GREEN%!origem_selecionado!         %RESET%        
echo.
echo                %WHITE%URL De Download 1: %GREEN%!link_selecionado_1!         %RESET% 
echo                %WHITE%URL De Download 2: %GREEN%!link_selecionado_2!         %RESET% 
echo.
echo.
echo                ╔════════════════════════════════════════════════════════════════════════════╗
echo                ║                                 Detalhes                                   ║                             
echo                ║════════════════════════════════════════════════════════════════════════════║
echo                ║     1 - Baixar o arquivo selecionado (URL 1)                               ║
echo                ║     %BRED%%BLACK%2 - Baixar o arquivo selecionado (URL 2)%RESET%                               ║
echo                ║     3 - Voltar ao menu anterior                                            ║
echo                ╚════════════════════════════════════════════════════════════════════════════╝
echo.
echo.

set /p "opcao=Escolha uma opcao e pressione %GREEN%ENTER%RESET%: "

if "%opcao%"=="1" goto :MENU_INSTALACAO_TORRENTS_DOWNLOAD_1
if "%opcao%"=="" goto :MENU_INSTALACAO_TORRENTS_DOWNLOAD_2
if "%opcao%"=="3" goto :MENU_INSTALACAO_TORRENTS
goto MENU_INSTALACAO_TORRENTS

:MENU_INSTALACAO_TORRENTS_DOWNLOAD_1
cls
echo Baixando !app_selecionado! do Link 1...
echo %BRED%Fazendo o download de %BWHITE%%BLACK%!app_selecionado!...%RESET%
curl -L -o "%USERPROFILE%\Downloads\Nogatec\!app_selecionado!.rar" "!link_selecionado_1!"
echo %BWHITE%%BLACK%!app_selecionado! %RESET% %BGREEN%%BLACK%foi baixado com sucesso! %RESET%
pause
explorer "%USERPROFILE%\Downloads"
goto :MENU_INSTALACAO_TORRENTS

:MENU_INSTALACAO_TORRENTS_DOWNLOAD_2
cls
echo Baixando !app_selecionado! do Link 2...
echo %BRED%Fazendo o download de %BWHITE%%BLACK%!app_selecionado!...%RESET%
curl -L -o "%USERPROFILE%\Downloads\Nogatec\!app_selecionado!.rar" "!link_selecionado_2!"
echo %BWHITE%%BLACK%!app_selecionado! %RESET% %BGREEN%%BLACK%foi baixado com sucesso! %RESET%
pause
explorer "%USERPROFILE%\Downloads"
goto :MENU_INSTALACAO_TORRENTS

:MENU_INSTALACAO_WINDOWS
rem MENU ATIVAÇÕES
cls
call :banner
echo                ╔════════════════════════════════════════════════════════════════════════════╗
echo                ║                                Ativações                                   ║
echo                ║════════════════════════════════════════════════════════════════════════════║
echo                ║     1 - Office 2021 e Windows (Instalação + Ativações)                     ║
echo                ║     2 - Office 2021 (Instalação)                                           ║
echo                ║     3 - Ativação Office                                                    ║
echo                ║     4 - Ativação Windows                                                   ║
echo                ║     5 - Ativação Windows Server                                            ║
echo                ║     6 - Voltar ao Menu Anterior                                            ║
echo                ╚════════════════════════════════════════════════════════════════════════════╝
echo.
echo.
choice /c 123456 /n /m "Escolha uma opção: "
set install_choice=%errorlevel%

if "%install_choice%"=="1" goto MENU_INSTALACAO_WINDOWS_OFFICE
if "%install_choice%"=="2" goto MENU_INSTALACAO_WINDOWS_OFFICE2
if "%install_choice%"=="3" goto MENU_INSTALACAO_WINDOWS_OFFICE3
if "%install_choice%"=="4" goto MENU_INSTALACAO_WINDOWS_WINDOWS
if "%install_choice%"=="5" goto MENU_INSTALACAO_WINDOWS_SERVER
if "%install_choice%"=="6" goto MENU_INSTALACAO
goto MENU_INSTALACAO

:MENU_INSTALACAO_WINDOWS_OFFICE
setlocal EnableDelayedExpansion

powershell -Command "Add-Type -AssemblyName System.Windows.Forms; $result = [System.Windows.Forms.MessageBox]::Show('Possui Winrar?', 'Confirmação', [System.Windows.Forms.MessageBoxButtons]::YesNo); if ($result -eq [System.Windows.Forms.DialogResult]::Yes) { exit 1 } else { exit 0 }"
if %ERRORLEVEL%==1 (
	start "" "https://www.win-rar.com/download.html?&L=9"
) else (
    echo %BBLUE%%BLACK%Prosseguindo... %RESET%
)

rem Baixar Aplicativos usando Curl
curl --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo %BRED%%BLACK%O curl não está instalado ou não está no PATH.%RESET%
    echo %BRED%%BLACK%Instalando cURL... %RESET%
    winget install --id=cURL.cURL -e --accept-source-agreements --accept-package-agreements
    if %ERRORLEVEL% NEQ 0 (
        echo %BBLUE%%BLACK%Falha ao instalar o cURL.%RESET%
        pause
        goto :MENU
    )
    echo %BGREEN%%BLACK%cURL instalado com sucesso! %RESET%
) else (
    echo %BGREEN%%BLACK%cURL já está instalado! %RESET%
)

rem Definir variáveis de pasta e arquivos
set "pasta_instalacao=%USERPROFILE%\Desktop\Nova Pasta"
set "pasta_office=%pasta_instalacao%\Office 2021"
set "pasta_aact=%pasta_instalacao%\AAct_Network_x64"
set "arquivo_rar=%pasta_instalacao%\Arquivos.rar"
set "arquivo_windef=%pasta_instalacao%\WinDef.rar"
set "pasta_windef=%pasta_instalacao%\WinDef\"
set "link_dropbox=https://www.dropbox.com/s/geisbvplfws907e/Arquivos.rar?st=7d958qjl&dl=1" 

rem Verifica se a pasta de instalação já existe, caso contrário cria
if not exist "%pasta_instalacao%" (
    echo %BRED%%BLACK%Criando pasta da instalação dos programas...%RESET%
    md "%pasta_instalacao%" >nul 2>&1
        echo %BGREEN%%BLACK%Pasta criada com sucesso! %RESET%
)

ping -n 2 127.0.0.1 > nul

rem Baixando o arquivo Arquivos.rar
echo %BRED%%BLACK%Baixando o arquivo Arquivos.rar... %RESET%
curl -L -o "%arquivo_rar%" "%link_dropbox%"
if %ERRORLEVEL% NEQ 0 (
    echo %BBLUE%%BLACK%Falha ao baixar o arquivo Arquivos.rar.%RESET%
    pause
    goto :MENU
) else (
echo %BGREEN%%BLACK%Arquivo Arquivos.rar baixado com sucesso! %RESET%
)

ping -n 5 127.0.0.1 > nul
winget install --id=RARLab.WinRAR -e --accept-source-agreements --accept-package-agreements
ping -n 5 127.0.0.1 > nul

echo %BRED%%BLACK%Abrindo painel do Windows Defender, por favor, desativa-lo...%RESET%
start windowsdefender://threat
pause

rem Extraindo Arquivos.rar para a pasta de instalação
echo %BRED%%BLACK%Extraindo Arquivos.rar...%RESET%
"C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%arquivo_rar%" "%pasta_instalacao%\" 
if %ERRORLEVEL% NEQ 0 (
    echo %BBLUE%%BLACK%Falha ao extrair o arquivo Arquivos.rar.%RESET%
    pause
) else (
echo %BGREEN%%BLACK%Arquivos RAR extraídos com sucesso! %RESET%
)

rem Extraindo Defender Blocker para desativar o Defender
if exist "%pasta_instalacao%\WinDef.rar" (
    echo %BRED%%BLACK%Extraindo WinDef.rar...%RESET%
    "C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%pasta_instalacao%\WinDef.rar" "%pasta_windef%\"
    if %ERRORLEVEL% NEQ 0 (
        echo %BBLUE%%BLACK%Falha ao extrair o arquivo WinDef.rar.%RESET%
        pause
    ) else (
        echo %BGREEN%%BLACK%Defender Control extraído com sucesso! %RESET%
        echo %BRED%%BLACK%Abrindo Defender Control...%RESET%
        :: powershell -Command "Start-Process '%pasta_windef%\WinDef\dControl.exe' -Verb runAs"
		start "" "%pasta_windef%\WinDef\dControl.exe"
        echo %BGREEN%%BLACK%Defender Control aberto com sucesso! %RESET%
		pause
    )
) else (
    echo %BBLUE%%BLACK%Arquivo WinDef.rar não encontrado.%RESET%
)

rem Extraindo Arquivos.rar para a pasta de instalação
echo %BRED%%BLACK%Extraindo Arquivos.rar...%RESET%
"C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%arquivo_rar%" "%pasta_instalacao%\" 
if %ERRORLEVEL% NEQ 0 (
    echo %BBLUE%%BLACK%Falha ao extrair o arquivo Arquivos.rar.%RESET%
    pause    
) else (
echo %BGREEN%%BLACK%Arquivos RAR extraídos com sucesso! %RESET%
)
rem Extraindo o Office 2021.rar para a pasta "Office 2021"
if exist "%pasta_instalacao%\Office 2021.rar" (
    echo %BRED%%BLACK%Extraindo Office 2021.rar...%RESET%
    md "%pasta_office%" >nul 2>&1
    "C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%pasta_instalacao%\Office 2021.rar" "%pasta_office%\" 
    if %ERRORLEVEL% NEQ 0 (
        echo %BRED%%BLACK%Falha ao extrair o arquivo Office 2021.rar.%RESET%
        pause
        
    ) else (
    echo %BGREEN%%BLACK%Office 2021 extraído com sucesso! %RESET%
	)
) else (
    echo %BRED%%BLACK%Arquivo Office 2021.rar não encontrado.%RESET%
)
ping -n 5 127.0.0.1 > nul
echo %BRED%%BLACK%Iniciando a instalação do Office... %RESET%
"%USERPROFILE%\Desktop\Nova Pasta\Office 2021\Office 2013-2021 C2R Install v7.3.6\OInstall.exe" /configure "%USERPROFILE%\Desktop\Nova Pasta\Office 2021\Office 2013-2021 C2R Install v7.3.6\files\Configure.xml" /wait
echo %BGREEN%%BLACK%Office instalado! %RESET%
rem fechar office com taskkill

ping -n 5 127.0.0.1 > nul
echo %BRED%%BLACK%Instalando chave do office e fazendo a ativação... %RESET%
powershell -Command "& ([ScriptBlock]::Create((irm https://get.activated.win))) /Ohook /S"
echo %BGREEN%%BLACK%Office ativado com sucesso! %RESET%
ping -n 10 127.0.0.1 > nul
for /f %%A in ('powershell -command "(Get-CimInstance -ClassName SoftwareLicensingProduct | Where-Object { $_.Name -like '*Windows*' -and $_.PartialProductKey } | Select-Object -First 1 -ExpandProperty LicenseStatus)"') do (
    set "status=%%A"
)

echo %BRED%%BLACK%Coletando informações do Windows... %RESET%
echo %BRED%%BLACK%Checando se possui licença instalada... %RESET%
if "%status%"=="1" (
	echo %BGREEN%%BLACK%Windows já está ativado! %RESET%
) else if "%status%"=="2" (
	echo %BBLUE%%BLACK%Chave do produto instalada, porém não foi ativado. %RESET%
	echo %BRED%%BLACK%Iniciando ativação... %RESET%
		ping -n 5 127.0.0.1 > nul
		powershell -Command "& ([ScriptBlock]::Create((irm https://get.activated.win))) /HWID-NoEditionChange /S"
	echo %BGREEN%%BLACK%Windows ativado com sucesso! %RESET%
) else if "%status%"=="3" (
		echo %BRED%%BLACK%Iniciando a ativação do Windows... %RESET%
		ping -n 5 127.0.0.1 > nul
		powershell -Command "& ([ScriptBlock]::Create((irm https://get.activated.win))) /HWID-NoEditionChange /S"
		echo %BGREEN%%BLACK%Windows ativado com sucesso! %RESET%
) else if "%status%"=="4" (
		echo %BRED%%BLACK%Iniciando a ativação do Windows... %RESET%
		ping -n 5 127.0.0.1 > nul
		powershell -Command "& ([ScriptBlock]::Create((irm https://get.activated.win))) /HWID-NoEditionChange /S"
		echo %BGREEN%%BLACK%Windows ativado com sucesso! %RESET%
) else if "%status%"=="5" (
		echo %BRED%%BLACK%Iniciando a ativação do Windows... %RESET%
		ping -n 5 127.0.0.1 > nul
		powershell -Command "& ([ScriptBlock]::Create((irm https://get.activated.win))) /HWID-NoEditionChange /S"
		echo %BGREEN%%BLACK%Windows ativado com sucesso! %RESET%
) else (
		echo %BRED%%BLACK%Iniciando a ativação do Windows... %RESET%
		ping -n 5 127.0.0.1 > nul
		powershell -Command "& ([ScriptBlock]::Create((irm https://get.activated.win))) /HWID-NoEditionChange /S"
		echo %BGREEN%%BLACK%Windows ativado com sucesso! %RESET%
)

ping -n 30 127.0.0.1 > nul

rem Ativar Anti virus
rem Extraindo Defender Blocker para desativar o Defender
if exist "%pasta_instalacao%\WinDef.rar" (
    echo %BRED%%BLACK%Extraindo WinDef.rar...%RESET%
    "C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%pasta_instalacao%\WinDef.rar" "%pasta_windef%\"
    if %ERRORLEVEL% NEQ 0 (
        echo %BBLUE%%BLACK%Falha ao extrair o arquivo WinDef.rar.%RESET%
        pause
    ) else (
        echo %BGREEN%%BLACK%Defender Control extraído com sucesso! %RESET%
        echo %BRED%%BLACK%Abrindo Defender Control...%RESET%
        :: powershell -Command "Start-Process '%pasta_windef%\WinDef\dControl.exe' -Verb runAs"
		start "" "%pasta_windef%\WinDef\dControl.exe"
        echo %BGREEN%%BLACK%Defender Control aberto com sucesso! %RESET%
		pause
    )
) else (
    echo %BBLUE%%BLACK%Arquivo WinDef.rar não encontrado.%RESET%
)
ping -n 2 127.0.0.1 > nul

powershell -Command "Install-Module -Name PSWindowsUpdate -Force -Confirm:$false; Import-Module PSWindowsUpdate; Get-WindowsUpdate | Install-WindowsUpdate -AcceptAll -Confirm:$false"
cmd.exe /c DISM /Online /Remove-OSUninstall

pause
goto MENU_INSTALACAO_WINDOWS

:MENU_INSTALACAO_WINDOWS_OFFICE2
setlocal EnableDelayedExpansion

powershell -Command "Add-Type -AssemblyName System.Windows.Forms; $result = [System.Windows.Forms.MessageBox]::Show('Possui Winrar?', 'Confirmação', [System.Windows.Forms.MessageBoxButtons]::YesNo); if ($result -eq [System.Windows.Forms.DialogResult]::Yes) { exit 1 } else { exit 0 }"
if %ERRORLEVEL%==1 (
	start "" "https://www.win-rar.com/download.html?&L=9"
) else (
    echo %BBLUE%%BLACK%Prosseguindo... %RESET%
)

rem Baixar Aplicativos usando Curl
curl --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo %BRED%%BLACK%O curl não está instalado ou não está no PATH.%RESET%
    echo %BRED%%BLACK%Instalando cURL... %RESET%
    winget install --id=cURL.cURL -e --accept-source-agreements --accept-package-agreements
    if %ERRORLEVEL% NEQ 0 (
        echo %BBLUE%%BLACK%Falha ao instalar o cURL.%RESET%
        pause
        goto :MENU
    )
    echo %BGREEN%%BLACK%cURL instalado com sucesso! %RESET%
) else (
    echo %BGREEN%%BLACK%cURL já está instalado! %RESET%
)

rem Definir variáveis de pasta e arquivos
set "pasta_instalacao=%USERPROFILE%\Desktop\Nova Pasta"
set "pasta_office=%pasta_instalacao%\Office 2021"
set "pasta_aact=%pasta_instalacao%\AAct_Network_x64"
set "arquivo_rar=%pasta_instalacao%\Arquivos.rar"
set "arquivo_windef=%pasta_instalacao%\WinDef.rar"
set "pasta_windef=%pasta_instalacao%\WinDef\"
set "link_dropbox=https://www.dropbox.com/s/geisbvplfws907e/Arquivos.rar?st=7d958qjl&dl=1" 

rem Verifica se a pasta de instalação já existe, caso contrário cria
if not exist "%pasta_instalacao%" (
    echo %BRED%%BLACK%Criando pasta da instalação dos programas...%RESET%
    md "%pasta_instalacao%" >nul 2>&1
        echo %BGREEN%%BLACK%Pasta criada com sucesso! %RESET%
)

ping -n 2 127.0.0.1 > nul

rem Baixando o arquivo Arquivos.rar
echo %BRED%%BLACK%Baixando o arquivo Arquivos.rar... %RESET%
curl -L -o "%arquivo_rar%" "%link_dropbox%"
if %ERRORLEVEL% NEQ 0 (
    echo %BBLUE%%BLACK%Falha ao baixar o arquivo Arquivos.rar.%RESET%
    pause
    goto :MENU
) else (
echo %BGREEN%%BLACK%Arquivo Arquivos.rar baixado com sucesso! %RESET%
)

ping -n 5 127.0.0.1 > nul
winget install --id=RARLab.WinRAR -e --accept-source-agreements --accept-package-agreements
ping -n 5 127.0.0.1 > nul

echo %BRED%%BLACK%Abrindo painel do Windows Defender, por favor, desativa-lo...%RESET%
start windowsdefender://threat
pause

rem Extraindo Arquivos.rar para a pasta de instalação
echo %BRED%%BLACK%Extraindo Arquivos.rar...%RESET%
"C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%arquivo_rar%" "%pasta_instalacao%\" 
if %ERRORLEVEL% NEQ 0 (
    echo %BBLUE%%BLACK%Falha ao extrair o arquivo Arquivos.rar.%RESET%
    pause
) else (
echo %BGREEN%%BLACK%Arquivos RAR extraídos com sucesso! %RESET%
)

rem Extraindo Defender Blocker para desativar o Defender
if exist "%pasta_instalacao%\WinDef.rar" (
    echo %BRED%%BLACK%Extraindo WinDef.rar...%RESET%
    "C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%pasta_instalacao%\WinDef.rar" "%pasta_windef%\"
    if %ERRORLEVEL% NEQ 0 (
        echo %BBLUE%%BLACK%Falha ao extrair o arquivo WinDef.rar.%RESET%
        pause
    ) else (
        echo %BGREEN%%BLACK%Defender Control extraído com sucesso! %RESET%
        echo %BRED%%BLACK%Abrindo Defender Control...%RESET%
        :: powershell -Command "Start-Process '%pasta_windef%\WinDef\dControl.exe' -Verb runAs"
		start "" "%pasta_windef%\WinDef\dControl.exe"
        echo %BGREEN%%BLACK%Defender Control aberto com sucesso! %RESET%
		pause
    )
) else (
    echo %BBLUE%%BLACK%Arquivo WinDef.rar não encontrado.%RESET%
)

rem Extraindo Arquivos.rar para a pasta de instalação
echo %BRED%%BLACK%Extraindo Arquivos.rar...%RESET%
"C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%arquivo_rar%" "%pasta_instalacao%\" 
if %ERRORLEVEL% NEQ 0 (
    echo %BBLUE%%BLACK%Falha ao extrair o arquivo Arquivos.rar.%RESET%
    pause    
) else (
echo %BGREEN%%BLACK%Arquivos RAR extraídos com sucesso! %RESET%
)
rem Extraindo o Office 2021.rar para a pasta "Office 2021"
if exist "%pasta_instalacao%\Office 2021.rar" (
    echo %BRED%%BLACK%Extraindo Office 2021.rar...%RESET%
    md "%pasta_office%" >nul 2>&1
    "C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%pasta_instalacao%\Office 2021.rar" "%pasta_office%\" 
    if %ERRORLEVEL% NEQ 0 (
        echo %BRED%%BLACK%Falha ao extrair o arquivo Office 2021.rar.%RESET%
        pause
        
    ) else (
    echo %BGREEN%%BLACK%Office 2021 extraído com sucesso! %RESET%
	)
) else (
    echo %BRED%%BLACK%Arquivo Office 2021.rar não encontrado.%RESET%
)
ping -n 5 127.0.0.1 > nul
echo %BRED%%BLACK%Iniciando a instalação do Office... %RESET%
"%USERPROFILE%\Desktop\Nova Pasta\Office 2021\Office 2013-2021 C2R Install v7.3.6\OInstall.exe" /configure "%USERPROFILE%\Desktop\Nova Pasta\Office 2021\Office 2013-2021 C2R Install v7.3.6\files\Configure.xml" /wait
echo %BGREEN%%BLACK%Office instalado! %RESET%
rem fechar office com taskkill

ping -n 5 127.0.0.1 > nul
echo %BRED%%BLACK%Instalando chave do office e fazendo a ativação... %RESET%
powershell -Command "& ([ScriptBlock]::Create((irm https://get.activated.win))) /Ohook /S"
echo %BGREEN%%BLACK%Office ativado com sucesso! %RESET%


ping -n 30 127.0.0.1 > nul

rem Ativar Anti virus
rem Extraindo Defender Blocker para desativar o Defender
if exist "%pasta_instalacao%\WinDef.rar" (
    echo %BRED%%BLACK%Extraindo WinDef.rar...%RESET%
    "C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%pasta_instalacao%\WinDef.rar" "%pasta_windef%\"
    if %ERRORLEVEL% NEQ 0 (
        echo %BBLUE%%BLACK%Falha ao extrair o arquivo WinDef.rar.%RESET%
        pause
    ) else (
        echo %BGREEN%%BLACK%Defender Control extraído com sucesso! %RESET%
        echo %BRED%%BLACK%Abrindo Defender Control...%RESET%
        :: powershell -Command "Start-Process '%pasta_windef%\WinDef\dControl.exe' -Verb runAs"
		start "" "%pasta_windef%\WinDef\dControl.exe"
        echo %BGREEN%%BLACK%Defender Control aberto com sucesso! %RESET%
		pause
    )
) else (
    echo %BBLUE%%BLACK%Arquivo WinDef.rar não encontrado.%RESET%
)
ping -n 2 127.0.0.1 > nul

pause
goto MENU_INSTALACAO_WINDOWS



:MENU_INSTALACAO_WINDOWS_OFFICE3
setlocal EnableDelayedExpansion

echo %BRED%%BLACK%Instalando chave do office e fazendo a ativação... %RESET%
powershell -Command "& ([ScriptBlock]::Create((irm https://get.activated.win))) /Ohook /S"
echo %BGREEN%%BLACK%Office ativado com sucesso! %RESET%
ping -n 10 127.0.0.1 > nul
for /f %%A in ('powershell -command "(Get-CimInstance -ClassName SoftwareLicensingProduct | Where-Object { $_.Name -like '*Windows*' -and $_.PartialProductKey } | Select-Object -First 1 -ExpandProperty LicenseStatus)"') do (
    set "status=%%A"
)
pause
goto MENU_INSTALACAO_WINDOWS


:MENU_INSTALACAO_WINDOWS_WINDOWS
setlocal EnableDelayedExpansion
echo %BRED%%BLACK%Coletando informações do Windows... %RESET%
echo %BRED%%BLACK%Checando se possui licença instalada... %RESET%
if "%status%"=="1" (
	echo %BGREEN%%BLACK%Windows já está ativado! %RESET%
) else if "%status%"=="2" (
	echo %BBLUE%%BLACK%Chave do produto instalada, porém não foi ativado. %RESET%
	echo %BRED%%BLACK%Iniciando ativação... %RESET%
		ping -n 5 127.0.0.1 > nul
		powershell -Command "& ([ScriptBlock]::Create((irm https://get.activated.win))) /HWID-NoEditionChange /S"
	echo %BGREEN%%BLACK%Windows ativado com sucesso! %RESET%
) else if "%status%"=="3" (
		echo %BRED%%BLACK%Iniciando a ativação do Windows... %RESET%
		ping -n 5 127.0.0.1 > nul
		powershell -Command "& ([ScriptBlock]::Create((irm https://get.activated.win))) /HWID-NoEditionChange /S"
		echo %BGREEN%%BLACK%Windows ativado com sucesso! %RESET%
) else if "%status%"=="4" (
		echo %BRED%%BLACK%Iniciando a ativação do Windows... %RESET%
		ping -n 5 127.0.0.1 > nul
		powershell -Command "& ([ScriptBlock]::Create((irm https://get.activated.win))) /HWID-NoEditionChange /S"
		echo %BGREEN%%BLACK%Windows ativado com sucesso! %RESET%
) else if "%status%"=="5" (
		echo %BRED%%BLACK%Iniciando a ativação do Windows... %RESET%
		ping -n 5 127.0.0.1 > nul
		powershell -Command "& ([ScriptBlock]::Create((irm https://get.activated.win))) /HWID-NoEditionChange /S"
		echo %BGREEN%%BLACK%Windows ativado com sucesso! %RESET%
) else (
		echo %BRED%%BLACK%Iniciando a ativação do Windows... %RESET%
		ping -n 5 127.0.0.1 > nul
		powershell -Command "& ([ScriptBlock]::Create((irm https://get.activated.win))) /HWID-NoEditionChange /S"
		echo %BGREEN%%BLACK%Windows ativado com sucesso! %RESET%
)

ping -n 30 127.0.0.1 > nul

pause
goto MENU_INSTALACAO_WINDOWS

:MENU_INSTALACAO_WINDOWS_SERVER
echo %BRED%%BLACK%Abrindo painel para ativação do Windows Server %RESET%
powershell -ExecutionPolicy Bypass -NoProfile -Command "irm https://get.activated.win | iex"
echo %BGREEN%%BLACK%Painel aberto com sucesso! %RESET%
pause
goto MENU_INSTALACAO_WINDOWS

rem 2 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rem 2 - Instalar gpedit.msc
:GPEDIT
cls
echo %BRED%Iniciando Instalação...%RESET%
pushd "%~dp0"
dir /b C:\Windows\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientExtensions-Package~3*.mum >List.txt
dir /b C:\Windows\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientTools-Package~3*.mum >>List.txt
for /f %%i in ('findstr /i . List.txt 2^>nul') do dism /online /norestart /add-package:"C:\Windows\servicing\Packages\%%i"
echo %BGREEN%%BLACK%Instalação concluída%RESET%
echo %BRED%%BLACK%Apagando arquivos gerados durante a instalação...%RESET%
del "%USERPROFILE%\Desktop\List.txt"
echo %BBLUE%%BLACK%Instalação concluída%RESET%
pause
goto MENU

rem 3 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rem 3 - Configurações e Otimizações

:MENU_CONFIG
cls
call :banner
echo                ╔════════════════════════════════════════════════════════════════════════════╗
echo                ║                                  Config                                    ║
echo                ║════════════════════════════════════════════════════════════════════════════║
echo                ║     1 - Padrão (Windows 10 / Windows 11)                                   ║
echo                ║     %BRED%%BLACK%2 - Otimização individual (Para PC fraco)%RESET%                              ║
echo                ║     3 - Otimização Navegadores                                             ║
echo                ║     4 - Voltar ao menu anterior                                            ║
echo                ╚════════════════════════════════════════════════════════════════════════════╝
echo.
echo.
choice /c 1234 /n /m "Escolha uma opção: "
set install_choice=%errorlevel%

if "%install_choice%"=="1" goto MENU_CONFIG_PADRAO
if "%install_choice%"=="" goto MENU_CONFIG_INDIVIDUAL
if "%install_choice%"=="3" goto MENU_CONFIG_NAVEGADORES
if "%install_choice%"=="4" goto MENU
goto MENU_CONFIG


:MENU_CONFIG_NAVEGADORES
:: Desativa execução em segundo plano
reg add "HKCU\Software\Google\Chrome\BackgroundModeEnabled" /v Enabled /t REG_DWORD /d 0 /f >nul
:: Desativa notificações
reg add "HKCU\Software\Policies\Google\Chrome" /v DefaultNotificationsSetting /t REG_DWORD /d 2 /f >nul
:: Desativa o relatório de uso e erros
reg add "HKCU\Software\Policies\Google\Chrome" /v MetricsReportingEnabled /t REG_DWORD /d 0 /f >nul
:: Desativa a pré-busca de URLs (reduz uso de RAM)
reg add "HKCU\Software\Policies\Google\Chrome" /v NetworkPredictionOptions /t REG_DWORD /d 2 /f >nul
:: Desativa sugestões de busca e URLs
reg add "HKCU\Software\Policies\Google\Chrome" /v SearchSuggestEnabled /t REG_DWORD /d 0 /f >nul
:: Desativa sincronização automática
reg add "HKCU\Software\Policies\Google\Chrome" /v SyncDisabled /t REG_DWORD /d 1 /f >nul
:: Desativa nova aba com sugestões
reg add "HKCU\Software\Policies\Google\Chrome" /v NewTabPageLocation /t REG_SZ /d "about:blank" /f >nul
:: Desativa animações (melhora desempenho)
reg add "HKCU\Software\Policies\Google\Chrome" /v AnimationsPolicy /t REG_SZ /d "none" /f >nul
:: Limpa cache e dados temporários (precisa do Chrome fechado)
del /q /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache\*" >nul 2>&1
del /q /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Code Cache\*" >nul 2>&1
del /q /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\GPUCache\*" >nul 2>&1

:: Desativa execução em segundo plano
reg add "HKCU\Software\Policies\Microsoft\Edge" /v BackgroundModeEnabled /t REG_DWORD /d 0 /f >nul
:: Desativa notificações
reg add "HKCU\Software\Policies\Microsoft\Edge" /v DefaultNotificationsSetting /t REG_DWORD /d 2 /f >nul
:: Desativa pré-carregamento de páginas e especulação de DNS
reg add "HKCU\Software\Policies\Microsoft\Edge" /v NetworkPredictionOptions /t REG_DWORD /d 2 /f >nul
:: Desativa sugestões de URL e busca
reg add "HKCU\Software\Policies\Microsoft\Edge" /v SearchSuggestEnabled /t REG_DWORD /d 0 /f >nul
:: Desativa relatório de uso e erros
reg add "HKCU\Software\Policies\Microsoft\Edge" /v MetricsReportingEnabled /t REG_DWORD /d 0 /f >nul
:: Desativa sincronização automática
reg add "HKCU\Software\Policies\Microsoft\Edge" /v SyncDisabled /t REG_DWORD /d 1 /f >nul
:: Desativar envio de dados para a Microsoft
reg add "HKCU\Software\Policies\Microsoft\Edge" /v MetricsReportingEnabled /t REG_DWORD /d 0 /f >nul
:: Desativar rastreamento
reg add "HKCU\Software\Policies\Microsoft\Edge" /v PersonalizationReportingEnabled /t REG_DWORD /d 0 /f >nul
:: Desativar sugestões de conteúdo e página inicial com feed de notícias
reg add "HKCU\Software\Policies\Microsoft\Edge" /v HubsSidebarEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Policies\Microsoft\Edge" /v NewTabPageContentEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Policies\Microsoft\Edge" /v EdgeDiscoverEnabled /t REG_DWORD /d 0 /f >nul
:: Desativar widgets como o Bing, ferramentas e notícias na barra lateral
reg add "HKCU\Software\Policies\Microsoft\Edge" /v ShowRecommendationsEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Policies\Microsoft\Edge" /v WebWidgetAllowed /t REG_DWORD /d 0 /f >nul
:: Desativar animações
reg add "HKCU\Software\Policies\Microsoft\Edge" /v AnimationPolicy /t REG_SZ /d "none" /f >nul
:: Página inicial em branco
reg add "HKCU\Software\Policies\Microsoft\Edge" /v RestoreOnStartup /t REG_DWORD /d 4 /f >nul
reg add "HKCU\Software\Policies\Microsoft\Edge" /v RestoreOnStartupURLs /t REG_MULTI_SZ /d "about:blank" /f >nul
:: Desativar feed de notícias e Clima
reg add "HKCU\Software\Policies\Microsoft\Edge" /v NTPContentSuggestionsEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Policies\Microsoft\Edge" /v NTPWeatherEnabled /t REG_DWORD /d 0 /f >nul
del /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache\*" >nul 2>&1
del /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache\*" >nul 2>&1
del /q /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\GPUCache\*" >nul 2>&1
ping -n 2 127.0.0.1 > nul
:: Localiza o perfil padrão do usuário
set "perfil="
for /f "delims=" %%i in ('dir /b /ad "%APPDATA%\Mozilla\Firefox\Profiles" ^| findstr "\.default") do (
    set "perfil=%%i"
)
if "%perfil%"=="" (
    echo %BBLUE%Perfil do Firefox não encontrado.%RESET%
    pause
    goto :MENU
)
set "caminho=%APPDATA%\Mozilla\Firefox\Profiles\%perfil%"
set "arquivo=%caminho%\user.js"
:: Cria ou substitui o arquivo user.js com otimizações
echo %BRED%Criando arquivo user.js com otimizações...%RESET%
> "%arquivo%" (
    echo // === Otimizacoes de desempenho ===
    echo user_pref("browser.sessionstore.resume_from_crash", false);
    echo user_pref("browser.tabs.animate", false);
    echo user_pref("browser.uidensity", 1);
    echo user_pref("browser.startup.page", 0);
    echo user_pref("browser.newtabpage.enabled", false);
    echo user_pref("browser.preload", false);

    echo // === Privacidade e desativação de telemetria ===
    echo user_pref("toolkit.telemetry.enabled", false);
    echo user_pref("toolkit.telemetry.unified", false);
    echo user_pref("datareporting.healthreport.uploadEnabled", false);
    echo user_pref("datareporting.policy.dataSubmissionEnabled", false);
    echo user_pref("browser.ping-centre.telemetry", false);
    echo user_pref("app.shield.optoutstudies.enabled", false);
    echo user_pref("browser.discovery.enabled", false);

    echo // === Sugestoes e pre-buscas ===
    echo user_pref("browser.urlbar.suggest.searches", false);
    echo user_pref("browser.urlbar.speculativeConnect.enabled", false);
    echo user_pref("network.dns.disablePrefetch", true);
    echo user_pref("network.prefetch-next", false);
    echo user_pref("network.http.speculative-parallel-limit", 0);
)
:: Limpa o cache
del /q /s "%LOCALAPPDATA%\Mozilla\Firefox\Profiles\%perfil%\cache2\*" >nul 2>&1

echo %BGREEN%%BLACK%Navegadores otimizados com sucesso! %RESET%
pause
goto :MENU_CONFIG


:MENU_CONFIG_PADRAO

cls
call :banner
echo %BRED%%BLACK%Identificando versão do Windows...%RESET%

:: Obtem a versão do sistema
for /f "tokens=2 delims=[]" %%i in ('ver') do set "versao=%%i"
for /f "tokens=2 delims=." %%a in ("%versao%") do set "build=%%a"

:: A partir do Windows 11, o build é 22000 ou superior
if %build% GEQ 22000 (
    goto MENU_CONFIG_PADRAO_WIN11
) else (
    goto MENU_CONFIG_PADRAO_WIN10
)

:MENU_CONFIG_PADRAO_WIN10

set "WMP_PATH=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\Windows Media Player.lnk"
set "WMP_LEGACY_PATH=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\Windows Media Player Legacy.lnk"
set "pasta_instalacao=%USERPROFILE%\Desktop\Nova Pasta"
set "arquivo_rar=%pasta_instalacao%\Arquivos.rar"
set "local_wallpaper=C:\Wallpaper.jpg"
set "link_dropbox=https://www.dropbox.com/s/geisbvplfws907e/Arquivos.rar?st=7d958qjl&dl=1"
set "WORD_PATH=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Word.lnk"
set "EXCEL_PATH=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Excel.lnk"

set "CHROME_PATH=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk"
set "EDGE_PATH=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk"
set "FIREFOX_PATH=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Firefox.lnk"
set "SKYPE_PATH=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Skype\Skype.lnk"
set "ADOBE_PATH=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Adobe Acrobat.lnk"
set "ANYDESK_PATH=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\AnyDesk\AnyDesk.lnk"
set "ANYVIEWER_PATH=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\AnyViewer\AnyViewer.lnk"
set "DESKTOP_PATH=%USERPROFILE%\Desktop"
set "STEAM_PATH=C:\"
set "DISCORD_PATH=C:\"

set "pasta_windef=%pasta_instalacao%\WinDef.rar"

cls
call :bannerWIN10
ping -n 2 127.0.0.1 > nul
rem Energia
echo %BRED%%BLACK%Definindo plano de energia...%RESET%
powercfg /S SCHEME_MIN
powercfg -change -monitor-timeout-ac 0
powercfg -change -monitor-timeout-dc 0
powercfg -change -disk-timeout-ac 0
powercfg -change -disk-timeout-dc 0
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 0
powercfg -change -hibernate-timeout-ac 0
powercfg -change -hibernate-timeout-dc 0
echo %BGREEN%%BLACK%Plano de energia definido! %RESET%
ping -n 2 127.0.0.1 > nul

echo %BRED%%BLACK%Abrindo Windows Update... %RESET%
start ms-settings:windowsupdate
echo %BGREEN%%BLACK%Windows Update aberto com sucesso! %RESET%
pause

rem Verificar se o arquivo .theme existe
if exist "%SystemRoot%\Resources\Themes\aero.theme" (
    start "" "%SystemRoot%\Resources\Themes\aero.theme"
	ping -n 5 127.0.0.1 > nul
        taskkill /f /im SystemSettings.exe
        ping -n 2 127.0.0.1 > nul

    taskkill /f /im explorer.exe
    ping -n 5 127.0.0.1 > nul
    start explorer.exe
    echo %BGREEN%%BLACK%Tema Aero aplicado com sucesso!%RESET%
) else (
    echo %BBLUE%%BLACK%O arquivo aero.theme não foi encontrado.%RESET%
)

cmd.exe /c DISM /Online /Remove-OSUninstall
reg delete \"HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\WindowsUpdate\\Orchestrator\\UScheduler_Oobe\\OutlookUpdate\" /f 


setlocal enabledelayedexpansion
rem Caminho da Área de Trabalho e Downloads
set "DESKTOP=%USERPROFILE%\Desktop"
set "downloads=%USERPROFILE%\Downloads"

echo %BRED%%BLACK%Apagando ícones na Área de Trabalho... %RESET%
rem Definir as pastas de área de trabalho do usuário e pública
set "user_desktop=%USERPROFILE%\Desktop"
set "public_desktop=C:\Users\Public\Desktop"
rem Excluir ícones na área de trabalho do usuário
for %%F in ("%user_desktop%\*") do (
    if /I "%%~nxF" neq "%~nx0" (
        del /f /q "%%F" >nul 2>&1
        rmdir /s /q "%%F" >nul 2>&1
    )
)
rem Excluir ícones na área de trabalho pública
for %%F in ("%public_desktop%\*") do (
    if /I "%%~nxF" neq "%~nx0" (
        rem Verifica se o arquivo já foi excluído na área de trabalho do usuário
        if not exist "%user_desktop%\%%~nxF" (
            del /f /q "%%F" >nul 2>&1
            rmdir /s /q "%%F" >nul 2>&1
        )
    )
)
echo %BGREEN%%BLACK%Ícones apagados com sucesso! %RESET%
echo %BRED%%BLACK%Movendo ícones... %RESET%
for %%F in ("%user_desktop%\*") do (
    if /I "%%~nxF" neq "%~nx0" (
        move /Y "%%F" "%downloads%" >nul 2>&1
    )
)

:: Mover arquivos e pastas do Desktop público, se ainda não foram movidos
for %%F in ("%public_desktop%\*") do (
    if /I "%%~nxF" neq "%~nx0" (
        rem Verifica se o arquivo ou pasta já foi movido
        if not exist "%user_desktop%\%%~nxF" (
            move /Y "%%F" "%downloads%" >nul 2>&1
        )
    )
)
ping -n 3 127.0.0.1 > nul
move /y "%USERPROFILE%\Desktop\Nova Pasta" "%USERPROFILE%\Downloads"
ping -n 2 127.0.0.1 > nul
ping -n 3 127.0.0.1 > nul
echo %BGREEN%%BLACK%Ícones movidos com sucesso! %RESET%
rem Atualiza área de trabalho
taskkill /f /im explorer.exe >nul 2>&1
ping -n 2 127.0.0.1 >nul
start explorer.exe
rem Removendo Tudo
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d 1 /f
taskkill /f /im explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 3 127.0.0.1 > nul
start explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 5 127.0.0.1 > nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 1 /f
taskkill /f /im explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 3 127.0.0.1 > nul
start explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 5 127.0.0.1 > nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 1 /f
taskkill /f /im explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 3 127.0.0.1 > nul
start explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 5 127.0.0.1 > nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /t REG_DWORD /d 1 /f
taskkill /f /im explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 3 127.0.0.1 > nul
start explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 5 127.0.0.1 > nul
rem Adicionando seus respectivos ícones principais (Usuario, Meu Computador, Rede, Lixeira)
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0 /f
taskkill /f /im explorer.exe
ping -n 5 127.0.0.1 > nul
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
start explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 5 127.0.0.1 > nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f
taskkill /f /im explorer.exe
ping -n 5 127.0.0.1 > nul
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
start explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 5 127.0.0.1 > nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /t REG_DWORD /d 0 /f
taskkill /f /im explorer.exe
ping -n 5 127.0.0.1 > nul
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
start explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 5 127.0.0.1 > nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d 0 /f
taskkill /f /im explorer.exe
ping -n 5 127.0.0.1 > nul
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
start explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 5 127.0.0.1 > nul
rem Criando atalhos principais
echo %BRED%%BLACK% Criando atalhos... %RESET%
rem Função para copiar atalho apenas se o arquivo existir
call :copiarAtalho "%EDGE_PATH%" "Microsoft Edge.lnk"
ping -n 2 127.0.0.1 >nul
call :copiarAtalho "%FIREFOX_PATH%" "Firefox.lnk"
ping -n 2 127.0.0.1 >nul
call :copiarAtalho "%CHROME_PATH%" "Google Chrome.lnk"
ping -n 2 127.0.0.1 >nul
rem call :copiarAtalho "%SKYPE_PATH%" "Skype.lnk"
rem mklink "%USERPROFILE%\Desktop\Microsoft Teams.lnk" "C:\Program Files\WindowsApps\LOCAL DO TEAMS COLOCAR\Microsoft Teams.exe"
mklink "%USERPROFILE%\Desktop\Microsoft Teams.lnk" "shell:appsfolder\MSTeams_8wekyb3d8bbwe!MSTeams"
ping -n 2 127.0.0.1 >nul
call :copiarAtalho "%WORD_PATH%" "Word.lnk"
ping -n 2 127.0.0.1 >nul
call :copiarAtalho "%EXCEL_PATH%" "Excel.lnk"
ping -n 2 127.0.0.1 >nul
call :copiarAtalho "%ANYDESK_PATH%" "AnyDesk.lnk"
ping -n 2 127.0.0.1 >nul
call :copiarAtalho "%ANYVIEWER_PATH%" "AnyViewer.lnk"
ping -n 2 127.0.0.1 >nul 
call :copiarAtalho "%ADOBE_PATH%" "Adobe Acrobat.lnk"
ping -n 2 127.0.0.1 >nul
rem mklink "%USERPROFILE%\Desktop\WhatsApp.lnk" "C:\Program Files\WindowsApps\WhatsAppInc.WhatsApp_2.2127.11.0_x64__8jjg2d5vkyx5c\WhatsApp.exe"
mklink "%USERPROFILE%\Desktop\WhatsApp.lnk" "shell:appsfolder\5319275A.WhatsAppDesktop_cv1g1gvanyjgm!App"




echo %BGREEN%%BLACK% Ícones organizados! %RESET%
echo %BRED%%BLACK%Movendo ícones e pastas de volta para a Área de Trabalho... %RESET%
:: Mover todos os arquivos e pastas de volta para a Área de Trabalho
for %%F in ("%downloads%\*") do (
    if /I "%%~nxF" neq "%~nx0" (
        move /Y "%%F" "%user_desktop%" >nul 2>&1
    )
)

echo %BGREEN%%BLACK%Ícones movidos de volta para a Área de Trabalho com sucesso! %RESET%

move /y "%USERPROFILE%\Downloads\Nova Pasta" "%USERPROFILE%\Desktop" 
ping -n 2 127.0.0.1 >nul

ping -n 2 127.0.0.1 > nul
rem UAC
echo %BRED%%BLACK%Definindo UAC...%RESET%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f
echo %BGREEN%%BLACK%UAC definido! %RESET%
ping -n 2 127.0.0.1 > nul
rem Windows Media Player
set WMP_PATH="C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\Windows Media Player.lnk"
set WMP_LEGACY_PATH="C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\Windows Media Player Legacy.lnk"
echo %BRED%%BLACK%Definindo as configurações para o Windows Media Player...%RESET%
reg add "HKCU\Software\Microsoft\MediaPlayer\Preferences" /v AcceptedPrivacyStatement /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\MediaPlayer\Preferences" /v FirstRun /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\MediaPlayer\Preferences" /v ShowFirstRun /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\MediaPlayer\Preferences" /v QuickLaunchSettings /t REG_DWORD /d 1 /f

rem Wallpaper
ping -n 3 127.0.0.1 > nul
set "pasta_instalacao=%USERPROFILE%\Desktop\Nova Pasta"
rem Verifica se a pasta de instalação já existe, caso contrário cria
if not exist "%pasta_instalacao%" (
    echo %BRED%%BLACK%Criando pasta da instalação dos programas...%RESET%
    md "%pasta_instalacao%" >nul 2>&1
        echo %BGREEN%%BLACK%Pasta criada com sucesso! %RESET%
		
			echo %BRED%%BLACK%Baixando o arquivo Arquivos.rar... %RESET%
		curl -L -o "%arquivo_rar%" "%link_dropbox%"
		echo %BGREEN%%BLACK%Arquivo Arquivos.rar baixado com sucesso! %RESET%
		if exist "C:\Program Files\WinRAR\WinRAR.exe" (
			echo %BGREEN%%BLACK%WinRAR já está instalado, prosseguindo...%RESET%
		) else (
			echo %BRED%%BLACK%WinRAR não foi encontrado. Iniciando sua instalação...%RESET%
			winget settings --enable InstallerHashOverride
			winget install --id "RARLab.WinRAR" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
			echo %BGREEN%%BLACK%WinRAR instalado com sucesso!%RESET%
		)

		echo %BRED%%BLACK%Extraindo Arquivos.rar...%RESET%
		"C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%arquivo_rar%" "%pasta_instalacao%\" 
		if %ERRORLEVEL% NEQ 0 (
			echo %BRED%%BLACK%Falha ao extrair o arquivo Arquivos.rar.%RESET%
			pause
				goto :MENU
		) 
		echo %BGREEN%%BLACK%Arquivos RAR extraídos com sucesso! %RESET%
		
) else (
		echo %BRED%%BLACK%Extraindo Arquivos.rar...%RESET%
		"C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%arquivo_rar%" "%pasta_instalacao%\" 
		echo %BGREEN%%BLACK%Arquivos RAR extraídos com sucesso! %RESET%
)

rem Comandos Powershell para config
rem powershell.exe -Command "Start-Process powershell.exe -ArgumentList '-Command', 'irm https://raw.githubusercontent.com/GamerGb/nogatectools/refs/heads/main/ConfigWin10.ps1 | iex'" -Verb RunAs -WindowStyle Hidden -Wait
powershell.exe -Command "irm https://raw.githubusercontent.com/GamerGb/nogatectools/refs/heads/main/ConfigWin10.ps1 | iex"




echo %BRED%%BLACK%Desativando telemetria...%RESET%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f

echo %BRED%%BLACK%Desabilitando sugestões de aplicativos...%RESET%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v ContentDeliveryAllowed /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v OemPreInstalledAppsEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v PreInstalledAppsEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v PreInstalledAppsEverEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SilentInstalledAppsEnabled /t REG_DWORD /d 0 /f

echo echo %BRED%%BLACK%Desativando Histórico de Atividades...%RESET%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v PublishUserActivities /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v UploadUserActivities /t REG_DWORD /d 0 /f
rem Desativando Rastreamento de Localização...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v Value /t REG_SZ /d Deny /f
rem echo Desativando Atualizações Automáticas de Mapas...
reg add "HKLM\SYSTEM\Maps" /v AutoUpdateEnabled /t REG_DWORD /d 0 /f
rem echo Desativando Relatório de Erros...
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f
rem echo Ocultando Widgets da Barra de Tarefas...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f
rem echo Desativando Pré-Carregamento do Edge...
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge" /v AllowPrelaunch /t REG_DWORD /d 0 /f
rem echo Disabling some services...
for %%s in (
    "diagnosticshub.standardcollector.service"
    "dmwappushservice"
    "edgeupdate"
    "edgeupdatem"
    "EntAppSvc"
    "Fax"
    "fhsvc"
    "gupdate"
    "gupdatem"
    "lfsvc"
    "MapsBroker"
    "MicrosoftEdgeElevationService"
    "MSDTC"
    "RetailDemo"
    "SCardSvr"
    "SEMgrSvc"
    "WMPNetworkSvc"
    "WpcMonSvc"
    "WPDBusEnum"
    "WpnService"
    "HPAppHelperCap"
    "HPDiagsCap"
    "HPNetworkCap"
    "HPSysInfoCap"
    "HpTouchpointAnalyticsService"
    "dcpm-notify"
    "DDVCollectorSvcApi"
    "DDVDataCollector"
    "DDVRulesProcessor"
    "Dell.CommandPowerManager.Service"
    "DellClientManagementService"
    "DellTechHub"
    "DPMService"
    "SupportAssistAgent"
    "AdobeARMservice"
    "FoxitReaderUpdateService"
    "StateRepository"
    "StorSvc"
) do (
    echo Checking service %%s...
    sc qc %%s >nul 2>&1
    if errorlevel 1 (
        echo Service %%s not found!
    ) else (
        for /f "tokens=3" %%t in ('sc qc %%s ^| find "START_TYPE"') do (
            if "%%t"==" 2" (
                echo Stopping %%s...
                net stop %%s >nul 2>&1
                echo Setting %%s to Manual...
                sc config %%s start= demand
            )
        )
    )
)

echo %BGREEN%%BLACK% Aplicações realizadas com sucesso! %RESET%
ping -n 10 127.0.0.1 > nul

reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "%local_wallpaper%" /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
taskkill /f /im explorer.exe
ping -n 2 127.0.0.1 > nul
start explorer.exe
ping -n 2 127.0.0.1 > nul
echo %BGREEN%%BLACK%Wallpaper definido com sucesso! %RESET%
ping -n 2 127.0.0.1 > nul
rem Notificações
echo %BRED%%BLACK%Definindo configurações das notificações...%RESET%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 0 /f
taskkill /f /im explorer.exe
ping -n 5 127.0.0.1 > nul
start explorer.exe
ping -n 2 127.0.0.1 > nul

echo %BRED%%BLACK%Realizando configurações de impressora...%RESET%
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Print" /v RpcAuthnLevelPrivacyEnabled /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Policies\Microsoft\FeatureManagement\Overrides" /v 3598754956 /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Policies\Microsoft\FeatureManagement\Overrides" /v 1921033356 /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Policies\Microsoft\FeatureManagement\Overrides" /v 713073804 /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC" /v RpcUseNamedPipeProtocol /t REG_DWORD /d 1 /f
taskkill /f /im explorer.exe
ping -n 5 127.0.0.1 > nul
start explorer.exe
ping -n 2 127.0.0.1 > nul
echo %BGREEN%%BLACK%Configurações de impressora foram modificadas com sucesso! %RESET%

echo %BRED%%BLACK%Desativando Windows Hello na entrada...%RESET%
reg ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\PasswordLess\Device" /v DevicePasswordLessBuildVersion /t REG_DWORD /d 0 /f
echo %BGREEN%%BLACK%Windows Hello desativado com sucesso! %RESET%


rem Definir tema padrão
	REM echo %BRED%%BLACK%Definindo tema do windows...%RESET%
	rem start "" "C:\Windows\Resources\Themes\aero.theme"
	rem explorer "C:\Windows\Resources\Themes\aero.theme"
	rem ping -n 4 127.0.0.1 > nul
	rem taskkill /im systemsettings.exe /f
	rem ping -n 3 127.0.0.1 > nul


rundll32.exe user32.dll,UpdatePerUserSystemParameters
rem echo %BGREEN%%BLACK%Tema definido com sucesso! %RESET%
rem padronizando tema


rem WALLPAPER NOVAMENTE PARA EVITAR PROBLEMAS
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "%local_wallpaper%" /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
taskkill /f /im explorer.exe
ping -n 2 127.0.0.1 > nul
start explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 3 127.0.0.1 > nul

rem Ajustar configurações para máximo desempenho no Windows
echo %BRED%%BLACK%Definindo configuracões de desempenho do Windows... %RESET%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f
ping -n 2 127.0.0.1 > nul
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
taskkill /f /im explorer.exe
ping -n 2 127.0.0.1 > nul
start explorer.exe
ping -n 2 127.0.0.1 > nul
rundll32.exe user32.dll,UpdatePerUserSystemParameters
ping -n 1 127.0.0.1 > nul
echo %BRED%%BLACK%Modificando as configurações... %RESET%
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 1 /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
taskkill /f /im explorer.exe
ping -n 2 127.0.0.1 > nul
start explorer.exe
reg add "HKCU\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d 2 /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
taskkill /f /im explorer.exe
ping -n 2 127.0.0.1 > nul
start explorer.exe
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 0 /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
taskkill /f /im explorer.exe
ping -n 2 127.0.0.1 > nul
start explorer.exe
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 1 /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
taskkill /f /im explorer.exe
ping -n 2 127.0.0.1 > nul
start explorer.exe


rem powershell.exe -Command "irm https://raw.githubusercontent.com/GamerGb/nogatectools/refs/heads/main/ConfigPEEK.ps1 | iex" -Wait
echo %BGREEN%%BLACK%Configurações de desempenho do Windows foram modificadas com sucesso! %RESET%
ping -n 20 127.0.0.1 > nul

echo %BRED%%BLACK%Configurando Word... %RESET%
reg add "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Word\Security\ProtectedView" /v "DisableInternetFilesInPV" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Word\Security\ProtectedView" /v "DisableAttachmentsInPV" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Word\Security\ProtectedView" /v "DisableUnsafeLocationsInPV" /t REG_DWORD /d 1 /f
echo %BGREEN%%BLACK%Word configurado com sucesso! %RESET%
ping -n 2 127.0.0.1 > nul
echo %BRED%%BLACK%Configurando Excel... %RESET%
reg add "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Excel\Security\ProtectedView" /v "DisableInternetFilesInPV" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Excel\Security\ProtectedView" /v "DisableAttachmentsInPV" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Excel\Security\ProtectedView" /v "DisableUnsafeLocationsInPV" /t REG_DWORD /d 1 /f
echo %BGREEN%%BLACK%Excel configurado com sucesso! %RESET%

rem Game bar
echo %BRED%%BLACK%Configurando Xbox GameBar... %RESET%
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v UseNexusForGameBarEnabled /t REG_DWORD /d 0 /f
rem powershell.exe -Command "irm https://raw.githubusercontent.com/GamerGb/nogatectools/refs/heads/main/ConfigGAMEBARWin10.ps1 | iex" -Wait
echo %BGREEN%%BLACK%Xbox GameBar configurado com sucesso! %RESET%
ping -n 15 127.0.0.1 > nul

rem Segundo Planod
echo %BRED%%BLACK%Desativando aplicativos em segundo plano... %RESET%
Reg Add HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications /v GlobalUserDisabled /t REG_DWORD /d 1 /f
echo %BGREEN%%BLACK%Aplicativos em segundo plano desativado com sucesso! %RESET%
ping -n 3 127.0.0.1 > nul

echo %BRED%%BLACK%Apagando histórico de ícones recentes... %RESET%
del /F /Q %APPDATA%\Microsoft\Windows\Recent\*
echo %BGREEN%%BLACK%Histórico de ícones recentes apagado com sucesso! %RESET%
ping -n 1 127.0.0.1 > nul

echo %BRED%%BLACK%Removendo confirmações dos navegadores...%RESET%
reg add "HKCU\Software\Policies\Google\Chrome" /f >nul
reg add "HKCU\Software\Policies\Google\Chrome" /v PromotionalTabsEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Policies\Google\Chrome" /v SyncDisabled /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Policies\Google\Chrome" /v SigninAllowed /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Policies\Google\Chrome" /v DefaultBrowserSettingEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Policies\Microsoft\Edge" /f >nul
reg add "HKCU\Software\Policies\Microsoft\Edge" /v HideFirstRunExperience /t REG_DWORD /d 1 /f >nul
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v HideFirstRunExperience /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Policies\Microsoft\Edge" /v SyncDisabled /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Policies\Microsoft\Edge" /v SignInAllowed /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Policies\Microsoft\Edge" /v DefaultBrowserSettingEnabled /t REG_DWORD /d 0 /f >nul
:: Cria o arquivo de configuração para políticas do Firefox
set "FIREFOX_POLICY=%ProgramFiles%\Mozilla Firefox\distribution\policies.json"
if not exist "%ProgramFiles%\Mozilla Firefox\distribution" mkdir "%ProgramFiles%\Mozilla Firefox\distribution"
(
echo {
echo   "policies": {
echo     "DontCheckDefaultBrowser": true,
echo     "DisableTelemetry": true,
echo     "DisableFirefoxAccounts": true,
echo     "DisablePocket": true,
echo     "DisableProfileImport": true,
echo     "NoDefaultBookmarks": true,
echo     "OverrideFirstRunPage": "",
echo     "OverridePostUpdatePage": ""
echo   }
echo }
) > "%FIREFOX_POLICY%"
echo %BGREEN%%BLACK%Confirmações removidas com sucesso! %RESET%

echo %BRED%%BLACK%Desligando serviço do Windows Update... %RESET%
sc stop wuauserv
ping -n 1 127.0.0.1 > nul
sc config wuauserv start= disabled
ping -n 1 127.0.0.1 > nul
echo %BGREEN%%BLACK%Serviço desligado com sucesso! %RESET%

echo %BRED%%BLACK%Desinstalando Aplicativos... %RESET%
winget uninstall "cortana"
winget uninstall help
winget uninstall "feedback hub"
winget uninstall "LinkedIn"
winget uninstall "LinkedInforWindows"
winget uninstall "MSN CLima"
winget uninstall 9WZDNCRD29V9
winget uninstall 9NBLGGH5R558
winget uninstall MSIX\Microsoft.BingNews_4.55.62231.0_x64__8wekyb3d8bbwe
winget uninstall 9NRX63209R7B
winget uninstall MSIX\Microsoft.People_10.2202.100.0_x64__8wekyb3d8bbwe
winget uninstall MSIX\Microsoft.MicrosoftSolitaireCollection_4.21.12110.0_x64__8wekyb3d8bbwe
winget uninstall Microsoft.OutlookForWindows_8wekyb3d8bbwe
winget uninstall Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe
winget uninstall MicrosoftCorporationII.QuickAssist_8wekyb3d8bbwe
winget uninstall Microsoft.Getstarted_8wekyb3d8bbwe
winget uninstall Microsoft.Todos_8wekyb3d8bbwe
winget uninstall Microsoft.People_8wekyb3d8bbwe
winget uninstall Microsoft.GetHelp_8wekyb3d8bbwe 
winget uninstall Microsoft.BingWeather_8wekyb3d8bbwe
winget uninstall Microsoft.549981C3F5F10_8wekyb3d8bbwe
winget uninstall microsoft.windowscommunicationsapps_8wekyb3d8bbwe
winget uninstall Microsoft.WindowsMaps_8wekyb3d8bbwe 
winget uninstall Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe 


echo %BGREEN%%BLACK%Aplicativos foram desinstalados com sucesso! %RESET%

ping -n 5 127.0.0.1 > nul
rem Abrindo msconfig
echo %BRED%%BLACK%Abrindo msconfig... %RESET%
rem powershell.exe -Command "irm https://raw.githubusercontent.com/GamerGb/nogatectools/refs/heads/main/ConfigMSCONFIG.ps1 | iex" -Wait
msconfig
echo %BGREEN%%BLACK%Msconfig aberto com sucesso! %RESET%
pause


rem Abrindo Gerenciador de Tarefas
echo %BRED%%BLACK%Abrindo Gerenciador de Tarefas... %RESET%
taskmgr /0 /startup
echo %BGREEN%%BLACK%Gerenciador de Tarefas aberto com sucesso! %RESET%
pause

rem Verificação se as notificações foram desativadas
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d 0 /f
echo %BRED%%BLACK%Abrindo notificações... %RESET%
start ms-settings:notifications
echo %BGREEN%%BLACK%Notificações aberta com sucesso! %RESET%
pause

rem Aplicativos padrão
echo %BRED%%BLACK%Abrindo aplicativos padrões... %RESET%
start ms-settings:defaultapps
echo %BGREEN%%BLACK%Aplicativos padrões aberto com sucesso! %RESET%
pause

rem Remover apps
echo %BRED%%BLACK%Abrindo Adicionar/remover programas... %RESET%
start ms-settings:appsfeatures
echo %BGREEN%%BLACK%Adicionar/remover programas aberto com sucesso! %RESET%
pause


ping -n 5 127.0.0.1 > nul

rem Abrir config intel
if exist "C:\Windows\System32\igfxCPL.cpl" (
    start C:\Windows\System32\igfxCPL.cpl
	pause
) 

ping -n 5 127.0.0.1 > nul

	echo %BRED%%BLACK%Abrindo GPEDIT para configurar o Windows Update...%RESET%	
	gpedit.msc
	echo %BGREEN%%BLACK%GPEDIT aberto com sucesso! %RESET%	
	pause
	
rem Apaga temp e cache
echo %BRED%%BLACK%Removendo arquivos temporários e cache... %RESET%	
rmdir /s /q "C:\Windows\Temp"
rmdir /s /q "%USERPROFILE%\AppData\Local\Temp"
DEL /F /S /Q /A %LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db
echo %BGREEN%%BLACK%Arquivos temporários e cache foram removidos com sucesso! %RESET%	

echo %BRED%%BLACK%Definindo configurações no regedit... %RESET%	
reg add "HKCU\Software\Microsoft\PolicyManager\default\NewsAndInterests\AllowNewsAndInterests" /v "value" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "HideRecentlyAddedApps" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "ShowOrHideMostUsedApps" /t REG_DWORD /d "2" /f
rem Desativa dicas, recomendações, atalhos, novos aplicativos no menu Iniciar
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_IrisRecommendations" /t REG_DWORD /d "0" /f
rem Desativa programas mais usados no menu iniciar
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoStartMenuMFUprogramsList" /t REG_DWORD /d "1" /f
reg add "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\Microsoft.549981C3F5F10_8wekyb3d8bbwe!App" /v "AgentActivationEnabled" /t REG_DWORD /d "0"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CanCortanaBeEnabled" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaEnabled" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaConsent" /t REG_DWORD /d "0" /f
rem Desativar Copilot
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCopilotButton" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d "1" /f
reg add "HKCU\Software\Microsoft\Windows\Shell\Copilot" /v "CopilotDisabledReason" /t REG_SZ /d "FeatureIsDisabled" /f
reg add "HKCU\Software\Microsoft\Windows\Shell\Copilot" /v "IsCopilotAvailable" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\Shell\Copilot\BingChat" /v "IsUserEligible" /t REG_DWORD /d "0" /f
echo %BGREEN%%BLACK%Configurações no REGEDIT foram definidas com sucesso! %RESET%	

SystemPropertiesAdvanced
pause

rem Definir variáveis de pasta e arquivos
set "pasta_instalacao=%USERPROFILE%\Desktop\Nova Pasta"
set "pasta_office=%pasta_instalacao%\Office 2021"
set "pasta_aact=%pasta_instalacao%\AAct_Network_x64"
set "arquivo_rar=%pasta_instalacao%\Arquivos.rar"
set "arquivo_windef=%pasta_instalacao%\WinDef.rar"
set "pasta_windef=%pasta_instalacao%\WinDef\"
set "link_dropbox=https://www.dropbox.com/s/geisbvplfws907e/Arquivos.rar?st=7d958qjl&dl=1" 

rem Verifica se a pasta de instalação já existe, caso contrário cria
if not exist "%pasta_instalacao%" (
    echo %BRED%%BLACK%Criando pasta da instalação dos programas...%RESET%
    md "%pasta_instalacao%" >nul 2>&1
        echo %BGREEN%%BLACK%Pasta criada com sucesso! %RESET%
)

ping -n 2 127.0.0.1 > nul

rem Baixando o arquivo Arquivos.rar
echo %BRED%%BLACK%Baixando o arquivo Arquivos.rar... %RESET%
curl -L -o "%arquivo_rar%" "%link_dropbox%"
if %ERRORLEVEL% NEQ 0 (
    echo %BBLUE%%BLACK%Falha ao baixar o arquivo Arquivos.rar.%RESET%
    pause
    goto :MENU
) else (
echo %BGREEN%%BLACK%Arquivo Arquivos.rar baixado com sucesso! %RESET%
)

rem Extraindo Arquivos.rar para a pasta de instalação
echo %BRED%%BLACK%Extraindo Arquivos.rar...%RESET%
"C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%arquivo_rar%" "%pasta_instalacao%\" 
if %ERRORLEVEL% NEQ 0 (
    echo %BBLUE%%BLACK%Falha ao extrair o arquivo Arquivos.rar.%RESET%
    pause
) else (
echo %BGREEN%%BLACK%Arquivos RAR extraídos com sucesso! %RESET%
)

rem Extraindo Defender Blocker para desativar o Defender
if exist "%pasta_instalacao%\WinDef.rar" (
    echo %BRED%%BLACK%Extraindo WinDef.rar...%RESET%
    "C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%pasta_instalacao%\WinDef.rar" "%pasta_windef%\"
    if %ERRORLEVEL% NEQ 0 (
        echo %BBLUE%%BLACK%Falha ao extrair o arquivo WinDef.rar.%RESET%
        pause
    ) else (
        echo %BGREEN%%BLACK%Defender Control extraído com sucesso! %RESET%
        echo %BRED%%BLACK%Abrindo Defender Control...%RESET%
        :: powershell -Command "Start-Process '%pasta_windef%\WinDef\dControl.exe' -Verb runAs"
		start "" "%pasta_windef%\WinDef\dControl.exe"
        echo %BGREEN%%BLACK%Defender Control aberto com sucesso! %RESET%
		pause
    )
) else (
    echo %BBLUE%%BLACK%Arquivo WinDef.rar não encontrado.%RESET%
)

rundll32.exe user32.dll,UpdatePerUserSystemParameters
taskkill /f /im explorer.exe
ping -n 2 127.0.0.1 > nul
del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Notifications\wpndatabase.db"
ping -n 2 127.0.0.1 > nul
start explorer.exe
ping -n 2 127.0.0.1 > nul

echo %BRED%%BLACK%Abrindo o aplicativo camera para testar.. %RESET%
start microsoft.windows.camera
echo %BGREEN%%BLACK%Aplicativo camera aberto com sucesso! %RESET%
pause

echo %BRED%%BLACK%Testar wi-fi.. %RESET%
start ms-availablenetworks:
pause

echo %BRED%%BLACK%Testar rede RJ-45.. %RESET%
start ms-availablenetworks:
pause

echo %BRED%%BLACK%Testar USBs.. %RESET%
echo %BWHITE%%BLACK%
powershell -Command "Get-WmiObject -Class Win32_PnPEntity | Where-Object { $_.DeviceID -like 'USB*' } | Select-Object DeviceID, Status"
echo %RESET%
pause

echo %BRED%%BLACK%Testar entradas P2 (Som).. %RESET%
start ms-settings:sound
pause

echo %BRED%%BLACK%Desligando serviço do Windows Update... %RESET%
sc stop wuauserv
ping -n 1 127.0.0.1 > nul
sc config wuauserv start= disabled
ping -n 1 127.0.0.1 > nul
echo %BGREEN%%BLACK%Serviço desligado com sucesso! %RESET%



echo %BBLUE%%BLACK%Configuração concluída com sucesso! %RESET%
pause
goto MENU


rem -------------------

:MENU_CONFIG_PADRAO_WIN11

set "WMP_PATH=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\Windows Media Player.lnk"
set "WMP_LEGACY_PATH=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\Windows Media Player Legacy.lnk"
set "pasta_instalacao=%USERPROFILE%\Desktop\Nova Pasta"
set "arquivo_rar=%pasta_instalacao%\Arquivos.rar"
set "local_wallpaper=C:\Wallpaper.jpg"
set "link_dropbox=https://www.dropbox.com/s/geisbvplfws907e/Arquivos.rar?st=7d958qjl&dl=1"
set "WORD_PATH=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Word.lnk"
set "EXCEL_PATH=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Excel.lnk"

set "CHROME_PATH=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk"
set "EDGE_PATH=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk"
set "FIREFOX_PATH=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Firefox.lnk"
set "SKYPE_PATH=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Skype\Skype.lnk"
set "ADOBE_PATH=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Adobe Acrobat.lnk"
set "ANYDESK_PATH=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\AnyDesk\AnyDesk.lnk"
set "ANYVIEWER_PATH=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\AnyViewer\AnyViewer.lnk"
set "STEAM_PATH=C:\"
set "DISCORD_PATH=C:\"

set "DESKTOP_PATH=%USERPROFILE%\Desktop"

set "pasta_windef=%pasta_instalacao%\WinDef.rar"

cls
call :bannerWIN11
ping -n 2 127.0.0.1 > nul
rem Energia
echo %BRED%%BLACK%Definindo plano de energia...%RESET%
powercfg /S SCHEME_MIN
powercfg -change -monitor-timeout-ac 0
powercfg -change -monitor-timeout-dc 0
powercfg -change -disk-timeout-ac 0
powercfg -change -disk-timeout-dc 0
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 0
powercfg -change -hibernate-timeout-ac 0
powercfg -change -hibernate-timeout-dc 0
echo %BGREEN%%BLACK%Plano de energia definido! %RESET%
ping -n 2 127.0.0.1 > nul

echo %BRED%%BLACK%Abrindo Windows Update... %RESET%
start ms-settings:windowsupdate
echo %BGREEN%%BLACK%Windows Update aberto com sucesso! %RESET%
pause

rem Verificar se o arquivo .theme existe
if exist "%SystemRoot%\Resources\Themes\dark.theme" (
    start "" "%SystemRoot%\Resources\Themes\dark.theme"
	ping -n 5 127.0.0.1 > nul
        taskkill /f /im SystemSettings.exe
        ping -n 2 127.0.0.1 > nul

    taskkill /f /im explorer.exe
    ping -n 5 127.0.0.1 > nul
    start explorer.exe
    echo %BGREEN%%BLACK%Tema Dark aplicado com sucesso!%RESET%
) else (
    echo %BBLUE%%BLACK%O arquivo dark.theme não foi encontrado.%RESET%
)

cmd.exe /c DISM /Online /Remove-OSUninstall
reg delete \"HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\WindowsUpdate\\Orchestrator\\UScheduler_Oobe\\OutlookUpdate\" /f 



setlocal enabledelayedexpansion
rem Caminho da Área de Trabalho e Downloads
set "DESKTOP=%USERPROFILE%\Desktop"
set "downloads=%USERPROFILE%\Downloads"

echo %BRED%%BLACK%Apagando ícones na Área de Trabalho... %RESET%
rem Definir as pastas de área de trabalho do usuário e pública
set "user_desktop=%USERPROFILE%\Desktop"
set "public_desktop=C:\Users\Public\Desktop"
rem Excluir ícones na área de trabalho do usuário
for %%F in ("%user_desktop%\*") do (
    if /I "%%~nxF" neq "%~nx0" (
        del /f /q "%%F" >nul 2>&1
        rmdir /s /q "%%F" >nul 2>&1
    )
)
rem Excluir ícones na área de trabalho pública
for %%F in ("%public_desktop%\*") do (
    if /I "%%~nxF" neq "%~nx0" (
        rem Verifica se o arquivo já foi excluído na área de trabalho do usuário
        if not exist "%user_desktop%\%%~nxF" (
            del /f /q "%%F" >nul 2>&1
            rmdir /s /q "%%F" >nul 2>&1
        )
    )
)
echo %BGREEN%%BLACK%Ícones apagados com sucesso! %RESET%
echo %BRED%%BLACK%Movendo ícones... %RESET%
for %%F in ("%user_desktop%\*") do (
    if /I "%%~nxF" neq "%~nx0" (
        move /Y "%%F" "%downloads%" >nul 2>&1
    )
)

:: Mover arquivos e pastas do Desktop público, se ainda não foram movidos
for %%F in ("%public_desktop%\*") do (
    if /I "%%~nxF" neq "%~nx0" (
        rem Verifica se o arquivo ou pasta já foi movido
        if not exist "%user_desktop%\%%~nxF" (
            move /Y "%%F" "%downloads%" >nul 2>&1
        )
    )
)
ping -n 3 127.0.0.1 > nul
move /y "%USERPROFILE%\Desktop\Nova Pasta" "%USERPROFILE%\Downloads"
ping -n 3 127.0.0.1 > nul
echo %BGREEN%%BLACK%Ícones movidos com sucesso! %RESET%
rem Atualiza área de trabalho
taskkill /f /im explorer.exe >nul 2>&1
ping -n 2 127.0.0.1 >nul
start explorer.exe
rem Removendo Tudo
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d 1 /f
taskkill /f /im explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 3 127.0.0.1 > nul
start explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 5 127.0.0.1 > nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 1 /f
taskkill /f /im explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 3 127.0.0.1 > nul
start explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 5 127.0.0.1 > nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 1 /f
taskkill /f /im explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 3 127.0.0.1 > nul
start explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 5 127.0.0.1 > nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /t REG_DWORD /d 1 /f
taskkill /f /im explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 3 127.0.0.1 > nul
start explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 5 127.0.0.1 > nul
rem Adicionando seus respectivos ícones principais (Usuario, Meu Computador, Rede, Lixeira)
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0 /f
taskkill /f /im explorer.exe
ping -n 5 127.0.0.1 > nul
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
start explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 5 127.0.0.1 > nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f
taskkill /f /im explorer.exe
ping -n 5 127.0.0.1 > nul
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
start explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 5 127.0.0.1 > nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /t REG_DWORD /d 0 /f
taskkill /f /im explorer.exe
ping -n 5 127.0.0.1 > nul
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
start explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 5 127.0.0.1 > nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d 0 /f
taskkill /f /im explorer.exe
ping -n 5 127.0.0.1 > nul
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
start explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 5 127.0.0.1 > nul
rem Criando atalhos principais
echo %BRED%%BLACK% Criando atalhos... %RESET%
rem Função para copiar atalho apenas se o arquivo existir
call :copiarAtalho "%EDGE_PATH%" "Microsoft Edge.lnk"
ping -n 2 127.0.0.1 >nul
call :copiarAtalho "%FIREFOX_PATH%" "Firefox.lnk"
ping -n 2 127.0.0.1 >nul
call :copiarAtalho "%CHROME_PATH%" "Google Chrome.lnk"
ping -n 2 127.0.0.1 >nul
call :copiarAtalho "%SKYPE_PATH%" "Skype.lnk"
ping -n 2 127.0.0.1 >nul
call :copiarAtalho "%WORD_PATH%" "Word.lnk"
ping -n 2 127.0.0.1 >nul
call :copiarAtalho "%EXCEL_PATH%" "Excel.lnk"
ping -n 2 127.0.0.1 >nul
call :copiarAtalho "%ANYDESK_PATH%" "AnyDesk.lnk"
ping -n 2 127.0.0.1 >nul
call :copiarAtalho "%ANYVIEWER_PATH%" "AnyViewer.lnk"
ping -n 2 127.0.0.1 >nul 
call :copiarAtalho "%ADOBE_PATH%" "Adobe Acrobat.lnk"
ping -n 2 127.0.0.1 >nul

echo %BGREEN%%BLACK% Ícones organizados! %RESET%
echo %BRED%%BLACK%Movendo ícones e pastas de volta para a Área de Trabalho... %RESET%
:: Mover todos os arquivos e pastas de volta para a Área de Trabalho
for %%F in ("%downloads%\*") do (
    if /I "%%~nxF" neq "%~nx0" (
        move /Y "%%F" "%user_desktop%" >nul 2>&1
    )
)

echo %BGREEN%%BLACK%Ícones movidos de volta para a Área de Trabalho com sucesso! %RESET%

move /y "%USERPROFILE%\Downloads\Nova Pasta" "%USERPROFILE%\Desktop" 
ping -n 2 127.0.0.1 >nul

ping -n 2 127.0.0.1 > nul
rem UAC
echo %BRED%%BLACK%Definindo UAC...%RESET%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f
echo %BGREEN%%BLACK%UAC definido! %RESET%
ping -n 2 127.0.0.1 > nul
rem Windows Media Player
set WMP_PATH="C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\Windows Media Player.lnk"
set WMP_LEGACY_PATH="C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\Windows Media Player Legacy.lnk"
echo %BRED%%BLACK%Definindo as configurações para o Windows Media Player...%RESET%
reg add "HKCU\Software\Microsoft\MediaPlayer\Preferences" /v AcceptedPrivacyStatement /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\MediaPlayer\Preferences" /v FirstRun /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\MediaPlayer\Preferences" /v ShowFirstRun /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\MediaPlayer\Preferences" /v QuickLaunchSettings /t REG_DWORD /d 1 /f

rem Wallpaper
ping -n 3 127.0.0.1 > nul
set "pasta_instalacao=%USERPROFILE%\Desktop\Nova Pasta"
rem Verifica se a pasta de instalação já existe, caso contrário cria
if not exist "%pasta_instalacao%" (
    echo %BRED%%BLACK%Criando pasta da instalação dos programas...%RESET%
    md "%pasta_instalacao%" >nul 2>&1
        echo %BGREEN%%BLACK%Pasta criada com sucesso! %RESET%
		
			echo %BRED%%BLACK%Baixando o arquivo Arquivos.rar... %RESET%
		curl -L -o "%arquivo_rar%" "%link_dropbox%"
		echo %BGREEN%%BLACK%Arquivo Arquivos.rar baixado com sucesso! %RESET%
		if exist "C:\Program Files\WinRAR\WinRAR.exe" (
			echo %BGREEN%%BLACK%WinRAR já está instalado, prosseguindo...%RESET%
		) else (
			echo %BRED%%BLACK%WinRAR não foi encontrado. Iniciando sua instalação...%RESET%
			winget settings --enable InstallerHashOverride
			winget install --id "RARLab.WinRAR" --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force --ignore-security-hash
			echo %BGREEN%%BLACK%WinRAR instalado com sucesso!%RESET%
		)

		echo %BRED%%BLACK%Extraindo Arquivos.rar...%RESET%
		"C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%arquivo_rar%" "%pasta_instalacao%\" 
		if %ERRORLEVEL% NEQ 0 (
			echo %BRED%%BLACK%Falha ao extrair o arquivo Arquivos.rar.%RESET%
			pause
				goto :MENU
		) 
		echo %BGREEN%%BLACK%Arquivos RAR extraídos com sucesso! %RESET%
		
) else (
		echo %BRED%%BLACK%Extraindo Arquivos.rar...%RESET%
		"C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%arquivo_rar%" "%pasta_instalacao%\" 
		echo %BGREEN%%BLACK%Arquivos RAR extraídos com sucesso! %RESET%
)

rem Comandos Powershell para config
rem powershell.exe -Command "Start-Process powershell.exe -ArgumentList '-Command', 'irm https://raw.githubusercontent.com/GamerGb/nogatectools/refs/heads/main/ConfigWin10.ps1 | iex'" -Verb RunAs -WindowStyle Hidden -Wait
powershell.exe -Command "irm https://raw.githubusercontent.com/GamerGb/nogatectools/refs/heads/main/ConfigWin10.ps1 | iex; Wait-Process -Name powershell"


echo %BRED%%BLACK%Desativando Telemetria...%RESET%
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f

echo %BRED%%BLACK%Desabilitando sugestões de aplicativos...%RESET%
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v ContentDeliveryAllowed /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v OemPreInstalledAppsEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v PreInstalledAppsEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v PreInstalledAppsEverEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SilentInstalledAppsEnabled /t REG_DWORD /d 0 /f

echo %BRED%%BLACK%Desativando Histórico de Atividades...%RESET%
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v PublishUserActivities /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v UploadUserActivities /t REG_DWORD /d 0 /f
rem echo Desativando Rastreamento de Localização...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v Value /t REG_SZ /d Deny /f
rem echo Desativando Atualizações Automáticas de Mapas...
reg add "HKLM\SYSTEM\Maps" /v AutoUpdateEnabled /t REG_DWORD /d 0 /f
rem echo Desativando Relatório de Erros...
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f
rem echo Ocultando Widgets da Barra de Tarefas...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f
rem echo Desativando Pré-Carregamento do Edge...
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge" /v AllowPrelaunch /t REG_DWORD /d 0 /f
rem echo Tweaks aplicados com sucesso!
rem echo Disabling some services...
for %%s in (
    "diagnosticshub.standardcollector.service"
    "dmwappushservice"
    "edgeupdate"
    "edgeupdatem"
    "EntAppSvc"
    "Fax"
    "fhsvc"
    "gupdate"
    "gupdatem"
    "lfsvc"
    "MapsBroker"
    "MicrosoftEdgeElevationService"
    "MSDTC"
    "RetailDemo"
    "SCardSvr"
    "SEMgrSvc"
    "WMPNetworkSvc"
    "WpcMonSvc"
    "WPDBusEnum"
    "WpnService"
    "HPAppHelperCap"
    "HPDiagsCap"
    "HPNetworkCap"
    "HPSysInfoCap"
    "HpTouchpointAnalyticsService"
    "dcpm-notify"
    "DDVCollectorSvcApi"
    "DDVDataCollector"
    "DDVRulesProcessor"
    "Dell.CommandPowerManager.Service"
    "DellClientManagementService"
    "DellTechHub"
    "DPMService"
    "SupportAssistAgent"
    "AdobeARMservice"
    "FoxitReaderUpdateService"
    "StateRepository"
    "StorSvc"
) do (
    echo Checking service %%s...
    sc qc %%s >nul 2>&1
    if errorlevel 1 (
        echo Service %%s not found!
    ) else (
        for /f "tokens=3" %%t in ('sc qc %%s ^| find "START_TYPE"') do (
            if "%%t"==" 2" (
                echo Stopping %%s...
                net stop %%s >nul 2>&1
                echo Setting %%s to Manual...
                sc config %%s start= demand
            )
        )
    )
)

echo %BGREEN%%BLACK%Modificações realizadas com sucesso! %RESET%

echo %BRED%%BLACK%Desativando Windows Hello na entrada...%RESET%
reg ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\PasswordLess\Device" /v DevicePasswordLessBuildVersion /t REG_DWORD /d 0 /f
echo %BGREEN%%BLACK%Windows Hello desativado com sucesso! %RESET%

ping -n 10 127.0.0.1 > nul

reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "%local_wallpaper%" /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
taskkill /f /im explorer.exe
ping -n 2 127.0.0.1 > nul
start explorer.exe
ping -n 2 127.0.0.1 > nul
echo %BGREEN%%BLACK%Wallpaper definido com sucesso! %RESET%


ping -n 2 127.0.0.1 > nul
rem Notificações
echo %BRED%%BLACK%Definindo configurações das notificações...%RESET%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 0 /f
taskkill /f /im explorer.exe
ping -n 5 127.0.0.1 > nul
start explorer.exe
ping -n 2 127.0.0.1 > nul

echo %BRED%%BLACK%Realizando configurações de impressora...%RESET%
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Print" /v RpcAuthnLevelPrivacyEnabled /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Policies\Microsoft\FeatureManagement\Overrides" /v 3598754956 /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Policies\Microsoft\FeatureManagement\Overrides" /v 1921033356 /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Policies\Microsoft\FeatureManagement\Overrides" /v 713073804 /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC" /v RpcUseNamedPipeProtocol /t REG_DWORD /d 1 /f
taskkill /f /im explorer.exe
ping -n 5 127.0.0.1 > nul
start explorer.exe
ping -n 2 127.0.0.1 > nul
echo %BGREEN%%BLACK%Configurações de impressora foram modificadas com sucesso! %RESET%



rem Definir tema padrão
	REM echo %BRED%%BLACK%Definindo tema do windows...%RESET%
	rem start "" "C:\Windows\Resources\Themes\aero.theme"
	rem explorer "C:\Windows\Resources\Themes\aero.theme"
	rem ping -n 4 127.0.0.1 > nul
	rem taskkill /im systemsettings.exe /f
	rem ping -n 3 127.0.0.1 > nul


rundll32.exe user32.dll,UpdatePerUserSystemParameters
rem echo %BGREEN%%BLACK%Tema definido com sucesso! %RESET%
rem padronizando tema


rem WALLPAPER NOVAMENTE PARA EVITAR PROBLEMAS
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "%local_wallpaper%" /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
taskkill /f /im explorer.exe
ping -n 2 127.0.0.1 > nul
start explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 3 127.0.0.1 > nul

rem Ajustar configurações para máximo desempenho no Windows
echo %BRED%%BLACK%Definindo configuracões de desempenho do Windows... %RESET%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f
ping -n 2 127.0.0.1 > nul
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
taskkill /f /im explorer.exe
ping -n 2 127.0.0.1 > nul
start explorer.exe
ping -n 2 127.0.0.1 > nul
rundll32.exe user32.dll,UpdatePerUserSystemParameters
ping -n 1 127.0.0.1 > nul
echo %BRED%%BLACK%Modificando as configurações... %RESET%
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 1 /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
taskkill /f /im explorer.exe
ping -n 2 127.0.0.1 > nul
start explorer.exe
reg add "HKCU\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d 2 /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
taskkill /f /im explorer.exe
ping -n 2 127.0.0.1 > nul
start explorer.exe
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 0 /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
taskkill /f /im explorer.exe
ping -n 2 127.0.0.1 > nul
start explorer.exe
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 1 /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
taskkill /f /im explorer.exe
ping -n 2 127.0.0.1 > nul
start explorer.exe


rem powershell.exe -Command "irm https://raw.githubusercontent.com/GamerGb/nogatectools/refs/heads/main/ConfigPEEK.ps1 | iex" -Wait
echo %BGREEN%%BLACK%Configurações de desempenho do Windows foram modificadas com sucesso! %RESET%
ping -n 20 127.0.0.1 > nul

echo %BRED%%BLACK%Configurando Word... %RESET%
reg add "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Word\Security\ProtectedView" /v "DisableInternetFilesInPV" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Word\Security\ProtectedView" /v "DisableAttachmentsInPV" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Word\Security\ProtectedView" /v "DisableUnsafeLocationsInPV" /t REG_DWORD /d 1 /f
echo %BGREEN%%BLACK%Word configurado com sucesso! %RESET%
ping -n 2 127.0.0.1 > nul
echo %BRED%%BLACK%Configurando Excel... %RESET%
reg add "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Excel\Security\ProtectedView" /v "DisableInternetFilesInPV" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Excel\Security\ProtectedView" /v "DisableAttachmentsInPV" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Excel\Security\ProtectedView" /v "DisableUnsafeLocationsInPV" /t REG_DWORD /d 1 /f
echo %BGREEN%%BLACK%Excel configurado com sucesso! %RESET%

rem Game bar
echo %BRED%%BLACK%Configurando Xbox GameBar... %RESET%
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v UseNexusForGameBarEnabled /t REG_DWORD /d 0 /f
rem powershell.exe -Command "irm https://raw.githubusercontent.com/GamerGb/nogatectools/refs/heads/main/ConfigGAMEBARWin10.ps1 | iex" -Wait
echo %BGREEN%%BLACK%Xbox GameBar configurado com sucesso! %RESET%
ping -n 15 127.0.0.1 > nul

rem Segundo Planod
echo %BRED%%BLACK%Desativando aplicativos em segundo plano... %RESET%
Reg Add HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications /v GlobalUserDisabled /t REG_DWORD /d 1 /f
echo %BGREEN%%BLACK%Aplicativos em segundo plano desativado com sucesso! %RESET%
ping -n 3 127.0.0.1 > nul

echo %BRED%%BLACK%Apagando histórico de ícones recentes... %RESET%
del /F /Q %APPDATA%\Microsoft\Windows\Recent\*
echo %BGREEN%%BLACK%Histórico de ícones recentes apagado com sucesso! %RESET%
ping -n 1 127.0.0.1 > nul

echo %BRED%%BLACK%Desligando serviço do Windows Update... %RESET%
sc stop wuauserv
ping -n 1 127.0.0.1 > nul
sc config wuauserv start= disabled
ping -n 1 127.0.0.1 > nul
echo %BGREEN%%BLACK%Serviço desligado com sucesso! %RESET%

echo %BRED%%BLACK%Desinstalando Aplicativos... %RESET%
winget uninstall "cortana"
winget uninstall help
winget uninstall "feedback hub"
winget uninstall "LinkedIn"
winget uninstall "LinkedInforWindows"
winget uninstall "MSN CLima"
winget uninstall 9WZDNCRD29V9
winget uninstall 9NBLGGH5R558
winget uninstall MSIX\Microsoft.BingNews_4.55.62231.0_x64__8wekyb3d8bbwe
winget uninstall 9NRX63209R7B
winget uninstall MSIX\Microsoft.People_10.2202.100.0_x64__8wekyb3d8bbwe
winget uninstall MSIX\Microsoft.MicrosoftSolitaireCollection_4.21.12110.0_x64__8wekyb3d8bbwe
winget uninstall Microsoft.OutlookForWindows_8wekyb3d8bbwe
winget uninstall Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe
winget uninstall MicrosoftCorporationII.QuickAssist_8wekyb3d8bbwe
winget uninstall Microsoft.Getstarted_8wekyb3d8bbwe
winget uninstall Microsoft.Todos_8wekyb3d8bbwe
winget uninstall Microsoft.People_8wekyb3d8bbwe
winget uninstall Microsoft.GetHelp_8wekyb3d8bbwe 
winget uninstall Microsoft.BingWeather_8wekyb3d8bbwe
winget uninstall Microsoft.549981C3F5F10_8wekyb3d8bbwe
winget uninstall microsoft.windowscommunicationsapps_8wekyb3d8bbwe
winget uninstall Microsoft.WindowsMaps_8wekyb3d8bbwe 
winget uninstall Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe 

echo %BGREEN%%BLACK%Aplicativos foram desinstalados com sucesso! %RESET%

echo %BRED%%BLACK%Removendo confirmações dos navegadores...%RESET%
reg add "HKCU\Software\Policies\Google\Chrome" /f >nul
reg add "HKCU\Software\Policies\Google\Chrome" /v PromotionalTabsEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Policies\Google\Chrome" /v SyncDisabled /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Policies\Google\Chrome" /v SigninAllowed /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Policies\Google\Chrome" /v DefaultBrowserSettingEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Policies\Microsoft\Edge" /f >nul
reg add "HKCU\Software\Policies\Microsoft\Edge" /v HideFirstRunExperience /t REG_DWORD /d 1 /f >nul
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v HideFirstRunExperience /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Policies\Microsoft\Edge" /v SyncDisabled /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Policies\Microsoft\Edge" /v SignInAllowed /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Policies\Microsoft\Edge" /v DefaultBrowserSettingEnabled /t REG_DWORD /d 0 /f >nul
:: Cria o arquivo de configuração para políticas do Firefox
set "FIREFOX_POLICY=%ProgramFiles%\Mozilla Firefox\distribution\policies.json"
if not exist "%ProgramFiles%\Mozilla Firefox\distribution" mkdir "%ProgramFiles%\Mozilla Firefox\distribution"
(
echo {
echo   "policies": {
echo     "DontCheckDefaultBrowser": true,
echo     "DisableTelemetry": true,
echo     "DisableFirefoxAccounts": true,
echo     "DisablePocket": true,
echo     "DisableProfileImport": true,
echo     "NoDefaultBookmarks": true,
echo     "OverrideFirstRunPage": "",
echo     "OverridePostUpdatePage": ""
echo   }
echo }
) > "%FIREFOX_POLICY%"
echo %BGREEN%%BLACK%Confirmações removidas com sucesso! %RESET%

echo %BRED%%BLACK%Definindo configurações da barra de tarefas...%RESET%
reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /t REG_DWORD /d 3 /f
taskkill /f /im explorer.exe
ping -n 2 127.0.0.1 > null
start explorer.exe
reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /t REG_DWORD /d 3 /f
taskkill /f /im explorer.exe
ping -n 2 127.0.0.1 > null
start explorer.exe
echo %BGREEN%%BLACK%Configurações da barra de tarefas foram definidas com sucesso! %RESET%


ping -n 5 127.0.0.1 > nul
rem Abrindo msconfig
echo %BRED%%BLACK%Abrindo msconfig... %RESET%
rem powershell.exe -Command "irm https://raw.githubusercontent.com/GamerGb/nogatectools/refs/heads/main/ConfigMSCONFIG.ps1 | iex" -Wait
msconfig
echo %BGREEN%%BLACK%Msconfig aberto com sucesso! %RESET%
pause


rem Abrindo Gerenciador de Tarefas
echo %BRED%%BLACK%Abrindo Gerenciador de Tarefas... %RESET%
taskmgr /0 /startup
echo %BGREEN%%BLACK%Gerenciador de Tarefas aberto com sucesso! %RESET%
pause

rem Verificação se as notificações foram desativadas
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d 0 /f
echo %BRED%%BLACK%Abrindo notificações... %RESET%
start ms-settings:notifications
echo %BGREEN%%BLACK%Notificações aberta com sucesso! %RESET%
pause

rem Aplicativos padrão
echo %BRED%%BLACK%Abrindo aplicativos padrões... %RESET%
start ms-settings:defaultapps
echo %BGREEN%%BLACK%Aplicativos padrões aberto com sucesso! %RESET%
pause

rem Remover apps
echo %BRED%%BLACK%Abrindo Adicionar/remover programas... %RESET%
start ms-settings:appsfeatures
echo %BGREEN%%BLACK%Adicionar/remover programas aberto com sucesso! %RESET%
pause


ping -n 5 127.0.0.1 > nul

rem Abrir config intel
if exist "C:\Windows\System32\igfxCPL.cpl" (
    start C:\Windows\System32\igfxCPL.cpl
	pause
) 

ping -n 5 127.0.0.1 > nul

	echo %BRED%%BLACK%Abrindo GPEDIT para configurar o Windows Update...%RESET%	
	gpedit.msc
	echo %BGREEN%%BLACK%GPEDIT aberto com sucesso! %RESET%	
	pause
	
rem Apaga temp e cache
echo %BRED%%BLACK%Removendo arquivos temporários e cache... %RESET%	
rmdir /s /q "C:\Windows\Temp"
rmdir /s /q "%USERPROFILE%\AppData\Local\Temp"
DEL /F /S /Q /A %LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db
echo %BGREEN%%BLACK%Arquivos temporários e cache foram removidos com sucesso! %RESET%	

echo %BRED%%BLACK%Definindo configurações no regedit... %RESET%	
reg add "HKCU\Software\Microsoft\PolicyManager\default\NewsAndInterests\AllowNewsAndInterests" /v "value" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "HideRecentlyAddedApps" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "ShowOrHideMostUsedApps" /t REG_DWORD /d "2" /f
rem Desativa dicas, recomendações, atalhos, novos aplicativos no menu Iniciar
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_IrisRecommendations" /t REG_DWORD /d "0" /f
rem Desativa programas mais usados no menu iniciar
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoStartMenuMFUprogramsList" /t REG_DWORD /d "1" /f
reg add "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\Microsoft.549981C3F5F10_8wekyb3d8bbwe!App" /v "AgentActivationEnabled" /t REG_DWORD /d "0"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CanCortanaBeEnabled" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaEnabled" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaConsent" /t REG_DWORD /d "0" /f
rem Desativar Copilot
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCopilotButton" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d "1" /f
reg add "HKCU\Software\Microsoft\Windows\Shell\Copilot" /v "CopilotDisabledReason" /t REG_SZ /d "FeatureIsDisabled" /f
reg add "HKCU\Software\Microsoft\Windows\Shell\Copilot" /v "IsCopilotAvailable" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\Shell\Copilot\BingChat" /v "IsUserEligible" /t REG_DWORD /d "0" /f
echo %BGREEN%%BLACK%Configurações no REGEDIT foram definidas com sucesso! %RESET%	


SystemPropertiesAdvanced
pause

rem Definir variáveis de pasta e arquivos
set "pasta_instalacao=%USERPROFILE%\Desktop\Nova Pasta"
set "pasta_office=%pasta_instalacao%\Office 2021"
set "pasta_aact=%pasta_instalacao%\AAct_Network_x64"
set "arquivo_rar=%pasta_instalacao%\Arquivos.rar"
set "arquivo_windef=%pasta_instalacao%\WinDef.rar"
set "pasta_windef=%pasta_instalacao%\WinDef\"
set "link_dropbox=https://www.dropbox.com/s/geisbvplfws907e/Arquivos.rar?st=7d958qjl&dl=1" 

rem Verifica se a pasta de instalação já existe, caso contrário cria
if not exist "%pasta_instalacao%" (
    echo %BRED%%BLACK%Criando pasta da instalação dos programas...%RESET%
    md "%pasta_instalacao%" >nul 2>&1
        echo %BGREEN%%BLACK%Pasta criada com sucesso! %RESET%
)

ping -n 2 127.0.0.1 > nul

rem Baixando o arquivo Arquivos.rar
echo %BRED%%BLACK%Baixando o arquivo Arquivos.rar... %RESET%
curl -L -o "%arquivo_rar%" "%link_dropbox%"
if %ERRORLEVEL% NEQ 0 (
    echo %BBLUE%%BLACK%Falha ao baixar o arquivo Arquivos.rar.%RESET%
    pause
    goto :MENU
) else (
echo %BGREEN%%BLACK%Arquivo Arquivos.rar baixado com sucesso! %RESET%
)


rem Extraindo Arquivos.rar para a pasta de instalação
echo %BRED%%BLACK%Extraindo Arquivos.rar...%RESET%
"C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%arquivo_rar%" "%pasta_instalacao%\" 
if %ERRORLEVEL% NEQ 0 (
    echo %BBLUE%%BLACK%Falha ao extrair o arquivo Arquivos.rar.%RESET%
    pause
) else (
echo %BGREEN%%BLACK%Arquivos RAR extraídos com sucesso! %RESET%
)

rem Extraindo Defender Blocker para desativar o Defender
if exist "%pasta_instalacao%\WinDef.rar" (
    echo %BRED%%BLACK%Extraindo WinDef.rar...%RESET%
    "C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%pasta_instalacao%\WinDef.rar" "%pasta_windef%\"
    if %ERRORLEVEL% NEQ 0 (
        echo %BBLUE%%BLACK%Falha ao extrair o arquivo WinDef.rar.%RESET%
        pause
    ) else (
        echo %BGREEN%%BLACK%Defender Control extraído com sucesso! %RESET%
        echo %BRED%%BLACK%Abrindo Defender Control...%RESET%
        :: powershell -Command "Start-Process '%pasta_windef%\WinDef\dControl.exe' -Verb runAs"
		start "" "%pasta_windef%\WinDef\dControl.exe"
        echo %BGREEN%%BLACK%Defender Control aberto com sucesso! %RESET%
		pause
    )
) else (
    echo %BBLUE%%BLACK%Arquivo WinDef.rar não encontrado.%RESET%
)

echo %BRED%%BLACK%Apagando Windows.old...%RESET%
powershell -Command "Remove-Item -LiteralPath 'C:\Windows.old' -Recurse -Force"
echo %BGREEN%%BLACK%Windows.old foi apagado com sucesso! %RESET%

rundll32.exe user32.dll,UpdatePerUserSystemParameters
taskkill /f /im explorer.exe
ping -n 2 127.0.0.1 > nul
del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Notifications\wpndatabase.db"
ping -n 2 127.0.0.1 > nul
start explorer.exe
ping -n 2 127.0.0.1 > nul

echo %BRED%%BLACK%Abrindo o aplicativo camera para testar.. %RESET%
start microsoft.windows.camera:
echo %BGREEN%%BLACK%Aplicativo camera aberto com sucesso! %RESET%
pause

echo %BRED%%BLACK%Testar wi-fi.. %RESET%
start ms-availablenetworks:
pause

echo %BRED%%BLACK%Testar rede RJ-45.. %RESET%
start ms-availablenetworks:
pause

echo %BRED%%BLACK%Testar USBs.. %RESET%
echo %BWHITE%%BLACK%
powershell -Command "Get-WmiObject -Class Win32_PnPEntity | Where-Object { $_.DeviceID -like 'USB*' } | Select-Object DeviceID, Status"
echo %RESET%
pause

echo %BRED%%BLACK%Testar entradas P2 (Som).. %RESET%
start ms-settings:sound
pause

echo %BRED%%BLACK%Desligando serviço do Windows Update... %RESET%
sc stop wuauserv
ping -n 1 127.0.0.1 > nul
sc config wuauserv start= disabled
ping -n 1 127.0.0.1 > nul
echo %BGREEN%%BLACK%Serviço desligado com sucesso! %RESET%



echo %BBLUE%%BLACK%Configuração concluída com sucesso! %RESET%
pause
goto MENU

rem 4 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rem 4 - Instalação de Drivers
:MENU_DRIVERS
cls
echo %BRED%%BLACK%Identificando versão do Windows...%RESET%
:: Consulta o BuildNumber no Registro do Windows
for /f "tokens=3" %%i in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuildNumber 2^>nul') do set build=%%i
:: Verifica se conseguiu obter o build
if not defined build (
    echo %BRED%%BLACK%Erro ao encontrar a build do sistema %RESET%
    pause
	goto :MENU
)
:: Mostra o build detectado (opcional)
echo %BGREEN%%BLACK%Build detectado:%RESET% %BRED%%BLACK% %build% %RESET%
:: Converte para número (caso esteja com zeros à esquerda)
set /a buildNum=%build%
:: Verifica se é Windows 11 (build 22000 ou superior)
if %buildNum% GEQ 22000 (
    goto MENU_DRIVERS_WIN11
) else (
    goto MENU_DRIVERS_WIN10
)



:MENU_DRIVERS_WIN10
cls
setlocal EnableDelayedExpansion
call :bannerWIN10
echo %BRED%%BLACK%Detectando informações do sistema...%RESET%

    rem Versão do Windows
    for /f "tokens=2 delims==" %%I in ('wmic os get Caption /value') do set VERSAO_WINDOWS=%%I
    rem Arquitetura do Sistema
    for /f "tokens=2 delims==" %%I in ('wmic os get OSArchitecture /value') do set ARQUITETURA_SISTEMA=%%I
    rem Fabricante da Placa-Mãe
    for /f "tokens=2 delims==" %%I in ('wmic baseboard get Manufacturer /value') do set PLACA_MAE_FABRICANTE=%%I
    rem Produto da Placa-Mãe
    for /f "tokens=2 delims==" %%I in ('wmic baseboard get Product /value') do set PLACA_MAE_PRODUTO=%%I
    rem Revisão da Placa-Mãe
    for /f "tokens=2 delims==" %%I in ('wmic baseboard get Version /value') do set PLACA_MAE_REVISAO=%%I
    rem Tipo de sistema (Notebook ou Desktop)
    for /f "tokens=2 delims==" %%I in ('wmic computersystem get PCSystemType /value') do (
        if %%I==2 (set TIPO_PLACAMAE=Notebook) else (set TIPO_PLACAMAE=Desktop)
    )
	rem Placa de Vídeo
    for /f "tokens=2 delims==" %%I in ('wmic path win32_videocontroller get Name /value') do set PLACA_DE_VIDEO=%%I
	
    rem Fabricante do Sistema
    for /f "tokens=2 delims==" %%I in ('wmic computersystem get Manufacturer /value') do set FABRICANTE_SISTEMA=%%I
    rem Modelo do Sistema
    for /f "tokens=2 delims==" %%I in ('wmic computersystem get Model /value') do set MODELO_SISTEMA=%%I
    rem SKU do Sistema
    for /f "tokens=2 delims==" %%I in ('wmic computersystem get ChassisSKUNumber /value') do set SKU_SISTEMA=%%I
	for /f "tokens=2 delims==" %%I in ('wmic computersystem get SystemSKUNumber /value') do set SKU_SISTEMA_2=%%I
	for /f "tokens=2 delims==" %%I in ('wmic computersystem get SystemFamily /value') do set SKU_SISTEMA_3=%%I
	

rem if /i "%PLACA_MAE_FABRICANTE%"=="Dell" (
rem 	echo %BRED%Detectado Dell, baixando Dell SupportAssist...%RESET%
rem     curl -L -o "%USERPROFILE%\Downloads\DellSupportAssistInstaller.exe" "https://downloads.dell.com/serviceability/catalog/SupportAssistinstaller.exe"
rem 	ping -n 10 127.0.0.1 > nul
rem     start /wait "%USERPROFILE%\Downloads\DellSupportAssistInstaller.exe"
rem 	ping -n 30 127.0.0.1 > nul
rem     echo %BRED%Abrindo página de suporte da Dell para detecção de drivers...%RESET%
rem     start "" "https://www.dell.com/support/home/pt-br?app=drivers"
rem 	ping -n 20 127.0.0.1 > nul
rem )


rem Verificação de fabricante
set MARCAS=Dell Acer HP Samsung Lenovo
for %%M in (%MARCAS%) do (
    echo !FABRICANTE_SISTEMA! !MODELO_SISTEMA! !PLACA_MAE_FABRICANTE! !PLACA_MAE_PRODUTO! !SKU_SISTEMA! !SKU_SISTEMA_2! !SKU_SISTEMA_3! | findstr /I "%%M" >nul && (
        call :Configurar_%%M
        goto MENU_DRIVERS1
    )
)

echo %BBLUE%%BLACK%Nenhuma marca reconhecida encontrada. %RESET%
goto MENU_DRIVERS1


:MENU_DRIVERS_WIN11
cls
call :bannerWIN11
echo %BRED%%BLACK%Detectando informações do sistema...%RESET%

    rem Versão do Windows
    for /f "delims=" %%I in ('powershell -Command "(Get-CimInstance -ClassName Win32_OperatingSystem).Caption"') do set VERSAO_WINDOWS=%%I
    rem Arquitetura do Sistema
    for /f "delims=" %%I in ('powershell -Command "(Get-CimInstance -ClassName Win32_OperatingSystem).OSArchitecture"') do set ARQUITETURA_SISTEMA=%%I
    rem Fabricante da Placa-Mãe
    for /f "delims=" %%I in ('powershell -Command "(Get-CimInstance -ClassName Win32_BaseBoard).Manufacturer"') do set PLACA_MAE_FABRICANTE=%%I
    rem Produto da Placa-Mãe
    for /f "delims=" %%I in ('powershell -Command "(Get-CimInstance -ClassName Win32_BaseBoard).Product"') do set PLACA_MAE_PRODUTO=%%I
    rem Revisão da Placa-Mãe
    for /f "delims=" %%I in ('powershell -Command "(Get-CimInstance -ClassName Win32_BaseBoard).Version"') do set PLACA_MAE_REVISAO=%%I
    rem Tipo de sistema (Notebook ou Desktop)
    for /f "delims=" %%I in ('powershell -Command "(Get-CimInstance -ClassName Win32_ComputerSystem).PCSystemType"') do (
        if %%I==2 (set TIPO_PLACAMAE=Notebook) else (set TIPO_PLACAMAE=Desktop)
    )
    rem Nome da Placa de Vídeo
    for /f "delims=" %%I in ('powershell -Command "(Get-CimInstance -ClassName Win32_VideoController).Name"') do set PLACA_DE_VIDEO=%%I
    rem Fabricante do Sistema
    for /f "delims=" %%I in ('powershell -Command "(Get-CimInstance -ClassName Win32_ComputerSystem).Manufacturer"') do set FABRICANTE_SISTEMA=%%I
    rem Modelo do Sistema
    for /f "delims=" %%I in ('powershell -Command "(Get-CimInstance -ClassName Win32_ComputerSystem).Model"') do set MODELO_SISTEMA=%%I
    rem SKU do Sistema (Chassis SKUNumber)
    for /f "delims=" %%I in ('powershell -Command "(Get-CimInstance -ClassName Win32_ComputerSystem).ChassisSKUNumber"') do set SKU_SISTEMA=%%I
    rem SKU do Sistema Alternativo
    for /f "delims=" %%I in ('powershell -Command "(Get-CimInstance -ClassName Win32_ComputerSystem).SystemSKUNumber"') do set SKU_SISTEMA_2=%%I
    rem Família do Sistema
    for /f "delims=" %%I in ('powershell -Command "(Get-CimInstance -ClassName Win32_ComputerSystem).SystemFamily"') do set SKU_SISTEMA_3=%%I


rem if /i "%PLACA_MAE_FABRICANTE%"=="Dell" (
rem 	echo %BRED%Detectado Dell, baixando Dell SupportAssist...%RESET%
rem     curl -L -o "%USERPROFILE%\Downloads\DellSupportAssistInstaller.exe" "https://downloads.dell.com/serviceability/catalog/SupportAssistinstaller.exe"
rem 	ping -n 10 127.0.0.1 > nul
rem     start /wait "%USERPROFILE%\Downloads\DellSupportAssistInstaller.exe"
rem 	ping -n 30 127.0.0.1 > nul
rem     echo %BRED%Abrindo página de suporte da Dell para detecção de drivers...%RESET%
rem     start "" "https://www.dell.com/support/home/pt-br?app=drivers"
rem 	ping -n 20 127.0.0.1 > nul
rem )

set MARCAS=Dell Acer HP Samsung Lenovo
for %%M in (%MARCAS%) do (
    echo !FABRICANTE_SISTEMA! !MODELO_SISTEMA! !PLACA_MAE_FABRICANTE! !PLACA_MAE_PRODUTO! !SKU_SISTEMA! !SKU_SISTEMA_2! !SKU_SISTEMA_3! | findstr /I "%%M" >nul && (
        call :Configurar_%%M
        goto MENU_DRIVERS1
    )
)

echo %BBLUE%%BLACK%Nenhuma marca reconhecida encontrada. %RESET%
goto MENU_DRIVERS1



:Configurar_Dell
setlocal EnableDelayedExpansion
cls
call :bannerDELL
echo %BRED%%BLACK%Baixando Dell SupportAssist... %RESET%
set "DELL_SUPPORT_URL=https://www.dell.com/support/home/pt-br?app=drivers"
set "CHROME_PATH=C:\Program Files\Google\Chrome\Application\chrome.exe"
set "SUPPORTASSIST_INSTALLER=%USERPROFILE%\Downloads\DellSupportAssistInstaller.exe"
curl -L -o "!SUPPORTASSIST_INSTALLER!" "https://downloads.dell.com/serviceability/catalog/SupportAssistInstaller.exe"
ping -n 5 127.0.0.1 > nul
echo %BRED%%BLACK%Instalando Dell SupportAssist... %RESET%
start /wait "" "!SUPPORTASSIST_INSTALLER!"
ping -n 10 127.0.0.1 > nul
%BRED%%BLACK%echo Abrindo página de suporte da Dell para detecção de drivers...%RESET%
start "" "!CHROME_PATH!" --incognito "!DELL_SUPPORT_URL!"
timeout /t 20 > nul
echo %BGREEN%%BLACK%Processo concluído. A página de suporte da Dell foi aberta no Google Chrome. %RESET%
pause
goto :MENU_DRIVERS1

:Configurar_Acer
setlocal EnableDelayedExpansion
cls
call :bannerACER
echo %BRED%%BLACK%Baixando Acer SerialNumberDetectionTool... %RESET%
set "ACER_SUPPORT_URL=https://www.acer.com/br-pt/support/drivers-and-manuals"
set "CHROME_PATH=C:\Program Files\Google\Chrome\Application\chrome.exe"
set "SERIALNUMBER_INSTALLER=%USERPROFILE%\Downloads\SerialNumberDetectionTool.exe"
curl -L -o "!SERIALNUMBER_INSTALLER!" "https://global-download.acer.com/SupportFiles/Files/SNID/APP/SerialNumberDetectionTool.exe"
ping -n 5 127.0.0.1 > nul
echo %BRED%%BLACK%Executando Acer SerialNumberDetectionTool... %RESET%
start /wait "" "!SERIALNUMBER_INSTALLER!"
ping -n 10 127.0.0.1 > nul
echo %BRED%%BLACK%Abrindo página de suporte da Acer para detecção de drivers... %RESET%
start "" "!CHROME_PATH!" --incognito "!ACER_SUPPORT_URL!"
timeout /t 20 > nul
echo %BGREEN%%BLACK%Processo concluído. A página de suporte da Acer foi aberta no Google Chrome. %RESET%
pause
goto :MENU_DRIVERS1

:Configurar_HP
setlocal EnableDelayedExpansion
cls
call :bannerHP
echo %BRED%%BLACK%Baixando HP SupportSolutionsFramework... %RESET%
set "HP_SUPPORT_URL=https://support.hp.com/br-pt/drivers/laptops/detect"
set "CHROME_PATH=C:\Program Files\Google\Chrome\Application\chrome.exe"
set "HPSUPPORT_INSTALLER=%USERPROFILE%\Downloads\HPSupportSolutionsFramework.exe"
curl -L -o "!HPSUPPORT_INSTALLER!" "https://www.dropbox.com/s/lktr9snpics6sxk/HPSupportSolutionsFramework.exe?st=fyooofzj&dl=1"
ping -n 5 127.0.0.1 > nul
echo %BRED%%BLACK%Executando HP SupportSolutionsFramework... %RESET%
start /wait "" "!HPSUPPORT_INSTALLER!"
ping -n 10 127.0.0.1 > nul
echo %BRED%%BLACK%Abrindo página de suporte da HP para detecção de drivers... %RESET%
start "" "!CHROME_PATH!" --incognito "!ACER_SUPPORT_URL!"
timeout /t 20 > nul
echo %BGREEN%%BLACK%Processo concluído. A página de suporte da HP foi aberta no Google Chrome. %RESET%
pause
goto :MENU_DRIVERS1

:Configurar_Samsung
cls
call :bannerSAMSUNG
echo %BRED%%BLACK%Instalando Samsung Update... %RESET%
rem set "STORE_URL=ms-windows-store://pdp/?ProductId=9nq3hdb99vbf"
winget install --id 9NQ3HDB99VBF --accept-source-agreements --accept-package-agreements
ping -n 5 127.0.0.1 > nul
echo %BGREEN%%BLACK%Samsung Update foi instalado. %RESET%
pause
goto :MENU_DRIVERS1

:Configurar_Lenovo
setlocal EnableDelayedExpansion
cls
call :bannerLENOVO
echo %BRED%%BLACK%Baixando LSBSetup... %RESET%
set "LENOVO_SUPPORT_URL=https://pcsupport.lenovo.com/br/pt"
set "CHROME_PATH=C:\Program Files\Google\Chrome\Application\chrome.exe"
set "LENOVO_INSTALLER=%USERPROFILE%\Downloads\LSBSetup.exe"
curl -L -o "!LENOVO_INSTALLER!" "https://download.lenovo.com/lsbv5/LSBSetup.exe"
ping -n 5 127.0.0.1 > nul
echo %BRED%%BLACK%Executando LSBSetup... %RESET%
start /wait "" "!LENOVO_INSTALLER!"
ping -n 10 127.0.0.1 > nul
echo %BRED%%BLACK%Abrindo página de suporte da Lenovo para detecção de drivers... %RESET%
start "" "!CHROME_PATH!" --incognito "!LENOVO_SUPPORT_URL!"
timeout /t 20 > nul
echo %BGREEN%%BLACK%Processo concluído. A página de suporte da Lenovo foi aberta no Google Chrome. %RESET%
pause
goto :MENU_DRIVERS1

:MENU_DRIVERS1
cls
call :banner
echo.
echo.
echo                %WHITE%Versão do Windows: %GREEN%%VERSAO_WINDOWS% %ARQUITETURA_SISTEMA%  %RESET%
echo                %WHITE%Placa-mãe tipo: %GREEN%%TIPO_PLACAMAE% %RESET%    
echo.
echo                %WHITE%Fabricante da placa-mãe: %GREEN%%PLACA_MAE_FABRICANTE%     %RESET%                       
echo                %WHITE%Produto da placa-mãe: %GREEN%%PLACA_MAE_PRODUTO%          %RESET%
echo                %WHITE%Revisão da placa-mãe: %GREEN%%PLACA_MAE_REVISAO% %RESET%
echo                %WHITE%Fabricante do sistema: %GREEN%%FABRICANTE_SISTEMA%  %RESET%
echo                %WHITE%Modelo da placa-mãe: %GREEN%%MODELO_SISTEMA% %RESET%
echo.
echo                %WHITE%SKU do sistema: %GREEN%%SKU_SISTEMA%         %RESET%
echo                %WHITE%SKU do sistema 2: %GREEN%%SKU_SISTEMA_2%         %RESET%
echo                %WHITE%SKU do sistema 3: %GREEN%%SKU_SISTEMA_3%         %RESET%      
echo.
echo                %WHITE%Modelo da placa de vídeo: %GREEN%%PLACA_DE_VIDEO%         %RESET%  
echo.
echo.
echo                ╔════════════════════════════════════════════════════════════════════════════╗
echo                ║                                  Drivers                                   ║                             
echo                ║════════════════════════════════════════════════════════════════════════════║
echo                ║     1 - Drivers Placa-Mãe (FABRICANTE E/OU PRODUTO E REVISÃO)              ║
echo                ║     2 - Drivers Placa-Mãe (FABRICANTE SISTEMA)                             ║
echo                ║     3 - Drivers Placa-Mãe (MODELO DA PLACA-MÃE)                            ║
echo                ║     4 - Drivers Placa-Mãe (SKU 1)                                          ║
echo                ║     5 - Drivers Placa-Mãe (SKU 2)                                          ║
echo                ║     6 - Drivers Placa-Mãe (SKU 3)                                          ║
echo                ║     7 - Drivers Placa De Vídeo                                             ║
echo                ║     8 - Voltar ao Menu Principal                                           ║
echo                ╚════════════════════════════════════════════════════════════════════════════╝

echo.
echo.
set /p "opcao=Escolha uma opção e pressione %GREEN%ENTER%RESET%: "

if "%opcao%"=="1" goto MENU_DRIVERS_PLACAMAE
if "%opcao%"=="2" goto MENU_DRIVERS_FABRICANTESISTEMA
if "%opcao%"=="3" goto :MENU_DRIVERS_MODELOPLACAMAE
if "%opcao%"=="4" goto MENU_DRIVERS_SKU1
if "%opcao%"=="5" goto MENU_DRIVERS_SKU2
if "%opcao%"=="6" goto MENU_DRIVERS_SKU3
if "%opcao%"=="7" goto MENU_DRIVERS_PLACADEVIDEO
if "%opcao%"=="8" goto MENU

:MENU_DRIVERS_PLACAMAE
cls
set "URL=https://www.google.com/search?q=%PLACA_MAE_FABRICANTE%+%PLACA_MAE_PRODUTO%+drivers+download"
set "URL2=https://www.google.com/search?q=%PLACA_MAE_PRODUTO%+%PLACA_MAE_REVISAO%+download+drivers"
rem start "" "https://www.google.com/search?q=%PLACA_MAE_FABRICANTE%+%PLACA_MAE_PRODUTO%+drivers+download" FUNCIONA
rem start "" "C:\Program Files\Google\Chrome\Application\chrome.exe" --incognito "%URL%" FUNCIONA
if "%TIPO_PLACAMAE%"=="Notebook" (
    echo %BRED%Abrindo navegador...%RESET%
    start "" "C:\Program Files\Google\Chrome\Application\chrome.exe" --incognito "%URL%"
) else (
    echo %BRED%Abrindo navegador...%RESET%
    start "" "C:\Program Files\Google\Chrome\Application\chrome.exe" --incognito "%URL2%"
)
goto MENU_DRIVERS

:MENU_DRIVERS_PLACADEVIDEO
cls
set "URL3=https://www.google.com/search?q=%PLACA_DE_VIDEO%+drivers"
echo Abrindo página para download de drivers da placa de vídeo...
rem start "" "https://www.google.com/search?q=%PLACA_DE_VIDEO%+drivers"
start "" "C:\Program Files\Google\Chrome\Application\chrome.exe" --incognito "%URL3%"
pause
goto MENU_DRIVERS

:MENU_DRIVERS_FABRICANTESISTEMA
cls
set "URL4=https://www.google.com/search?q=%FABRICANTE_SISTEMA%+drivers"
rem echo Abrindo página para download de drivers da placa de vídeo...
rem start "" "https://www.google.com/search?q=%PLACA_DE_VIDEO%+drivers"
start "" "C:\Program Files\Google\Chrome\Application\chrome.exe" --incognito "%URL4%"
pause
goto MENU_DRIVERS

:MENU_DRIVERS_MODELOPLACAMAE
cls
set "URL5=https://www.google.com/search?q=%MODELO_SISTEMA%+drivers"
rem echo Abrindo página para download de drivers da placa de vídeo...
rem start "" "https://www.google.com/search?q=%PLACA_DE_VIDEO%+drivers"
start "" "C:\Program Files\Google\Chrome\Application\chrome.exe" --incognito "%URL5%"
pause
goto MENU_DRIVERS

:MENU_DRIVERS_SKU1
cls
set "URL6=https://www.google.com/search?q=%SKU_SISTEMA%+drivers"
rem echo Abrindo página para download de drivers da placa de vídeo...
rem start "" "https://www.google.com/search?q=%PLACA_DE_VIDEO%+drivers"
start "" "C:\Program Files\Google\Chrome\Application\chrome.exe" --incognito "%URL6%"
pause
goto MENU_DRIVERS


:MENU_DRIVERS_SKU2
cls
set "URL7=https://www.google.com/search?q=%SKU_SISTEMA_2%+drivers"
rem echo Abrindo página para download de drivers da placa de vídeo...
rem start "" "https://www.google.com/search?q=%PLACA_DE_VIDEO%+drivers"
start "" "C:\Program Files\Google\Chrome\Application\chrome.exe" --incognito "%URL7%"
pause
goto MENU_DRIVERS

:MENU_DRIVERS_SKU3
cls
set "URL8=https://www.google.com/search?q=%SKU_SISTEMA_3%+drivers"
rem echo Abrindo página para download de drivers da placa de vídeo...
rem start "" "https://www.google.com/search?q=%PLACA_DE_VIDEO%+drivers"
start "" "C:\Program Files\Google\Chrome\Application\chrome.exe" --incognito "%URL8%"
pause
goto MENU_DRIVERS


rem ----------------------------------------------------------------------------------------------------------------------------------------
rem UTILITARIOS
:MENU_UTILITARIOS
cls
call :banner

rem ## COLOCAR NA CONFIG PADRAO ou config personalizada
rem Widgets / 0 - Off / 1 - On
rem reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /t REG_DWORD /d "0" /f
rem 0 - Disable Widgets


rem ## COLOCAR NAS CONFIG PC FRACO
rem # Disable Auto-install subscribed/suggested apps (games like Candy Crush Soda Saga/Minecraft)
rem reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "ContentDeliveryAllowed" /t REG_DWORD /d "0" /f
rem reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "FeatureManagementEnabled" /t REG_DWORD /d "0" /f
rem reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "OemPreInstalledAppsEnabled" /t REG_DWORD /d "0" /f
rem reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEnabled" /t REG_DWORD /d "0" /f
rem reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEverEnabled" /t REG_DWORD /d "0" /f
rem reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d "0" /f
rem reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d "0" /f
rem reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContentEnabled" /t REG_DWORD /d "0" /f
rem reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d "0" /f
rem reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338388Enabled" /t REG_DWORD /d "0" /f
rem reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d "0" /f
rem reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338393Enabled" /t REG_DWORD /d "0" /f
rem reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353694Enabled" /t REG_DWORD /d "0" /f
rem reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353696Enabled" /t REG_DWORD /d "0" /f
rem reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContentEnabled" /t REG_DWORD /d "0" /f
rem reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d "0" /f
rem reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v "DODownloadMode" /t REG_DWORD /d "0" /f
rem reg add "HKLM\Software\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d "0" /f
rem reg add "HKLM\Software\Policies\Microsoft\PushToInstall" /v "DisablePushToInstall" /t REG_DWORD /d "1" /f
rem reg add "HKLM\Software\Policies\Microsoft\MRT" /v "DontOfferThroughWUAU" /t REG_DWORD /d "1" /f
rem reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\Subscriptions" /f
rem reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SuggestedApps" /f
rem reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-314559Enabled" /t REG_DWORD /d "0" /f
rem reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-280815Enabled" /t REG_DWORD /d "0" /f
rem reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-314563Enabled" /t REG_DWORD /d "0" /f
rem reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-202914Enabled" /t REG_DWORD /d "0" /f
rem reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353698Enabled" /t REG_DWORD /d "0" /f
rem ## COLOCAR NA CONFIG PADRAO


echo                ╔════════════════════════════════════════════════════════════════════════════╗
echo                ║                              Utilitarios                                   ║
echo                ║════════════════════════════════════════════════════════════════════════════║
echo                ║     1 - Acessar servidor                                                   ║
echo                ║     2 - AIDA64 Portable                                                    ║
echo                ║     3 - HWMonitor                                                          ║
echo                ║     4 - CPU-Z                                                              ║
echo                ║     5 - Speecy                                                             ║
echo                ║     6 - Correção Windows corrompido                                        ║
echo                ║     7 - CrystalDiskInfo                                                    ║
echo                ║     8 - Reparar o MBR                                                      ║
echo                ║     9 - Salvar configurações da rede                                       ║
echo                ║     10 - FurMark                                                           ║
echo                ║     11 - UnrealEngine                                                      ║
echo                ║     12 - Windows Defender bloqueado                                        ║
echo                ║     13 - Reiniciar Spooler de impressão                                    ║
echo                ║     14 - Reparar Windows Update                                            ║
echo                ║     15 - Desativar hibernação                                              ║
echo                ║     16 - Instalar Visual C++ Drivers                                       ║
echo                ║     17 - Resetar configurações de rede                                     ║
echo                ║     18 - Verificar chave do Windows na BIOS                                ║
echo                ║     19 - Ativar Touchpad                                                   ║
echo                ║     20 - Ativar Bluetooth                                                  ║
echo                ║     21 - Desativar Bitlocker                                               ║
echo                ║     22 -                                                                   ║
echo                ║     23 -                                                                   ║
echo                ║     24 -                                                                   ║
echo                ║     25 -                                                                   ║
echo                ║     26 -                                                                   ║
echo                ║     27 -                                                                   ║
echo                ║     28 -                                                                   ║
echo                ║     29 -                                                                   ║
echo                ║     30 -                                                                   ║
echo                ║     31 -                                                                   ║
echo                ║     32 - Voltar ao menu anterior                                           ║
echo                ╚════════════════════════════════════════════════════════════════════════════╝
echo.
echo.
set /p "opcao=Escolha uma opção e pressione %GREEN%ENTER%RESET%: "

if "%opcao%"=="1" goto MENU_UTILITARIOS_1
if "%opcao%"=="2" goto MENU_UTILITARIOS_2
if "%opcao%"=="3" goto MENU_UTILITARIOS_3
if "%opcao%"=="4" goto MENU_UTILITARIOS_4
if "%opcao%"=="5" goto MENU_UTILITARIOS_5
if "%opcao%"=="6" goto MENU_UTILITARIOS_6
if "%opcao%"=="7" goto MENU_UTILITARIOS_7
if "%opcao%"=="8" goto MENU_UTILITARIOS_8
if "%opcao%"=="9" goto MENU_UTILITARIOS_9
if "%opcao%"=="10" goto MENU_UTILITARIOS_10
if "%opcao%"=="11" goto MENU_UTILITARIOS_11
if "%opcao%"=="12" goto MENU_UTILITARIOS_12
if "%opcao%"=="13" goto MENU_UTILITARIOS_13
if "%opcao%"=="14" goto MENU_UTILITARIOS_14
if "%opcao%"=="15" goto MENU_UTILITARIOS_15
if "%opcao%"=="16" goto MENU_UTILITARIOS_16
if "%opcao%"=="17" goto MENU_UTILITARIOS_17
if "%opcao%"=="18" goto MENU_UTILITARIOS_18
if "%opcao%"=="19" goto MENU_UTILITARIOS_19
if "%opcao%"=="20" goto MENU_UTILITARIOS_20
if "%opcao%"=="21" goto MENU_UTILITARIOS_21
if "%opcao%"=="22" goto MENU_UTILITARIOS_22
if "%opcao%"=="23" goto MENU_UTILITARIOS_23
if "%opcao%"=="24" goto MENU_UTILITARIOS_24
if "%opcao%"=="25" goto MENU_UTILITARIOS_25
if "%opcao%"=="26" goto MENU_UTILITARIOS_26
if "%opcao%"=="27" goto MENU_UTILITARIOS_27
if "%opcao%"=="28" goto MENU_UTILITARIOS_28
if "%opcao%"=="29" goto MENU_UTILITARIOS_29
if "%opcao%"=="30" goto MENU_UTILITARIOS_30
if "%opcao%"=="31" goto MENU_UTILITARIOS_31
if "%opcao%"=="32" goto MENU

:MENU_UTILITARIOS_1

pause
goto MENU

:MENU_UTILITARIOS_2

pause
goto MENU

:MENU_UTILITARIOS_3

pause
goto MENU

:MENU_UTILITARIOS_4

pause
goto MENU

:MENU_UTILITARIOS_5

pause
goto MENU

:MENU_UTILITARIOS_6

pause
goto MENU

:MENU_UTILITARIOS_7

pause
goto MENU

:MENU_UTILITARIOS_8

rem ## ARRUMAR O MBR##
rem bootrec /fixmbr
rem bootrec /fixboot
rem bootrec /rebuildbcd

pause
goto MENU

:MENU_UTILITARIOS_9

rem ## salvar config rede ##
rem ipconfig /all > c:\destino 

rem salvar as config
rem netsh interface ip dump > C:\caminho\para\salvar\configuracoes_rede.txt
rem voltar as config
rem netsh exec C:\caminho\para\salvar\configuracoes_rede.txt


pause
goto MENU

:MENU_UTILITARIOS_10

pause
goto MENU

:MENU_UTILITARIOS_11

pause
goto MENU

:MENU_UTILITARIOS_12

pause
goto MENU

:MENU_UTILITARIOS_13

pause
goto MENU

:MENU_UTILITARIOS_14

rem ## reparar windows update ##
REM Fix Windows Update errors and bugs
REM Deletes Windows Update cache
rem del "%ALLUSERSPROFILE%\Application Data\Microsoft\Network\Downloader\qmgr*.dat"
rem rmdir %systemroot%\SoftwareDistribution /S /Q
rem rmdir %systemroot%\system32\catroot2 /S /Q
rem ren c:\windows\winsxs\pending.xml pending.old
rem bitsadmin.exe /reset /allusers

pause
goto MENU

:MENU_UTILITARIOS_15


rem reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabled" /t REG_DWORD /d "0" /f
rem reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabledDefault" /t REG_DWORD /d "0" /f

pause
goto MENU

:MENU_UTILITARIOS_16

rem winget install --id=Microsoft.VCRedist.2005.x86 -e
rem winget install --id=Microsoft.VCRedist.2005.x64 -e
rem winget install --id=Microsoft.VCRedist.2008.x86 -e
rem winget install --id=Microsoft.VCRedist.2008.x64 -e
rem winget install --id=Microsoft.VCRedist.2010.x86 -e
rem winget install --id=Microsoft.VCRedist.2010.x64 -e
rem winget install --id=Microsoft.VCRedist.2012.x86 -e
rem winget install --id=Microsoft.VCRedist.2012.x64 -e
rem winget install --id=Microsoft.VCRedist.2013.x86 -e
rem winget install --id=Microsoft.VCRedist.2013.x64 -e
rem winget install --id=Microsoft.VCRedist.2015+.x86 -e
rem winget install --id=Microsoft.VCRedist.2015+.x64 -e
rem winget install --id=Microsoft.VCRedist.2017.x86 -e
rem winget install --id=Microsoft.VCRedist.2017.x64 -e
rem winget install --id=Microsoft.VCRedist.2019.x86 -e
rem winget install --id=Microsoft.VCRedist.2019.x64 -e
rem winget install --id=Microsoft.VCRedist.2022.x86 -e
rem winget install --id=Microsoft.VCRedist.2022.x64 -e

pause
goto MENU

:MENU_UTILITARIOS_17

rem ipconfig /release
rem ipconfig /flushdns
rem ipconfig /renew
rem netsh int ip reset
rem netsh winsock reset

pause
goto MENU

:MENU_UTILITARIOS_18

wmic path softwareLicensingService get OA3xOriginalProductKey

pause
goto MENU

:MENU_UTILITARIOS_19

rem # Enable TouchPad
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad\Status" /v "Enabled" /t REG_DWORD /d "1" /f


pause
goto MENU

:MENU_UTILITARIOS_20

rem Enable Bluetooth

rem reg add "HKLM\SYSTEM\CurrentControlSet\Services\bthserv" /v "Start" /t REG_DWORD /d "2" /f
rem net start bthserv
rem reg add "HKLM\SYSTEM\CurrentControlSet\Services\CDPUserSvc" /v "Start" /t REG_DWORD /d "2" /f
rem net start CDPUserSvc
rem reg add "HKLM\SYSTEM\CurrentControlSet\Services\CDPSvc" /v "Start" /t REG_DWORD /d "2" /f
rem net start CDPSvc
rem reg add "HKLM\SYSTEM\CurrentControlSet\Services\BthAvctpSvc" /v "Start" /t REG_DWORD /d "2" /f
rem net start BthAvctpSvc
rem reg add "HKLM\SYSTEM\CurrentControlSet\Services\DevicesFlowUserSvc" /v "Start" /t REG_DWORD /d "2" /f
rem net start DevicesFlowUserSvc
rem reg add "HKLM\SYSTEM\CurrentControlSet\Services\ClipSVC" /v "Start" /t REG_DWORD /d "2" /f
rem net start ClipSVC
rem reg add "HKLM\SYSTEM\CurrentControlSet\Services\BTHPORT" /v "Start" /t REG_DWORD /d "2" /f
rem net start BTHPORT
rem reg add "HKLM\SYSTEM\CurrentControlSet\Services\BTHUSB" /v "Start" /t REG_DWORD /d "2" /f
rem net start BTHUSB
rem reg add "HKLM\SYSTEM\CurrentControlSet\Services\BluetoothUserService" /v "Start" /t REG_DWORD /d "2" /f
rem net start BluetoothUserService
rem reg add "HKLM\SYSTEM\CurrentControlSet\Services\BTAGService" /v "Start" /t REG_DWORD /d "2" /f
rem net start BTAGService
rem reg add "HKLM\SYSTEM\CurrentControlSet\Services\BthA2dp" /v "Start" /t REG_DWORD /d "2" /f
rem net start BthA2dp
rem reg add "HKLM\SYSTEM\CurrentControlSet\Services\BthEnum" /v "Start" /t REG_DWORD /d "2" /f
rem net start BthEnum
rem reg add "HKLM\SYSTEM\CurrentControlSet\Services\BthHFEnum" /v "Start" /t REG_DWORD /d "2" /f
rem net start BthHFEnum
rem reg add "HKLM\SYSTEM\CurrentControlSet\Services\BthLEEnum" /v "Start" /t REG_DWORD /d "2" /f
rem net start BthLEEnum
rem reg add "HKLM\SYSTEM\CurrentControlSet\Services\BthMini" /v "Start" /t REG_DWORD /d "2" /f
rem net start BthMini
rem reg add "HKLM\SYSTEM\CurrentControlSet\Services\BTHMODEM" /v "Start" /t REG_DWORD /d "2" /f
rem net start BTHMODEM

pause
goto MENU

:MENU_UTILITARIOS_21

rem manage-bde -off C:
rem powershell.exe Disable-BitLocker -MountPoint "C:"

rem 1 - Disable Bitlocker and Encrypting File System (EFS)
rem reg add "HKLM\System\CurrentControlSet\Control\BitLocker" /v "PreventDeviceEncryption" /t REG_DWORD /d "1" /f
rem fsutil behavior set disableencryption 1

pause
goto MENU

:MENU_UTILITARIOS_21

pause
goto MENU

:MENU_UTILITARIOS_22

pause
goto MENU

:MENU_UTILITARIOS_23

pause
goto MENU

:MENU_UTILITARIOS_24

pause
goto MENU

:MENU_UTILITARIOS_25

pause
goto MENU

:MENU_UTILITARIOS_26

pause
goto MENU

:MENU_UTILITARIOS_27

pause
goto MENU

:MENU_UTILITARIOS_28

pause
goto MENU

:MENU_UTILITARIOS_29

pause
goto MENU

:MENU_UTILITARIOS_30

pause
goto MENU

:MENU_UTILITARIOS_31

pause
goto MENU

rem ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rem banner ANSI Shadow name
:banner
echo.
echo.
echo 			[38;2;0;255;0m███╗   ██╗ ██████╗  ██████╗  █████╗ ████████╗███████╗ ██████╗ %RESET%
echo 			[38;2;128;255;128m████╗  ██║██╔═══██╗██╔════╝ ██╔══██╗╚══██╔══╝██╔════╝██╔════╝ %RESET%
echo 			[38;2;192;255;192m██╔██╗ ██║██║   ██║██║  ███╗███████║   ██║   █████╗  ██║ %RESET%    
echo 			[38;2;224;255;224m██║╚██╗██║██║   ██║██║   ██║██╔══██║   ██║   ██╔══╝  ██║     %RESET%
echo 			[38;2;240;240;240m██║ ╚████║╚██████╔╝╚██████╔╝██║  ██║   ██║   ███████╗╚██████╗ %RESET%
echo 			[38;2;255;255;255m╚═╝  ╚═══╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝ ╚═════╝ %RESET%
echo.                                                             
echo.
echo.
exit /b


:bannerDELL
echo.
echo.
echo 					[38;2;127;255;255m ██████╗ ███████╗██╗     ██╗     
echo 					[38;2;150;255;255m ██╔══██╗██╔════╝██║     ██║     
echo 					[38;2;180;255;255m ██║  ██║█████╗  ██║     ██║     
echo 					[38;2;200;255;255m ██║  ██║██╔══╝  ██║     ██║     
echo 					[38;2;224;255;255m ██████╔╝███████╗███████╗███████╗
echo 					[38;2;224;255;255m ╚═════╝ ╚══════╝╚══════╝╚══════╝
echo.
echo.
echo.
exit /b

:bannerLENOVO
echo.
echo.
echo 			[38;2;255;0;0m██╗     ███████╗███╗   ██╗ ██████╗ ██╗   ██╗ ██████╗ 
echo 			[38;2;255;100;100m██║     ██╔════╝████╗  ██║██╔═══██╗██║   ██║██╔═══██╗
echo 			[38;2;255;150;150m██║     █████╗  ██╔██╗ ██║██║   ██║██║   ██║██║   ██║
echo 			[38;2;255;190;190m██║     ██╔══╝  ██║╚██╗██║██║   ██║╚██╗ ██╔╝██║   ██║
echo 			[38;2;255;220;220m███████╗███████╗██║ ╚████║╚██████╔╝ ╚████╔╝ ╚██████╔╝
echo 			[38;2;255;255;255m╚══════╝╚══════╝╚═╝  ╚═══╝ ╚═════╝   ╚═══╝   ╚═════╝ 
echo.
echo.
echo.
exit /b

:bannerACER
echo.
echo.
echo  			[38;2;77;128;77m█████╗  ██████╗███████╗██████╗ 
echo  			[38;2;77;140;80m██╔══██╗██╔════╝██╔════╝██╔══██╗
echo  			[38;2;77;150;85m███████║██║     █████╗  ██████╔╝
echo  			[38;2;77;160;90m██╔══██║██║     ██╔══╝  ██╔══██╗
echo  			[38;2;77;170;100m██║  ██║╚██████╗███████╗██║  ██║
echo  			[38;2;77;180;105m╚═╝  ╚═╝ ╚═════╝╚══════╝╚═╝  ╚═╝
echo.
echo.
echo.
exit /b


:bannerSAMSUNG
echo.
echo.
echo 			[38;2;0;97;255m███████╗ █████╗ ███╗   ███╗███████╗██╗   ██╗███╗   ██╗ ██████╗ 
echo 			[38;2;128;160;255m██╔════╝██╔══██╗████╗ ████║██╔════╝██║   ██║████╗  ██║██╔════╝ 
echo 			[38;2;165;190;255m███████╗███████║██╔████╔██║███████╗██║   ██║██╔██╗ ██║██║  ███╗
echo 			[38;2;191;208;255m╚════██║██╔══██║██║╚██╔╝██║╚════██║██║   ██║██║╚██╗██║██║   ██║
echo 			[38;2;230;249;250m███████║██║  ██║██║ ╚═╝ ██║███████║╚██████╔╝██║ ╚████║╚██████╔╝
echo 			[38;2;255;255;255m╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ 
echo.
echo.
echo.
exit /b

:bannerHP
echo.
echo.
echo 						[38;2;0;97;255m██╗  ██╗██████╗ 
echo 						[38;2;0;97;255m██║  ██║██╔══██╗
echo 						[38;2;0;97;255m███████║██████╔╝
echo 						[38;2;0;97;255m██╔══██║██╔═══╝ 
echo 						[38;2;0;97;255m██║  ██║██║     
echo 						[38;2;0;97;255m╚═╝  ╚═╝╚═╝     
echo.
echo.
echo.
exit /b

:bannerWIN10
echo.
echo.
echo 		  [38;2;0;121;184m██╗    ██╗██╗███╗   ██╗██████╗  ██████╗ ██╗    ██╗███████╗     ██╗ ██████╗ 
echo 		  [38;2;0;121;184m██║    ██║██║████╗  ██║██╔══██╗██╔═══██╗██║    ██║██╔════╝    ███║██╔═████╗
echo 		  [38;2;0;121;184m██║ █╗ ██║██║██╔██╗ ██║██║  ██║██║   ██║██║ █╗ ██║███████╗    ╚██║██║██╔██║
echo 		  [38;2;0;121;184m██║███╗██║██║██║╚██╗██║██║  ██║██║   ██║██║███╗██║╚════██║     ██║████╔╝██║
echo 		  [38;2;0;121;184m╚███╔███╔╝██║██║ ╚████║██████╔╝╚██████╔╝╚███╔███╔╝███████║     ██║╚██████╔╝
echo 		  [38;2;0;121;184m╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝  ╚══╝╚══╝ ╚══════╝     ╚═╝ ╚═════╝ 
echo.
echo.
echo.
exit /b

:bannerWIN11
echo.
echo.
echo 		  [38;2;0;64;128m██╗    ██╗██╗███╗   ██╗██████╗  ██████╗ ██╗    ██╗███████╗     ██╗ ██╗
echo 		  [38;2;0;64;128m██║    ██║██║████╗  ██║██╔══██╗██╔═══██╗██║    ██║██╔════╝    ███║███║
echo 		  [38;2;0;64;128m██║ █╗ ██║██║██╔██╗ ██║██║  ██║██║   ██║██║ █╗ ██║███████╗    ╚██║╚██║
echo 		  [38;2;0;64;128m██║███╗██║██║██║╚██╗██║██║  ██║██║   ██║██║███╗██║╚════██║     ██║ ██║
echo 		  [38;2;0;64;128m╚███╔███╔╝██║██║ ╚████║██████╔╝╚██████╔╝╚███╔███╔╝███████║     ██║ ██║
echo 		  [38;2;0;64;128m╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝  ╚══╝╚══╝ ╚══════╝     ╚═╝ ╚═╝
echo.
echo.
echo.
exit /b

rem -----------------------------------------------------------------------------------------------------------------------------------
rem MENU_INSTALACAO
:Depend
rem start dependencias
set "depPath=%USERPROFILE%\Downloads\Dependencias"
set "link_dropbox1=https://www.dropbox.com/scl/fi/l35xpuz45ogqwgn0i8tnm/Microsoft.UI.Xaml.appx?rlkey=qjwvd72gveqjt7067cijnll7v&st=7vjfal5z&dl=1"
set "link_dropbox2=https://www.dropbox.com/scl/fi/ompaxi9emjwvu7wl0dwql/Microsoft.VCLibs.appx?rlkey=5z8ayj4hmhlk7ytif911r27mt&st=yr8kf9kw&dl=1"
set "link_dropbox3=https://www.dropbox.com/scl/fi/f6fmlpcu3ouooyn28wjkh/Microsoft.DesktopAppInstaller.msixbundle?rlkey=djqpuknwgpwrcodu4w5abfhre&st=avupq1ow&dl=1"
set "dependencia1=%depPath%\Microsoft.UI.Xaml.appx"
set "dependencia2=%depPath%\Microsoft.VCLibs.appx"
set "dependencia3=%depPath%\Microsoft.DesktopAppInstaller.msixbundle"
mkdir "%depPath%"

rem Baixando as dependências
echo %BRED%%BLACK%Baixando as dependências... %RESET%
curl -L -o "%dependencia1%" "%link_dropbox1%"
if %ERRORLEVEL% NEQ 0 (
    echo %BBLUE%%BLACK%Falha ao baixar a dependência 1.%RESET%
    pause
        goto :MENU
)
echo %BGREEN%%BLACK%Dependência 1 baixado com sucesso! %RESET%

echo %BRED%%BLACK%Baixando as dependências... %RESET%
curl -L -o "%dependencia2%" "%link_dropbox2%"
if %ERRORLEVEL% NEQ 0 (
    echo %BBLUE%%BLACK%Falha ao baixar a dependência 2.%RESET%
    pause
        goto :MENU
)
echo %BGREEN%%BLACK%Dependência 2 baixado com sucesso! %RESET%

echo %BRED%%BLACK%Baixando as dependências... %RESET%
curl -L -o "%dependencia3%" "%link_dropbox3%"
if %ERRORLEVEL% NEQ 0 (
    echo %BBLUE%%BLACK%Falha ao baixar a dependência 3.%RESET%
    pause
        goto :MENU
)
echo %BGREEN%%BLACK%Dependência 3 baixado com sucesso! %RESET%


echo %BRED%%BLACK% Instalando dependências...%RESET%
echo %BRED%%BLACK%Instalando Microsoft.UI.Xaml...%RESET%
powershell -Command "Add-AppxPackage -Path '%depPath%\Microsoft.UI.Xaml.appx'"
if errorlevel 1 (
    echo %BBLUE%%BLACK%Erro ao instalar o UI.Xaml.%RESET%
    exit /b 1
)

echo %BRED%%BLACK%Instalando VCLibs...%RESET%
powershell -Command "Add-AppxPackage -Path '%depPath%\Microsoft.VCLibs.appx'"
if errorlevel 1 (
    echo %BBLUE%%BLACK%Erro ao instalar o VCLibs.%RESET%
    exit /b 1
)

echo %BRED%%BLACK%Instalando WINGET...%RESET%
powershell -Command "Add-AppxPackage -Path '%depPath%\Microsoft.DesktopAppInstaller.msixbundle'"
if errorlevel 1 (
    echo %BBLUE%%BLACK%Erro ao instalar o winget.%RESET%
    exit /b 1
)

echo %BGREEN%%BLACK%Instalação das dependências foram concluídas.%RESET%

exit /b

:Depend2
rem # Installs Winget through CLI

powershell -Command "$ProgressPreference = 'SilentlyContinue'"
powershell -Command "Invoke-WebRequest -Uri 'https://aka.ms/getwinget' -OutFile 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'"
powershell -Command "Invoke-WebRequest -Uri 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx' -OutFile 'Microsoft.VCLibs.x64.14.00.Desktop.appx'"
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx' -OutFile 'Microsoft.UI.Xaml.2.8.x64.appx'"
powershell -Command "Add-AppxPackage -Path 'Microsoft.VCLibs.x64.14.00.Desktop.appx'"
powershell -Command "Add-AppxPackage -Path 'Microsoft.UI.Xaml.2.8.x64.appx'"
powershell -Command "Add-AppxPackage -Path 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'"\
exit /b

rem ----------------------------------------------------------------------------------------------------------------------------
rem Função para copiar atalhos
:copiarAtalho
if exist "%~1" (
    copy "%~1" "%DESKTOP%\%~2" >nul 2>&1
    echo %BGREEN%%BLACK% %~2 criado com sucesso! %RESET%
) else (
    echo %BBLUE%%BLACK%Atalho de %~2 não encontrado! %RESET%
)
exit /b

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
echo 				║     5 - Sair                            ║
echo 				╚═════════════════════════════════════════╝
echo.
echo.
choice /c 12345 /n /m "Escolha uma opção: "
set choice=%errorlevel%

if "%choice%"=="1" goto MENU_INSTALACAO
if "%choice%"=="2" goto GPEDIT
if "%choice%"=="3" goto MENU_CONFIG
if "%choice%"=="4" goto MENU_DRIVERS
if "%choice%"=="5" exit
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
echo                ║     %BRED%%BLACK%3 - Design (Básica + Ferramentas de Design)%RESET%                            ║
echo                ║     4 - Teracopy                                                           ║
echo                ║     5 - Ativações                                                          ║
echo                ║     %BRED%%BLACK%6 - Programas Torrents%RESET%                                                 ║
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
if "%install_choice%"=="" goto MENU_INSTALACAO_TORRENTS
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

call :Depend
echo %BRED%%BLACK%Deseja instalar as dependências? (S/N) %RESET%
set /p resposta=
if /I "%resposta%"=="S" (
    rem Coloque aqui os comandos para instalar as dependências
    call :Depend
    rem Exemplo: call instalar_dependencias.bat
) else (
	echo %BRED%%BLACK%As dependências não foram instaladas! %RESET%
)

rem Baixar Aplicativos usando Curl
curl --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo %BRED%%BLACK%O curl não está instalado ou não está no PATH.%RESET%
    echo %BRED%%BLACK%Instalando cURL... %RESET%
    winget install --id=cURL.cURL -e --accept-source-agreements --accept-package-agreements
    if %ERRORLEVEL% NEQ 0 (
        echo %BRED%%BLACK%Falha ao instalar o cURL.%RESET%
        pause
        goto :MENU
    )
    echo %BGREEN%%BLACK%cURL instalado com sucesso! %RESET%
) else (
    echo %BBLUE%%BLACK%cURL já está instalado! %RESET%
)

rem Definir variáveis de pasta e arquivos
set "pasta_instalacao=%USERPROFILE%\Desktop\Nova Pasta"
set "pasta_office=%pasta_instalacao%\Office 2021"
set "pasta_aact=%pasta_instalacao%\AAct_Network_x64"
set "arquivo_rar=%pasta_instalacao%\Arquivos.rar"
set "pasta_windef=%pasta_instalacao%\WinDef.rar"
set "link_dropbox=https://www.dropbox.com/s/srq8d8rpx6ey81o/Arquivos.rar?st=csgcgone&dl=1"

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
    echo %BRED%%BLACK%Falha ao baixar o arquivo Arquivos.rar.%RESET%
    pause
        goto :MENU
)
echo %BGREEN%%BLACK%Arquivo Arquivos.rar baixado com sucesso! %RESET%

ping -n 5 127.0.0.1 > nul
rem Verifica se o WinRAR está instalado
if exist "C:\Program Files\WinRAR\WinRAR.exe" (
    echo %BGREEN%%BLACK%WinRAR já está instalado, prosseguindo...%RESET%
) else (
    echo %BRED%%BLACK%WinRAR não foi encontrado. Iniciando sua instalação...%RESET%
    winget install --id=WinRAR.WinRAR -e --source winget
    if %ERRORLEVEL% NEQ 0 (
        echo %BRED%%BLACK%Falha ao instalar o WinRAR.%RESET%
        pause
        goto :MENU
    )
    echo %BGREEN%%BLACK%WinRAR instalado com sucesso!%RESET%
	
)

echo %BRED%%BLACK%Abrindo painel do Windows Defender, por favor, desativa-lo...%RESET%
start windowsdefender://threat
pause

rem Extraindo Defender Blocker para desativar o Defender
if exist "%pasta_instalacao%\WinDef.rar" (
    echo %BRED%%BLACK%Extraindo WinDef.rar...%RESET%
    md "%pasta_office%" >nul 2>&1
    "C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%pasta_instalacao%\WinDef.rar" "%pasta_windef%\" 
    if %ERRORLEVEL% NEQ 0 (
        echo %BBLUE%%BLACK%Falha ao extrair o arquivo WinDef.rar.%RESET%
        pause
        goto :MENU
    )
    echo %BGREEN%%BLACK%Defender Control extraído com sucesso! %RESET%
	echo %BRED%%BLACK%Abrindo Defender Control...%RESET%
	start %pasta_instalacao%\WinDef\dControl.exe
	echo %BGREEN%%BLACK%Defender Control aberto com sucesso! %RESET%
) else (
    echo %BRED%%BLACK%Arquivo WinDef.rar não encontrado.%RESET%
)

ping -n 5 127.0.0.1 > nul


rem Instalação dos Programas: Firefox, Chrome, K-LiteCodecPack Full, Skype, Winrar, Adobe Acrobat Reader, AnyDesk e Java
echo %BRED%%BLACK%Instalando Programas...%RESET%
ping -n 6 127.0.0.1 > nul
winget install --id=RARLab.WinRAR -e --accept-source-agreements --accept-package-agreements
ping -n 6 127.0.0.1 > nul
winget install --id=Mozilla.Firefox.ESR.pt-BR -e --accept-source-agreements --accept-package-agreements
ping -n 6 127.0.0.1 > nul
winget install --id=Google.Chrome -e --accept-source-agreements --accept-package-agreements
ping -n 6 127.0.0.1 > nul
winget install --id=CodecGuide.K-LiteCodecPack.Full -e --accept-source-agreements --accept-package-agreements 
ping -n 6 127.0.0.1 > nul
winget install --id=Adobe.Acrobat.Reader.64-bit -e --accept-source-agreements --accept-package-agreements  
ping -n 6 127.0.0.1 > nul
winget install --id=AnyDesk.AnyDesk -e --accept-source-agreements --accept-package-agreements  
ping -n 6 127.0.0.1 > nul
winget install --id=Microsoft.Skype -e --accept-source-agreements --accept-package-agreements
ping -n 8 127.0.0.1 > nul 
rem mata o processo do skype pois ao instalar ele ja abre sozinho
taskkill /f /im Skype.exe 
ping -n 6 127.0.0.1 > nul
winget install --id=Oracle.JavaRuntimeEnvironment -e --accept-source-agreements --accept-package-agreements
ping -n 6 127.0.0.1 > nul

rem Extraindo Arquivos.rar para a pasta de instalação
echo %BRED%%BLACK%Extraindo Arquivos.rar...%RESET%
"C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%arquivo_rar%" "%pasta_instalacao%\" 
if %ERRORLEVEL% NEQ 0 (
    echo %BRED%%BLACK%Falha ao extrair o arquivo Arquivos.rar.%RESET%
    pause
        goto :MENU
)
echo %BGREEN%%BLACK%Arquivos RAR extraídos com sucesso! %RESET%

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
        goto :MENU
    )
    echo %BGREEN%%BLACK%Office 2021 extraído com sucesso! %RESET%
) else (
    echo %BRED%%BLACK%Arquivo Office 2021.rar não encontrado.%RESET%
)

ping -n 5 127.0.0.1 > nul

rem Extraindo o AAct_Network_x64.rar para a pasta "AAct_Network_x64"
rem if exist "%pasta_instalacao%\AAct_Network_x64.rar" (
rem    echo %BRED%%BLACK%Extraindo AAct_Network_x64.rar...%RESET%
rem    md "%pasta_aact%" >nul 2>&1
rem    "C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%pasta_instalacao%\AAct_Network_x64.rar" "%pasta_aact%\" 
rem    if %ERRORLEVEL% NEQ 0 (
rem        echo %BRED%%BLACK%Falha ao extrair o arquivo AAct_Network_x64.rar.%RESET%
rem        pause
rem        goto :MENU
rem    )
rem    echo %BGREEN%%BLACK%AAct_Network_x64 extraído com sucesso! %RESET%
rem ) else (
rem    echo %BRED%%BLACK%Arquivo AAct_Network_x64.rar não encontrado.%RESET%
rem )
rem ping -n 10 127.0.0.1 > nul
rem Desativar Anti virus
rem echo %BRED%%BLACK%Pressione qualquer tecla para abrir o menu do Windows Defender%RESET%
rem pause >nul
rem start windowsdefender://threat/
rem echo %BGREEN%%BLACK%Menu aberto com sucesso! %RESET%
rem timeout /t 2 /nobreak

rem Extraindo Arquivos RAR

echo %BRED%%BLACK%Iniciando a instalação do Office... %RESET%
"%USERPROFILE%\Desktop\Nova Pasta\Office 2021\Office 2013-2021 C2R Install v7.3.6\OInstall.exe" /configure "%USERPROFILE%\Desktop\Nova Pasta\Office 2021\Office 2013-2021 C2R Install v7.3.6\files\Configure.xml" /wait
echo %BGREEN%%BLACK%Office instalado! %RESET%
rem fechar office com taskkill
ping -n 10 127.0.0.1 > nul
echo %BRED%%BLACK%Instalando chave do office e fazendo a ativação... %RESET%
powershell -Command "& ([ScriptBlock]::Create((irm https://get.activated.win))) /Ohook /S"
echo %BGREEN%%BLACK%Office ativado com sucesso! %RESET%
ping -n 10 127.0.0.1 > nul

rem Coletando informações se o windows está ativado
for /f %%A in ('powershell -command "(Get-CimInstance -ClassName SoftwareLicensingProduct | Where-Object { $_.Name -like '*Windows*' -and $_.PartialProductKey } | Select-Object -First 1 -ExpandProperty LicenseStatus)"') do (
    set "status=%%A"
)
echo %BRED%%BLACK%Coletando informações do Windows... %RESET%
echo %BRED%%BLACK%Checando se possui licença instalada... %RESET%
if "%status%"=="1" (
	echo %BBLUE%%BLACK%Windows já está ativado! %RESET%
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

ping -n 10 127.0.0.1 > nul
rem echo %BRED%%BLACK%Iniciando a ativação do Windows... %RESET%
rem start "" "%USERPROFILE%\Desktop\Nova Pasta\AAct_Network_x64\AAct_Network_x64.exe" /wingvlk /wait
rem timeout /t 30 /nobreak
rem start "" "%USERPROFILE%\Desktop\Nova Pasta\AAct_Network_x64\AAct_Network_x64.exe" /win=act /wait
rem timeout /t 30 /nobreak
rem echo %BGREEN%%BLACK%Windows ativado com sucesso! %RESET%

echo %BRED%%BLACK%Copiando Wallpaper para a raiz do C:...%RESET%
copy "%pasta_instalacao%\Wallpaper.jpg" C:\ >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo %BRED%%BLACK%Falha ao copiar o Wallpaper.%RESET%
) else (
    echo %BGREEN%%BLACK%Wallpaper copiado com sucesso! %RESET%
)
ping -n 3 127.0.0.1 > nul

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

rem Baixar Aplicativos usando Curl
curl --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo %BRED%%BLACK%O curl não está instalado ou não está no PATH.%RESET%
    echo %BRED%%BLACK%Instalando cURL... %RESET%
    winget install --id=cURL.cURL -e --accept-source-agreements --accept-package-agreements
    if %ERRORLEVEL% NEQ 0 (
        echo %BRED%%BLACK%Falha ao instalar o cURL.%RESET%
        pause
        goto :MENU
    )
    echo %BGREEN%%BLACK%cURL instalado com sucesso! %RESET%
) else (
    echo %BBLUE%%BLACK%cURL já está instalado! %RESET%
)


rem Instalação dos Programas: Firefox, Chrome, K-LiteCodecPack Full, Skype, Winrar, Adobe Acrobat Reader, AnyDesk e Java
echo %BRED%%BLACK%Instalando Programas...%RESET%
ping -n 4 127.0.0.1 > nul
winget install --id=RARLab.WinRAR -e --accept-source-agreements --accept-package-agreements 
ping -n 4 127.0.0.1 > nul
winget install --id=Mozilla.Firefox.ESR.pt-BR -e --accept-source-agreements --accept-package-agreements 
ping -n 2 127.0.0.1 > nul
winget install --id=Google.Chrome -e --accept-source-agreements --accept-package-agreements 
ping -n 2 127.0.0.1 > nul
winget install --id=CodecGuide.K-LiteCodecPack.Full -e --accept-source-agreements --accept-package-agreements
ping -n 2 127.0.0.1 > nul
winget install --id=Adobe.Acrobat.Reader.64-bit -e --accept-source-agreements --accept-package-agreements  
ping -n 2 127.0.0.1 > nul
winget install --id=AnyDesk.AnyDesk -e --accept-source-agreements --accept-package-agreements  
ping -n 2 127.0.0.1 > nul
winget install --id=Microsoft.Skype -e --accept-source-agreements --accept-package-agreements
ping -n 2 127.0.0.1 > nul 
rem mata o processo do skype pois ao instalar ele ja abre sozinho
taskkill /f /im Skype.exe 
ping -n 2 127.0.0.1 > nul
winget install --id=Oracle.JavaRuntimeEnvironment -e --accept-source-agreements --accept-package-agreements
ping -n 2 127.0.0.1 > nul
winget install --id=VideoLAN.VLC -e --accept-source-agreements --accept-package-agreements  
ping -n 2 127.0.0.1 > nul
rem winget install --id=EpicGames.EpicGamesLauncher -e 
rem ping -n 2 127.0.0.1 > nul
winget install --id=Valve.Steam -e --accept-source-agreements --accept-package-agreements 
ping -n 2 127.0.0.1 > nul
winget install --id=Microsoft.DirectX -e --accept-source-agreements --accept-package-agreements
ping -n 2 127.0.0.1 > nul
winget install --id=Microsoft.VCRedist.2005.x64 -e --accept-source-agreements --accept-package-agreements 
ping -n 2 127.0.0.1 > nul
winget install --id=Microsoft.VCRedist.2008.x64 -e --accept-source-agreements --accept-package-agreements
ping -n 2 127.0.0.1 > nul
winget install --id=Microsoft.VCRedist.2010.x64 -e --accept-source-agreements --accept-package-agreements
ping -n 2 127.0.0.1 > nul
winget install --id=Microsoft.VCRedist.2012.x64 -e --accept-source-agreements --accept-package-agreements
ping -n 2 127.0.0.1 > nul
winget install --id=Microsoft.VCRedist.2013.x64 -e --accept-source-agreements --accept-package-agreements
ping -n 2 127.0.0.1 > nul
winget install --id=Microsoft.VCRedist.2015+.x64 -e --accept-source-agreements --accept-package-agreements
ping -n 5 127.0.0.1 > nul

rem Definir variáveis de pasta e arquivos
set "pasta_instalacao=%USERPROFILE%\Desktop\Nova Pasta"
set "pasta_office=%pasta_instalacao%\Office 2021"
set "pasta_aact=%pasta_instalacao%\AAct_Network_x64"
set "arquivo_rar=%pasta_instalacao%\Arquivos.rar"
set "pasta_windef=%pasta_instalacao%\WinDef"
set "link_dropbox=https://www.dropbox.com/s/srq8d8rpx6ey81o/Arquivos.rar?st=csgcgone&dl=1"

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
    echo %BRED%%BLACK%Falha ao baixar o arquivo Arquivos.rar.%RESET%
    pause
        goto :MENU
)
echo %BGREEN%%BLACK%Arquivo Arquivos.rar baixado com sucesso! %RESET%

ping -n 5 127.0.0.1 > nul
rem Verifica se o WinRAR está instalado
if exist "C:\Program Files\WinRAR\WinRAR.exe" (
    echo %BGREEN%%BLACK%WinRAR já está instalado, prosseguindo...%RESET%
) else (
    echo %BRED%%BLACK%WinRAR não foi encontrado. Iniciando sua instalação...%RESET%
    winget install --id=WinRAR.WinRAR -e --source winget
    if %ERRORLEVEL% NEQ 0 (
        echo %BRED%%BLACK%Falha ao instalar o WinRAR.%RESET%
        pause
        goto :MENU
    )
    echo %BGREEN%%BLACK%WinRAR instalado com sucesso!%RESET%
)

ping -n 5 127.0.0.1 > nul

rem Extraindo Arquivos.rar para a pasta de instalação
echo %BRED%%BLACK%Extraindo Arquivos.rar...%RESET%
"C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%arquivo_rar%" "%pasta_instalacao%\" 
if %ERRORLEVEL% NEQ 0 (
    echo %BRED%%BLACK%Falha ao extrair o arquivo Arquivos.rar.%RESET%
    pause
        goto :MENU
)
echo %BGREEN%%BLACK%Arquivos RAR extraídos com sucesso! %RESET%

ping -n 5 127.0.0.1 > nul


rem Extraindo o Office 2021.rar para a pasta "Office 2021"
if exist "%pasta_instalacao%\Office 2021.rar" (
    echo %BRED%%BLACK%Extraindo Office 2021.rar...%RESET%
    md "%pasta_office%" >nul 2>&1
    "C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%pasta_instalacao%\Office 2021.rar" "%pasta_office%\" 
    if %ERRORLEVEL% NEQ 0 (
        echo %BRED%%BLACK%Falha ao extrair o arquivo Office 2021.rar.%RESET%
        pause
        goto :MENU
    )
    echo %BGREEN%%BLACK%Office 2021 extraído com sucesso! %RESET%
) else (
    echo %BRED%%BLACK%Arquivo Office 2021.rar não encontrado.%RESET%
)

ping -n 5 127.0.0.1 > nul

rem Extraindo o AAct_Network_x64.rar para a pasta "AAct_Network_x64"
rem if exist "%pasta_instalacao%\AAct_Network_x64.rar" (
rem    echo %BRED%%BLACK%Extraindo AAct_Network_x64.rar...%RESET%
rem    md "%pasta_aact%" >nul 2>&1
rem    "C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%pasta_instalacao%\AAct_Network_x64.rar" "%pasta_aact%\" 
rem    if %ERRORLEVEL% NEQ 0 (
rem        echo %BRED%%BLACK%Falha ao extrair o arquivo AAct_Network_x64.rar.%RESET%
rem        pause
rem        goto :MENU
rem    )
rem    echo %BGREEN%%BLACK%AAct_Network_x64 extraído com sucesso! %RESET%
rem ) else (
rem    echo %BRED%%BLACK%Arquivo AAct_Network_x64.rar não encontrado.%RESET%
rem )
ping -n 10 127.0.0.1 > nul
rem Desativar Anti virus
rem echo %BRED%%BLACK%Pressione qualquer tecla para abrir o menu do Windows Defender%RESET%
rem pause >nul
rem start windowsdefender://threat/
rem echo %BGREEN%%BLACK%Menu aberto com sucesso! %RESET%
rem timeout /t 2 /nobreak

rem Extraindo Arquivos RAR

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

ping -n 30 127.0.0.1 > nuls
rem echo %BRED%%BLACK%Iniciando a ativação do Windows... %RESET%
rem start "" "%USERPROFILE%\Desktop\Nova Pasta\AAct_Network_x64\AAct_Network_x64.exe" /wingvlk /wait
rem timeout /t 30 /nobreak
rem start "" "%USERPROFILE%\Desktop\Nova Pasta\AAct_Network_x64\AAct_Network_x64.exe" /win=act /wait
rem timeout /t 30 /nobreak
rem echo %BGREEN%%BLACK%Windows ativado com sucesso! %RESET%




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
ping -n 3 127.0.0.1 > nul
echo %BRED%%BLACK%Copiando Wallpaper para a raiz do C:...%RESET%
copy "%pasta_instalacao%\Wallpaper.jpg" C:\ >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo %BRED%%BLACK%Falha ao copiar o Wallpaper.%RESET%
) else (
    echo %BGREEN%%BLACK%Wallpaper copiado com sucesso! %RESET%
)
ping -n 3 127.0.0.1 > nul

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
copy "%USERPROFILE%\Downloads\TeraCopy_Extracted\license" "%AppData%\TeraCopy\license" /Y

ping -n 15 127.0.0.1 > nul
:: Limpeza de arquivos temporários
del "%USERPROFILE%\Downloads\TeraCopy.rar"
rmdir /S /Q "%USERPROFILE%\Downloads\TeraCopy_Extracted"
ping -n 2 127.0.0.1 > nul
echo %BBLUE%%BLACK%TeraCopy instalado e licença copiada com sucesso. %RESET%
pause

goto MENU_INSTALACAO


:MENU_INSTALACAO_TORRENTS
rem exemplo banco de dados: tudo separado por |
rem Adobe Photoshop 2025 Portable [v26.0.0.26]|Keygen|https://youtube.com|BJ-SHARE
rem Adobe Sony Vegas 2022 Portable [v26.0.0.26]|Keygen|https://youtube.com|BJ-SHARE
rem Adobe Premiere pro 2022 Portable [v26.0.0.26]|Keygen|https://youtube.com|BJ-SHARE

cls
setlocal enabledelayedexpansion
:: Caminho para o arquivo de banco de dados
if not exist "%USERPROFILE%\Downloads\Nogatec\banco_dados.txt" (
    echo %BRED%%BLACK%Baixando banco de dados...%RESET%
    md "%USERPROFILE%\Downloads\Nogatec" >nul 2>&1
	ping -n 2 127.0.0.1 > nul
	curl -L -o "%USERPROFILE%\Downloads\Nogatec\banco_dados.txt" "https://www.dropbox.com/scl/fi/cxbzrmiqhdmnn0fcr179n/banco_dados.txt?rlkey=ta3ib4bo77qq9aoetspkpbh3p&st=ifwes8uq&dl=0"
	ping -n 3 127.0.0.1 > nul
    echo %BGREEN%%BLACK%Pasta criada com sucesso! %RESET%
	echo %BGREEN%%BLACK%Banco de dados baixado com sucesso! %RESET%
)
ping -n 5 127.0.0.1 > nul

set "banco_dados=%USERPROFILE%\Downloads\Nogatec\banco_dados.txt"
rem https://download-hr.utorrent.com/track/stable/endpoint/utorrent/os/riserollout?filename=utorrent_installer.exe

:MENU_INSTALACAO_TORRENTS_MENU
set "banco_dados=%USERPROFILE%\Downloads\Nogatec\banco_dados.txt"
cls
call :banner
echo                ╔════════════════════════════════════════════════════════════════════════════╗
echo                ║                                                                            ║
echo                ║     1 - Pesquisar Aplicativo                                               ║
echo                ║                                                                            ║
echo                ║     2 - Voltar ao menu anterior                                            ║
echo                ║                                                                            ║
echo                ╚════════════════════════════════════════════════════════════════════════════╝
set /p "opcao=Escolha uma opcao: "

if "%opcao%"=="1" goto :MENU_INSTALACAO_TORRENTS_PESQUISAR
if "%opcao%"=="2" goto :MENU_INSTALACAO

goto :MENU_INSTALACAO_TORRENTS_MENU

:MENU_INSTALACAO_TORRENTS_PESQUISAR
set "banco_dados=%USERPROFILE%\Downloads\Nogatec\banco_dados.txt"
set /p "nome=Digite o nome do aplicativo: "
:: Pesquisar no banco de dados
set "encontrado=0"
for /f "tokens=1-4 delims=|" %%a in (%banco_dados%) do (
    echo %%a | find /i "%nome%" >nul
    if !errorlevel! == 0 (
        set /a encontrado+=1	
        echo !encontrado!. %%a
        set "app_!encontrado!=%%a"
        set "tipo_!encontrado!=%%b"
        set "link_!encontrado!=%%c"
        set "origem_!encontrado!=%%d"
    )
)

if !encontrado! == 0 (
    echo Nenhum aplicativo encontrado.
    pause
    goto :MENU_INSTALACAO_TORRENTS_MENU
)

set /p "escolha=Escolha um aplicativo pelo numero: "
set "app_selecionado=!app_%escolha%!"
set "tipo_selecionado=!tipo_%escolha%!"
set "link_selecionado=!link_%escolha%!"
set "origem_selecionado=!origem_%escolha%!"

:MENU_INSTALACAO_TORRENTS_MENU2
cls
call :banner
echo.
echo.
echo                 %BWHITE%%BLACK%                                                  %RESET% 
echo                 %BWHITE%%BLACK%   !app_selecionado!                           %RESET%                          
echo                 %BWHITE%%BLACK%                                                  %RESET%                            
echo                 %BWHITE%%BLACK%   Tipo de Ativacao: !tipo_selecionado!                       %RESET%                               
echo                 %BWHITE%%BLACK%   URL de download: !link_selecionado!                        %RESET%                                
echo                 %BWHITE%%BLACK%   Local de Origem: !origem_selecionado!                      %RESET%      
echo                 %BWHITE%%BLACK%                                                  %RESET%                         
echo                ╔════════════════════════════════════════════════════════════════════════════╗
echo                ║     1 - Baixar                                                             ║
echo                ║     2 - Voltar ao Menu                                                     ║
echo                ╚════════════════════════════════════════════════════════════════════════════╝
echo.
echo.
set /p "opcao=Escolha uma opcao: "

if "%opcao%"=="1" goto :MENU_INSTALACAO_TORRENTS_DOWNLOAD
if "%opcao%"=="2" goto :MENU_INSTALACAO_TORRENTS_MENU

goto :opcoes

:MENU_INSTALACAO_TORRENTS_DOWNLOAD
cls
pause
echo Baixando !app_selecionado!...
:: Exemplo de comando para abrir o link no navegador
start "" !link_selecionado!
pause
goto :MENU_INSTALACAO_TORRENTS_MENU




:MENU_INSTALACAO_WINDOWS
rem MENU ATIVAÇÕES
cls
call :banner
echo                ╔════════════════════════════════════════════════════════════════════════════╗
echo                ║                                Ativações                                   ║
echo                ║════════════════════════════════════════════════════════════════════════════║
echo                ║     1 - Office 2021 e Windows (Instalação + Ativações)                     ║
echo                ║     2 - Ativação Office                                                    ║
echo                ║     3 - Ativação Windows                                                   ║
echo                ║     4 - Voltar ao Menu Anterior                                            ║
echo                ╚════════════════════════════════════════════════════════════════════════════╝
echo.
echo.
choice /c 1234 /n /m "Escolha uma opção: "
set install_choice=%errorlevel%

if "%install_choice%"=="1" goto MENU_INSTALACAO_WINDOWS_OFFICE
if "%install_choice%"=="2" goto MENU_INSTALACAO_WINDOWS_OFFICE2
if "%install_choice%"=="3" goto MENU_INSTALACAO_WINDOWS_WINDOWS
if "%install_choice%"=="4" goto MENU_INSTALACAO
goto MENU_INSTALACAO

:MENU_INSTALACAO_WINDOWS_OFFICE
setlocal EnableDelayedExpansion

rem Definir variáveis de pasta e arquivos
set "pasta_instalacao=%USERPROFILE%\Desktop\Nova Pasta"
set "pasta_office=%pasta_instalacao%\Office 2021"
set "pasta_aact=%pasta_instalacao%\AAct_Network_x64"
set "arquivo_rar=%pasta_instalacao%\Arquivos.rar"
set "pasta_windef=%pasta_instalacao%\WinDef.rar"
set "link_dropbox=https://www.dropbox.com/s/srq8d8rpx6ey81o/Arquivos.rar?st=csgcgone&dl=1"

rem Desativar Anti virus
echo %BRED%%BLACK%Pressione qualquer tecla para abrir o menu do Windows Defender%RESET%
pause >nul
start windowsdefender://threat/
echo %BGREEN%%BLACK%Menu aberto com sucesso! %RESET%
pause
ping -2 6 127.0.0.1 > nul

rem Verifica se a pasta de instalação já existe, caso contrário cria
if not exist "%pasta_instalacao%" (
    echo %BRED%%BLACK%Criando pasta da instalação dos programas...%RESET%
    md "%pasta_instalacao%" >nul 2>&1
        echo %BGREEN%%BLACK%Pasta criada com sucesso! %RESET%

)
rem Baixando o arquivo Arquivos.rar
echo %BRED%%BLACK%Baixando o arquivo Arquivos.rar... %RESET%
curl -L -o "%arquivo_rar%" "%link_dropbox%"
if %ERRORLEVEL% NEQ 0 (
    echo %BRED%%BLACK%Falha ao baixar o arquivo Arquivos.rar.%RESET%
    pause
        goto :MENU
)
echo %BGREEN%%BLACK%Arquivo Arquivos.rar baixado com sucesso! %RESET%

ping -n 1 127.0.0.1 > nul

rem Verifica se o WinRAR está instalado
if exist "C:\Program Files\WinRAR\WinRAR.exe" (
    echo %BGREEN%%BLACK%WinRAR já está instalado, prosseguindo...%RESET%
) else (
    echo %BRED%%BLACK%WinRAR não foi encontrado. Iniciando sua instalação...%RESET%
    winget install --id=WinRAR.WinRAR -e --source winget
    if %ERRORLEVEL% NEQ 0 (
        echo %BRED%%BLACK%Falha ao instalar o WinRAR.%RESET%
        pause
        goto :MENU
    )
    echo %BGREEN%%BLACK%WinRAR instalado com sucesso!%RESET%
)

ping -n 1 127.0.0.1 > nul

rem Extraindo Arquivos.rar para a pasta de instalação
echo %BRED%%BLACK%Extraindo Arquivos.rar...%RESET%
"C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%arquivo_rar%" "%pasta_instalacao%\" 
if %ERRORLEVEL% NEQ 0 (
    echo %BRED%%BLACK%Falha ao extrair o arquivo Arquivos.rar.%RESET%
    pause
        goto :MENU
)
echo %BGREEN%%BLACK%Arquivos RAR extraídos com sucesso! %RESET%

ping -n 1 127.0.0.1 > nul

em Extraindo Defender Blocker para desativar o Defender
if exist "%pasta_instalacao%\WinDef.rar" (
    echo %BRED%%BLACK%Extraindo WinDef.rar...%RESET%
    md "%pasta_office%" >nul 2>&1
    "C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%pasta_instalacao%\WinDef.rar" "%pasta_windef%\" 
    if %ERRORLEVEL% NEQ 0 (
        echo %BBLUE%%BLACK%Falha ao extrair o arquivo WinDef.rar.%RESET%
        pause
        goto :MENU
    )
    echo %BGREEN%%BLACK%Defender Control extraído com sucesso! %RESET%
	echo %BRED%%BLACK%Abrindo Defender Control...%RESET%
	start %pasta_instalacao%\WinDef\dControl.exe
	echo %BGREEN%%BLACK%Defender Control aberto com sucesso! %RESET%
) else (
    echo %BRED%%BLACK%Arquivo WinDef.rar não encontrado.%RESET%
)

ping -n 5 127.0.0.1 > nul
rem Extraindo o Office 2021.rar para a pasta "Office 2021"
if exist "%pasta_instalacao%\Office 2021.rar" (
    echo %BRED%%BLACK%Extraindo Office 2021.rar...%RESET%
    md "%pasta_office%" >nul 2>&1
    "C:\Program Files\WinRAR\WinRAR.exe" x -y -o+ "%pasta_instalacao%\Office 2021.rar" "%pasta_office%\" 
    if %ERRORLEVEL% NEQ 0 (
        echo %BRED%%BLACK%Falha ao extrair o arquivo Office 2021.rar.%RESET%
        pause
        goto :MENU
    )
    echo %BGREEN%%BLACK%Office 2021 extraído com sucesso! %RESET%
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
echo %BRED%%BLACK%Pressione qualquer tecla para abrir Defender Control...%RESET%
pause >nul
start %pasta_instalacao%\WinDef\dControl.exe
echo %BGREEN%%BLACK%Defender Control aberto com sucesso! %RESET%
ping -n 2 127.0.0.1 > nul

pause
goto MENU_INSTALACAO_WINDOWS


:MENU_INSTALACAO_WINDOWS_OFFICE2
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
echo                ║     1 - Padrão                                                             ║
echo                ║     x                                                                      ║
echo                ║     x                                                                      ║
echo                ║     2 - Voltar ao menu anterior                                            ║
echo                ╚════════════════════════════════════════════════════════════════════════════╝
echo.
echo.
choice /c 12 /n /m "Escolha uma opção: "
set install_choice=%errorlevel%

if "%install_choice%"=="1" goto MENU_CONFIG_PADRAO
if "%install_choice%"=="2" goto MENU
goto MENU_CONFIG



:MENU_CONFIG_PADRAO

cls
call :banner
:: Detecta se é Windows 11 ou Windows 10
echo %BRED%%BLACK%Identificando versão do Windows...%RESET%
:: Obtém a versão do Windows
for /f "tokens=4 delims=[.] " %%a in ('ver') do set VERSION=%%a
:: Se for Windows 10 (10.0.xxxx), vai para o menu do Windows 10
if "%VERSION%"=="10" goto MENU_CONFIG_PADRAO_WIN10
:: Obtém a compilação do Windows (ex: 22000 ou superior é Windows 11)
for /f "tokens=5 delims=[.] " %%b in ('ver') do set BUILD=%%b
:: Se a compilação for menor que 22000, é Windows 10
if %BUILD% LSS 22000 goto MENU_CONFIG_PADRAO_WIN10
:: Se chegou até aqui, é Windows 11
goto MENU_CONFIG_PADRAO_WIN11

:MENU_CONFIG_PADRAO_WIN10

set "WMP_PATH=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\Windows Media Player.lnk"
set "WMP_LEGACY_PATH=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\Windows Media Player Legacy.lnk"
set "pasta_instalacao=%USERPROFILE%\Desktop\Nova Pasta"
set "arquivo_rar=%pasta_instalacao%\Arquivos.rar"
set "local_wallpaper=C:\Wallpaper.jpg"
set "link_dropbox=https://www.dropbox.com/s/srq8d8rpx6ey81o/Arquivos.rar?st=csgcgone&dl=1"
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

rem start "" "%SystemRoot%\Resources\Themes\aero.theme"
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes" /v CurrentTheme /t REG_SZ /d "%SystemRoot%\Resources\Themes\aero.theme" /f
taskkill /f /im explorer.exe
ping -5 2 127.0.0.1 > nul
start explorer.exe


setlocal enabledelayedexpansion
rem Caminho da Área de Trabalho
set "DESKTOP=%USERPROFILE%\Desktop"

echo %BRED%%BLACK%Apagando ícones na Área de Trabalho... %RESET%
rem Exclui todos os atalhos, exceto o próprio script
for %%F in ("%DESKTOP%\*") do (
    if "%%~nxF" neq "%~nx0" del /f /q "%%F" >nul 2>&1
)
echo %BGREEN%%BLACK%Ícones apagados com sucesso! %RESET%
rem Atualiza área de trabalho
taskkill /f /im explorer.exe >nul 2>&1
ping -n 2 127.0.0.1 >nul
start explorer.exe
rem Removendo Lixeira
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}" /t REG_DWORD /d 1 /f
rem Atualizando a área de trabalho
taskkill /f /im explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 3 127.0.0.1 > nul
start explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 2 127.0.0.1 > nul
rem Adicionando ícones principais (Computador, Rede, Lixeira e Usuário)
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
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
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0 /f
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
endlocal

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
			winget install --id=WinRAR.WinRAR -e --source winget
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
powershell.exe -Command "irm https://raw.githubusercontent.com/GamerGb/nogatectools/refs/heads/main/Powershell.ps1 | iex"

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
ping -n 2 127.0.0.1 > nul
start explorer.exe
ping -n 2 127.0.0.1 > nul


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
rundll32.exe user32.dll,UpdatePerUserSystemParameters
ping -n 1 127.0.0.1 > nul
echo %BRED%%BLACK%Modificando as configurações... %RESET%
powershell.exe -Command "irm https://raw.githubusercontent.com/GamerGb/nogatectools/refs/heads/main/ConfigPEEK.ps1 | iex"
echo %BGREEN%%BLACK%Configurações de desempenho do Windows foram modificadas com sucesso! %RESET%
ping -n 3 127.0.0.1 > nul

rem Game bar
echo %BRED%%BLACK%Configurando Xbox GameBar... %RESET%
powershell.exe -Command "irm https://raw.githubusercontent.com/GamerGb/nogatectools/refs/heads/main/ConfigGAMEBAR.ps1 | iex"
echo %BGREEN%%BLACK%Xbox GameBar configurado com sucesso! %RESET%
ping -n 3 127.0.0.1 > nul

rem Segundo Planod
echo %BRED%%BLACK%Abrindo aplicativos em segundo plano... %RESET%
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

rem Abrindo msconfig
echo %BRED%%BLACK%Abrindo msconfig... %RESET%
powershell.exe -Command "irm https://raw.githubusercontent.com/GamerGb/nogatectools/refs/heads/main/Config%20MSCONFIG.ps1 | iex"
echo %BGREEN%%BLACK%msconfig aberto com sucesso! %RESET%
pause


rem Abrindo Gerenciador de Tarefas
echo %BRED%%BLACK%Abrindo Gerenciador de Tarefas... %RESET%
taskmgr /0 /startup
echo %BGREEN%%BLACK%Gerenciador de Tarefas aberto com sucesso! %RESET%
pause

rem Verificação se as notificações foram desativadas
echo %BRED%%BLACK%Notificações foi configurado com sucesso! %RESET%
start ms-settings:notifications
pause
ping -n 2 127.0.0.1 > nul

rem Aplicativos padrão
echo %BRED%%BLACK%Abrindo aplicativos padrões... %RESET%
start ms-settings:defaultapps
echo %BGREEN%%BLACK%Aplicativos padrões aberto com sucesso! %RESET%
pause

rem Remover apps
rem echo %BRED%%BLACK%Abrindo Adicionar/remover programas... %RESET%
rem start ms-settings:appsfeatures
rem echo %BGREEN%%BLACK%Adicionar/remover programas aberto com sucesso! %RESET%
rem pause


ping -n 5 127.0.0.1 > nul

rem Abrir config intel
if exist "C:\Windows\System32\igfxCPL.cpl" (
    start C:\Windows\System32\igfxCPL.cpl
) 

ping -n 5 127.0.0.1 > nul

	echo %BRED%%BLACK%Abrindo GPEDIT para configurar o Windows Update...%RESET%	
	powershell.exe -Command "irm https://raw.githubusercontent.com/GamerGb/nogatectools/refs/heads/main/gpedit.ps1 | iex"
	echo %BGREEN%%BLACK%GPEDIT aberto com sucesso! %RESET%	
	pause


rem Ativar Windows Defender
echo %BRED%%BLACK%Abrindo Windows Defender... %RESET%
start windowsdefender://threat/
echo %BGREEN%%BLACK%Windows Defender aberto com sucesso! %RESET%
pause

rundll32.exe user32.dll,UpdatePerUserSystemParameters
taskkill /f /im explorer.exe
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
pause

echo %BRED%%BLACK%Testar entradas P2 (Som).. %RESET%
start ms-settings:sound
pause





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
set "link_dropbox=https://www.dropbox.com/s/srq8d8rpx6ey81o/Arquivos.rar?st=csgcgone&dl=1"
set "WORD_PATH=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Word.lnk"
set "EXCEL_PATH=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Excel.lnk"
set "DESKTOP_PATH=%USERPROFILE%\Desktop"

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

rem Icones na Área de Trabalho

rem echo %BRED%%BLACK%Inserindo ícones na área de trabalho...%RESET%
rem reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}" /t REG_DWORD /d 1 /f
rem rundll32.exe user32.dll,UpdatePerUserSystemParameters
rem taskkill /f /im explorer.exe
rem ping -n 3 127.0.0.1 > nul
rem start explorer.exe
rem reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f
rem reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /t REG_DWORD /d 0 /f
rem reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d 0 /f
rem reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0 /f
rem rundll32.exe user32.dll,UpdatePerUserSystemParameters
rem taskkill /f /im explorer.exe
rem ping -n 3 127.0.0.1 > nul
rem start explorer.exe
rem echo %BGREEN%%BLACK%Ícones na área de trabalho inseridos! %RESET%
setlocal enabledelayedexpansion
echo %BRED%%BLACK%Apagando ícones na Área de Trabalho... %RESET%
rem Excluindo TODOS os arquivos e atalhos (incluindo ocultos e do Public Desktop)
attrib -h -s -r "%USERPROFILE%\Desktop\*" /s /d >nul 2>&1
attrib -h -s -r "%PUBLIC%\Desktop\*" /s /d >nul 2>&1
del /s /q "%USERPROFILE%\Desktop\*" >nul 2>&1
del /s /q "%PUBLIC%\Desktop\*" >nul 2>&1
echo %BGREEN%%BLACK%Todos os ícones apagados com sucesso! %RESET%
rem Removendo Lixeira
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}" /t REG_DWORD /d 1 /f
rem Atualizando a área de trabalho
taskkill /f /im explorer.exe
ping -n 3 127.0.0.1 > nul
start explorer.exe
ping -n 2 127.0.0.1 > nul
rem Adicionando ícones principais (Computador, Rede, Lixeira e Usuário)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f
ping -n 2 127.0.0.1 > nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /t REG_DWORD /d 0 /f
ping -n 2 127.0.0.1 > nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d 0 /f
ping -n 2 127.0.0.1 > nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0 /f
ping -n 2 127.0.0.1 > nul
rem Atualizando a área de trabalho novamente
taskkill /f /im explorer.exe
ping -n 3 127.0.0.1 > nul
start explorer.exe
ping -n 2 127.0.0.1 > nul
echo %BRED%%BLACK%Adicionando atalhos... %RESET%
rem Caminho da pasta de atalhos padrão
set SHORTCUTS="%APPDATA%\Microsoft\Windows\Start Menu\Programs"
rem Copiando atalhos para a área de trabalho
copy "%SHORTCUTS%\Microsoft Edge.lnk" "%USERPROFILE%\Desktop\" >nul 2>&1
ping -n 2 127.0.0.1 > nul
copy "%SHORTCUTS%\Mozilla Firefox.lnk" "%USERPROFILE%\Desktop\" >nul 2>&1
ping -n 2 127.0.0.1 > nul
copy "%SHORTCUTS%\Google Chrome.lnk" "%USERPROFILE%\Desktop\" >nul 2>&1
ping -n 2 127.0.0.1 > nul
copy "%SHORTCUTS%\Skype.lnk" "%USERPROFILE%\Desktop\" >nul 2>&1
rem echo %BGREEN%%BLACK%Ícones na área de trabalho inseridos e organizados! %RESET%

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
rem echo %BRED%%BLACK%Abrindo Windows Media Player...%RESET%
rem if exist %WMP_PATH% (
    rem echo %BRED%%BLACK%Iniciando Windows Media Player (Windows 10)...%RESET%
    rem start "" %WMP_PATH% /Task LaunchGettingStarted
rem ) else (
    :: Caso o atalho padrão não exista, tenta iniciar o Windows Media Player Legacy
    rem if exist %WMP_LEGACY_PATH% (
        rem echo %BRED%%BLACK%Iniciando Windows Media Player Legacy (Windows 11)...%RESET%
        rem start "" %WMP_LEGACY_PATH% /Task LaunchGettingStarted
    rem ) else (
        rem echo %BRED%%BLACK%Nenhum Windows Media Player foi encontrado...%RESET%
    rem )
rem )
rem Wallpaper
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
			winget install --id=WinRAR.WinRAR -e --source winget
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

reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "%local_wallpaper%" /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
taskkill /f /im explorer.exe
ping -n 2 127.0.0.1 > nul
start explorer.exe
ping -n 2 127.0.0.1 > nul
echo %BGREEN%%BLACK%Wallpaper definido com sucesso! %RESET%
rem Atalhos Word e Excel
echo %BRED%%BLACK%Criando atalho do Word...%RESET%
if exist "%WORD_PATH%" (
	copy "%WORD_PATH%" "%DESKTOP_PATH%\Word.lnk"
	echo %BGREEN%%BLACK%Atalho do Word criado com sucesso! %RESET%!
) else (
	echo %BBLUE%%BLACK%Word não está instalado, pressione qualquer tecla para prosseguir! %RESET%
	pause
)
echo %BRED%%BLACK%Criando atalho do Excel...%RESET%
if exist "%EXCEL_PATH%" (
	copy "%EXCEL_PATH%" "%DESKTOP_PATH%\Excel.lnk"
	echo %BGREEN%%BLACK%Atalho do Excel criado com sucesso! %RESET%!
) else (
    echo %BBLUE%%BLACK%Excel não está instalado, pressione qualquer tecla para prosseguir! %RESET%
)

ping -n 2 127.0.0.1 > nul
rem Notificações
echo %BRED%%BLACK%Definindo configurações das notificações...%RESET%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 0 /f
taskkill /f /im explorer.exe
ping -n 2 127.0.0.1 > nul
start explorer.exe
ping -n 2 127.0.0.1 > nul
echo %BRED%%BLACK%Notificações foi configurado com sucesso! %RESET%

rem Definir tema padrão
	echo %BRED%%BLACK%Definindo tema do windows...%RESET%
	start "" "C:\Windows\Resources\Themes\aero.theme" & ping -n 3 127.0.0.1 > nul & taskkill /im "systemsettings.exe" /f
	ping -n 3 127.0.0.1 > nul
	echo %BRED%%BLACK%Abrindo GPEDIT para configurar o Windows Update...%RESET%	
	powershell.exe -Command "irm https://raw.githubusercontent.com/GamerGb/nogatectools/refs/heads/main/gpedit.ps1 | iex"
	echo %BGREEN%%BLACK%GPEDIT aberto com sucesso! %RESET%	
	pause


rundll32.exe user32.dll,UpdatePerUserSystemParameters
echo %BGREEN%%BLACK%Tema definido com sucesso! %RESET%
rem padronizando tema


rem WALLPAPER NOVAMENTE PARA EVITAR PROBLEMAS
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "%local_wallpaper%" /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
taskkill /f /im explorer.exe
ping -n 2 127.0.0.1 > nul
start explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
ping -n 3 127.0.0.1 > nul

rem Abrindo msconfig
echo %BRED%%BLACK%Abrindo msconfig... %RESET%
msconfig.exe /services
echo %BGREEN%%BLACK%msconfig aberto com sucesso! %RESET%
pause

rem Abrindo Gerenciador de Tarefas
echo %BRED%%BLACK%Abrindo Gerenciador de Tarefas... %RESET%
taskmgr /0 /startup
echo %BGREEN%%BLACK%Gerenciador de Tarefas aberto com sucesso! %RESET%
pause

rem Ajustar configurações para máximo desempenho no Windows
echo %BRED%%BLACK%Definindo configuracões de desempenho do Windows... %RESET%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f
rundll32.exe user32.dll,UpdatePerUserSystemParameters
echo %BRED%%BLACK%Modificando as configurações... %RESET%
powershell.exe -Command "irm https://raw.githubusercontent.com/GamerGb/nogatectools/refs/heads/main/ConfigPEEK.ps1 | iex"
echo %BGREEN%%BLACK%Configurações de desempenho do Windows foram modificadas com sucesso! %RESET%

ping -n 3 127.0.0.1 > nul

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

rem Game bar
echo %BRED%%BLACK%Configurando Xbox GameBar... %RESET%
powershell.exe -Command "irm https://raw.githubusercontent.com/GamerGb/nogatectools/refs/heads/main/ConfigGAMEBAR.ps1 | iex"
echo %BGREEN%%BLACK%Xbox GameBar configurado com sucesso! %RESET%
pause

rem Segundo Planod
echo %BRED%%BLACK%Abrindo aplicativos em segundo plano... %RESET%
Reg Add HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications /v GlobalUserDisabled /t REG_DWORD /d 1 /f
echo %BGREEN%%BLACK%Aplicativos em segundo plano desativado com sucesso! %RESET%

ping -n 5 127.0.0.1 > nul

rem Abrir config intel
if exist "C:\Windows\System32\igfxCPL.cpl" (
    start C:\Windows\System32\igfxCPL.cpl
) 

ping -n 5 127.0.0.1 > nul

rem Ativar Windows Defender
echo %BRED%%BLACK%Abrindo Windows Defender... %RESET%
start windowsdefender://threat/
echo %BGREEN%%BLACK%Windows Defender aberto com sucesso! %RESET%
pause

rundll32.exe user32.dll,UpdatePerUserSystemParameters
taskkill /f /im explorer.exe
ping -n 2 127.0.0.1 > nul
start explorer.exe
ping -n 2 127.0.0.1 > nul
rem Comandos Powershell para config
powershell.exe -Command "irm https://raw.githubusercontent.com/GamerGb/nogatectools/refs/heads/main/Powershell.ps1 | iex"


echo %BBLUE%%BLACK%Configuração concluída com sucesso! %RESET%
pause
goto MENU

rem 4 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rem 4 - Instalação de Drivers
:MENU_DRIVERS
cls
:: Detecta se é Windows 11 ou Windows 10
echo %BRED%%BLACK%Identificando versão do Windows...%RESET%
for /f "tokens=4 delims=[] " %%a in ('ver') do set v=%%a
set w=%v:10.0.=%

if %v% == %w% goto MENU_DRIVERS_WIN10

set x=.%w:*.=%

setlocal enabledelayedexpansion
set w=!w:%x%=!
if !w! lss 22000 goto MENU_DRIVERS_WIN10
endlocal
goto MENU_DRIVERS_WIN11

:MENU_DRIVERS_WIN10
cls
echo %BGREEN%%BLACK%WINDOWS 10 DETECTADO%RESET%
echo %BRED%%BLACK%Detectando informações do sistema...%RESET%
    for /f "tokens=2 delims==" %%I in ('wmic os get Caption /value') do set VERSAO_WINDOWS=%%I
    for /f "tokens=2 delims==" %%I in ('wmic os get OSArchitecture /value') do set ARQUITETURA_SISTEMA=%%I
    for /f "tokens=2 delims==" %%I in ('wmic baseboard get Manufacturer /value') do set PLACA_MAE_FABRICANTE=%%I
    for /f "tokens=2 delims==" %%I in ('wmic baseboard get Product /value') do set PLACA_MAE_PRODUTO=%%I
    for /f "tokens=2 delims==" %%I in ('wmic baseboard get Version /value') do set PLACA_MAE_REVISAO=%%I
    for /f "tokens=2 delims==" %%I in ('wmic computersystem get PCSystemType /value') do (
        if %%I==2 (set TIPO_PLACAMAE=Notebook) else (set TIPO_PLACAMAE=Desktop)
    )
    for /f "tokens=2 delims==" %%I in ('wmic path win32_videocontroller get Name /value') do set PLACA_DE_VIDEO=%%I
)

if /i "%PLACA_MAE_FABRICANTE%"=="Dell" (
	echo %BRED%Detectado Dell, baixando Dell SupportAssist...%RESET%
    curl -L -o "%USERPROFILE%\Downloads\DellSupportAssistInstaller.exe" "https://downloads.dell.com/serviceability/catalog/SupportAssistinstaller.exe"
	ping -n 10 127.0.0.1 > nul
    start /wait "%USERPROFILE%\Downloads\DellSupportAssistInstaller.exe"
	ping -n 30 127.0.0.1 > nul
    echo %BRED%Abrindo página de suporte da Dell para detecção de drivers...%RESET%
    start "" "https://www.dell.com/support/home/pt-br?app=drivers"
	ping -n 20 127.0.0.1 > nul
)
goto MENU_DRIVERS1

:MENU_DRIVERS_WIN11
cls
echo %BGREEN%%BLACK%WINDOWS 11 DETECTADO%RESET%
echo %BRED%%BLACK%Detectando informações do sistema...%RESET%
    for /f "delims=" %%I in ('powershell -Command "(Get-CimInstance -ClassName Win32_OperatingSystem).Caption"') do set VERSAO_WINDOWS=%%I
    for /f "delims=" %%I in ('powershell -Command "(Get-CimInstance -ClassName Win32_OperatingSystem).OSArchitecture"') do set ARQUITETURA_SISTEMA=%%I
    for /f "delims=" %%I in ('powershell -Command "(Get-CimInstance -ClassName Win32_BaseBoard).Manufacturer"') do set PLACA_MAE_FABRICANTE=%%I
    for /f "delims=" %%I in ('powershell -Command "(Get-CimInstance -ClassName Win32_BaseBoard).Product"') do set PLACA_MAE_PRODUTO=%%I
    for /f "delims=" %%I in ('powershell -Command "(Get-CimInstance -ClassName Win32_BaseBoard).Version"') do set PLACA_MAE_REVISAO=%%I
    for /f "delims=" %%I in ('powershell -Command "(Get-CimInstance -ClassName Win32_ComputerSystem).PCSystemType"') do (
        if %%I==2 (set TIPO_PLACAMAE=Notebook) else (set TIPO_PLACAMAE=Desktop)
    )
    for /f "delims=" %%I in ('powershell -Command "(Get-CimInstance -ClassName Win32_VideoController).Name"') do set PLACA_DE_VIDEO=%%I
)
if /i "%PLACA_MAE_FABRICANTE%"=="Dell" (
	echo %BRED%Detectado Dell, baixando Dell SupportAssist...%RESET%
    curl -L -o "%USERPROFILE%\Downloads\DellSupportAssistInstaller.exe" "https://downloads.dell.com/serviceability/catalog/SupportAssistinstaller.exe"
	ping -n 10 127.0.0.1 > nul
    start /wait "%USERPROFILE%\Downloads\DellSupportAssistInstaller.exe"
	ping -n 30 127.0.0.1 > nul
    echo %BRED%Abrindo página de suporte da Dell para detecção de drivers...%RESET%
    start "" "https://www.dell.com/support/home/pt-br?app=drivers"
	ping -n 20 127.0.0.1 > nul
)
goto MENU_DRIVERS1

:MENU_DRIVERS1
cls
call :banner
echo.
echo.
echo                %WHITE%Versão do Windows: %GREEN%%VERSAO_WINDOWS% %ARQUITETURA_SISTEMA%  %RESET%
echo                %WHITE%Placa-mãe tipo: %GREEN%%TIPO_PLACAMAE% %RESET%
echo                %WHITE%Modelo da placa de vídeo: %GREEN%%PLACA_DE_VIDEO%         %RESET%                        
echo                %WHITE%Fabricante da placa-mãe: %GREEN%%PLACA_MAE_FABRICANTE%     %RESET%                       
echo                %WHITE%Modelo da placa-mãe: %GREEN%%PLACA_MAE_PRODUTO%          %RESET%
echo                %WHITE%Revisão da placa-mãe: %GREEN%%PLACA_MAE_REVISAO% %RESET%
echo.
echo.
echo                ╔════════════════════════════════════════════════════════════════════════════╗
echo                ║                                  Drivers                                   ║                             
echo                ║════════════════════════════════════════════════════════════════════════════║
echo                ║     1 - Drivers Placa-Mãe                                                  ║
echo                ║     2 - Drivers Placa De Vídeo                                             ║
echo                ║     3 - Voltar ao Menu Principal                                           ║
echo                ╚════════════════════════════════════════════════════════════════════════════╝

echo.
echo.
set /p "opcao=Escolha uma opção e pressione %GREEN%ENTER%RESET%: "

if "%opcao%"=="1" goto MENU_DRIVERS_PLACAMAE
if "%opcao%"=="2" goto MENU_DRIVERS_PLACADEVIDEO
if "%opcao%"=="3" goto MENU


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



REM WINDOWS 11 TEMA ESCURO
:MENU_CONFIG_ESCURO11
	echo %BRED%%BLACK%Definindo tema do windows...%RESET%	
	start "" "C:\Windows\Resources\Themes\dark.theme" & ping -n 3 127.0.0.1 > nul & taskkill /im "systemsettings.exe" /f
	ping -n 3 127.0.0.1 > nul
	echo %BRED%%BLACK%Abrindo GPEDIT para configurar o Windows Update...%RESET%	
	powershell.exe -Command "irm https://raw.githubusercontent.com/GamerGb/nogatectools/refs/heads/main/gpedit.ps1 | iex"
	echo %BGREEN%%BLACK%GPEDIT aberto com sucesso! %RESET%	
	pause
	echo %BRED%%BLACK%Definindo configurações de Segundo Plano...%RESET%	
	powershell.exe -Command "irm https://raw.githubusercontent.com/GamerGb/nogatectools/refs/heads/main/gpeditSegundoPlano.ps1 | iex"
	echo %BGREEN%%BLACK%Segundo plano configurado com sucesso! %RESET%	

rem ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rem banner
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

rem ----------------------------------------------------------------------------------------------------------------------------
rem Função para copiar atalhos
:copiarAtalho
if exist "%~1" (
    copy "%~1" "%DESKTOP%\%~2" >nul 2>&1
    echo %BGREEN%%BLACK% %~2 criado com sucesso! %RESET%
) else (
    echo %BBLUE%%BLACK%Atalho de %~2 não encontrado! %RESET%
)

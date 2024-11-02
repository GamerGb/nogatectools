@echo off
rem Codificação UTF-8 
chcp 65001 >nul
mode con: cols=120 lines=45
color F
title Nogatec Tools - Windows 11


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



:MENU
:: Verifica se o sistema é 32 bits ou 64 bits
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
    set "ARQUITETURA_SISTEMA=32 bits"
) else (
    set "ARQUITETURA_SISTEMA=64 bits"
)
:: Obtém a versão do Windows
for /f "skip=1 tokens=*" %%i in ('wmic os get Caption') do (
    if not defined VERSAO_WINDOWS set "VERSAO_WINDOWS=%%i"
)
cls
call :banner
echo %WHITE%Computador:%RESET% %GREEN%%computername%%RESET%        %WHITE%Usuário: %RESET%%GREEN%%username%%RESET%        %WHITE%Windows:%RESET% %GREEN%%VERSAO_WINDOWS%%ARQUITETURA_SISTEMA% %RESET%
echo.
echo.
echo 				╔═════════════════════════════════════════╗
echo 				║        Gerenciador de Instalação        ║
echo 				║═════════════════════════════════════════║
echo 				║     1 - Instalação de Programas         ║
echo 				║     2 - Instalar gpedit.msc             ║
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
call :banner
echo                ╔════════════════════════════════════════════════════════════════════════════╗
echo                ║                          Instalação de Programas                           ║
echo                ║════════════════════════════════════════════════════════════════════════════║
echo                ║     1 - Básica (Aplicativos Essenciais)                                    ║
echo                ║     2 - Jogos (Essenciais + Drivers e Ferramentas para Games)              ║
echo                ║     3 - Design (Essenciais + Ferramentas de Design)                        ║
echo                ║     4 - Voltar ao Menu Principal                                           ║
echo                ╚════════════════════════════════════════════════════════════════════════════╝
echo.
echo.
choice /c 1234 /n /m "Escolha uma opção: "
set install_choice=%errorlevel%

if "%install_choice%"=="1" goto MENU_INSTALACAO_BASICA
if "%install_choice%"=="2" goto MENU_INSTALACAO_GAMER
if "%install_choice%"=="3" goto MENU_INSTALACAO_DESIGN
if "%install_choice%"=="4" goto MENU
goto MENU_INSTALACAO

:MENU_INSTALACAO_BASICA

set "pasta_instalacao=%USERPROFILE%\Desktop\Nova Pasta"
set "pasta_office=%pasta_instalacao%"  :: Ajustando a variável para uso posterior
set "arquivo_rar=%pasta_instalacao%\Arquivos.rar"
set "arquivo_zip=%pasta_instalacao%\RatiborusKMSTools01.12.2021.y.taiwebs.com.zip"
set "senha=taiwebs.com"

rem Baixar Aplicativos usando Curl
curl --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo %BRED%%BLACK%O curl não está instalado ou não está no PATH.%RESET%
    echo %BRED%%BLACK%Instalando cURL... %RESET%
    winget install --id=cURL.cURL -e
    if %ERRORLEVEL% NEQ 0 (
        echo %BRED%%BLACK%Falha ao instalar o cURL.%RESET%
        pause
        exit /b 1
    )
    echo %BGREEN%%BLACK%cURL instalado com sucesso! %RESET%
) else (
    echo %BBLUE%%BLACK%cURL já está instalado! %RESET%
)

rem Verifica se a pasta já existe antes de tentar criar
if not exist "%pasta_instalacao%" (
    echo %BRED%%BLACK%Criando pasta da instalação dos programas...%RESET%
    md "%pasta_instalacao%" >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo %BRED%%BLACK%Falha ao criar a pasta.%RESET%
        pause
        exit /b 1
    ) else (
        echo %BGREEN%%BLACK%Pasta criada com sucesso! %RESET%
    )
) else (
    echo %BBLUE%%BLACK%Pasta já existe. Continuando...%RESET%
)

echo %BRED%%BLACK%Baixando arquivos... %RESET%
curl -L -o "%arquivo_rar%" "https://www.dropbox.com/scl/fi/aa5k1u17ixz9vq5rt3qyw/OFFICE2.rar?rlkey=m95m26thpmxgz16jdtdqu0tda&st=7h9ci77n&dl=0" 
echo %BGREEN%%BLACK%Arquivos baixados com sucesso! %RESET%

rem Desativar Anti virus
echo %BRED%%BLACK%Pressione qualquer tecla para abrir o menu do Windows Defender%RESET%
pause >nul
start windowsdefender://threat/
echo %BGREEN%%BLACK%Menu aberto com sucesso! %RESET%
timeout /t 2 /nobreak

rem Extraindo Arquivos RAR
echo %BRED%%BLACK%Extraindo Arquivos.rar...%RESET%
"C:\Program Files\WinRAR\WinRAR.exe" x "%arquivo_rar%" "%pasta_office%\" 
if %ERRORLEVEL% NEQ 0 (
    echo %BRED%%BLACK%Falha ao extrair o arquivo RAR.%RESET%
    pause
    exit /b 1
)
echo %BGREEN%%BLACK%Arquivos RAR extraídos com sucesso!%RESET%
timeout /t 2 /nobreak

rem Extraindo Ratiborus KMS Tools com senha
echo %BRED%%BLACK%Extraindo Ratiborus KMS Tools...%RESET%
"C:\Program Files\WinRAR\WinRAR.exe" x -p%senha% "%arquivo_zip%" "%pasta_instalacao%\Ratiborus KMS Tools 01.12.2021\" 
if %ERRORLEVEL% NEQ 0 (
    echo %BRED%%BLACK%Falha ao extrair o arquivo ZIP.%RESET%
    pause
    exit /b 1
)
echo %BGREEN%%BLACK%Ratiborus KMS Tools extraídos com sucesso!%RESET%
echo %BRED%%BLACK%Iniciando a instalação dos aplicativos em 10 segundos! %RESET%
timeout /t 12 /nobreak
echo %BRED%Instalando aplicativos...%RESET%
:: Navega pelos arquivos na pasta especificada
setlocal enabledelayedexpansion
set "encontrou=0"
set "pasta_apps=%USERPROFILE%\Desktop\Nova Pasta"
for %%f in ("%pasta_instalacao%\*.exe") do (
    set "encontrou=1"
    echo %BRED%%BLACK%Instalando %%~nxf...%RESET%
    start /wait "Instalando" "%%f" /silent /install
    if "%%~nxf"=="Wallpaper.jpg" (
        powershell -command "Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'Wallpaper' -Value '%pasta_instalacao%\Wallpaper.jpg' -Type String"
        if !ERRORLEVEL! NEQ 0 (
            echo %BRED%%BLACK%Falha ao definir o Wallpaper.%RESET%
        ) else (
            RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
            if !ERRORLEVEL! NEQ 0 (
                echo %BRED%%BLACK%Falha ao atualizar as configurações do Desktop.%RESET%
            ) else (
                echo %BGREEN%%BLACK%Wallpaper definido com sucesso!%RESET%
            )
        )
    )
)

if !encontrou! equ 0 (
    echo %BRED%%BLACK%Nenhum aplicativo encontrado para instalar.%RESET%
)
timeout /t 2 /nobreak
echo %BRED%%BLACK%Copiando Wallpaper para a raiz do C:...%RESET%
copy "%pasta_instalacao%\Wallpaper.jpg" C:\ >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo %BRED%%BLACK%Falha ao copiar o Wallpaper.%RESET%
) else (
    echo %BGREEN%%BLACK%Wallpaper copiado com sucesso! %RESET%
)
timeout /t 2 /nobreak
echo %BRED%%BLACK%Abrindo KMS Tools...%RESET%
start "" "%pasta_instalacao%\Ratiborus KMS Tools 01.12.2021\Ratiborus KMS Tools 01.12.\KMS Tools Unpack.exe"
pause  


goto MENU_INSTALACAO

:MENU_INSTALACAO_GAMER
echo Instalando Ferramentas e Drivers para Jogos...
REM Instalar Visual C++, Drivers, DirectX, OBS, Discord
pause
goto MENU_INSTALACAO

:MENU_INSTALACAO_DESIGN
echo Instalando Ferramentas de Design...
REM Instalar uTorrent, Programas de edição, DirectX, Drivers

:: Exemplo de busca e cópia do arquivo .torrent
:: set SERVER_PATH=\\ip_do_servidor\shared_folder
:: set DEST_PATH=%USERPROFILE%\Downloads\torrents 
:: mkdir "%DEST_PATH%"
:: copy "%SERVER_PATH%\design_software.torrent" "%DEST_PATH%"
:: echo Arquivo .torrent copiado para %DEST_PATH%

pause
goto MENU_INSTALACAO


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
pause
goto MENU

rem 3 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rem 3 - Configurações e Otimizações

:MENU_CONFIG
cls
call :banner
echo                ╔════════════════════════════════════════════════════════════════════════════╗
echo                ║                          Em Desenvolvimento                                ║
echo                ║════════════════════════════════════════════════════════════════════════════║
echo                ║     x                                                                      ║
echo                ║     x                                                                      ║
echo                ║     x                                                                      ║
echo                ║     x                                                                      ║
echo                ╚════════════════════════════════════════════════════════════════════════════╝
echo.
echo.
pause
goto :MENU











rem 4 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rem 4 - Instalação de Drivers
:MENU_DRIVERS
cls
:: Obtém o nome da placa de vídeo
setlocal
for /f "skip=1 tokens=*" %%i in ('wmic path win32_VideoController get Name') do (
    if not defined PLACA_DE_VIDEO set "PLACA_DE_VIDEO=%%i"
)

:: Obtém o fabricante da placa-mãe
for /f "skip=1 tokens=*" %%i in ('wmic baseboard get Manufacturer') do (
    if not defined PLACA_MAE_FABRICANTE set "PLACA_MAE_FABRICANTE=%%i"
)

:: Obtém o modelo da placa-mãe
for /f "skip=1 tokens=*" %%i in ('wmic baseboard get Product') do (
    if not defined PLACA_MAE_PRODUTO set "PLACA_MAE_PRODUTO=%%i"
)
for /f "skip=1 tokens=*" %%i in ('wmic baseboard get Version') do (
    if not defined PLACA_MAE_REVISAO set "PLACA_MAE_REVISAO=%%i"
)
rem Obtém o tipo de sistema PC
for /f "tokens=2 delims==" %%a in ('wmic computersystem get PCSystemType /value') do set "pcSystemType=%%a"

rem Verifica se o sistema é um notebook ou desktop
if "%pcSystemType%"=="2" (
    set "TIPO_PLACAMAE=NOTEBOOK"
) else (
	    set "TIPO_PLACAMAE=DESKTOP"
)
:: Verifica se o sistema é 32 bits ou 64 bits
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
    set "ARQUITETURA_SISTEMA=32 bits"
) else (
    set "ARQUITETURA_SISTEMA=64 bits"
)
:: Obtém a versão do Windows
for /f "skip=1 tokens=*" %%i in ('wmic os get Caption') do (
    if not defined VERSAO_WINDOWS set "VERSAO_WINDOWS=%%i"
)
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
if "%pcSystemType%"=="2" (
	echo %BRED%Abrindo navegador...%RESET%
	start "" "https://www.google.com/search?q=%PLACA_MAE_FABRICANTE%+%PLACA_MAE_PRODUTO%+drivers+download"
) else (
	echo %BRED%Abrindo navegador...%RESET%
	start "" "https://www.google.com/search?q=%PLACA_MAE_PRODUTO%+%PLACA_MAE_REVISAO%+download+drivers"	
)
pause
goto MENU_DRIVERS

:MENU_DRIVERS_PLACADEVIDEO
	echo %BRED%Abrindo navegador...%RESET%
	start "" "https://www.google.com/search?q=%PLACA_DE_VIDEO%+download+drivers"	
	echo %BGREEN%%BLACK%Navegador aberto com sucesso! %RESET%
	pause
goto MENU_DRIVERS







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
Set-ExecutionPolicy Bypass -Scope Process -Force;
Function DebloatMS {
    $Bloatware = @(
        #Unnecessary Windows 10 AppX Apps
        "Microsoft.Teams"
        "Microsoft.3DBulder"
        "Microsoft.AppConnector"
        "Microsoft.BingFinance"
        "Microsoft.BingNews"
        "Microsoft.BingSports"
        "Microsoft.BingTranslator"
        "Microsoft.BingWeather"
        "Microsoft.GetHelp"
        "Microsoft.Getstarted"
        "Microsoft.Messaging"
        "Microsoft.Microsoft3DViewer"
        "Microsoft.MicrosoftOfficeHub"
        "Microsoft.MicrosoftSolitaireCollection"
        "Microsoft.NetworkSpeedTest"
        "Microsoft.News"
        "Microsoft.Office.Lens"
        "Microsoft.Office.OneNote"
        "Microsoft.Office.Sway"
        "Microsoft.Office.Todo.List"
        "Microsoft.OneConnect"
        "Microsoft.People"
        "Microsoft.PPIProjection"
        "Microsoft.SkypeApp"
        "Microsoft.Todos"
        "Microsoft.Wallet"
        "Microsoft.Whiteboard"
        "Microsoft.WindowsAlarms"
        "Microsoft.WindowsFeedbackHub"
        "Microsoft.WindowsMaps"
        "Microsoft.ZuneMusic"
        "Microsoft.ZuneVideo"
        "*Microsoft.BingWeather*"
	"Microsoft.OutlookNew"
        "Microsoft.WindowsCopilot"       
        "Microsoft.WindowsCommentsHub"   
        "Microsoft.People"
    )
    Write-Host "Removendo Apps Microsoft Store..."
    foreach ($Bloat in $Bloatware) {
        Get-AppxPackage -Name $Bloat| Remove-AppxPackage
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Bloat | Remove-AppxProvisionedPackage -Online
        Get-AppxPackage -AllUsers -Name $Bloat| Remove-AppxPackage
        Write-Host "Removendo: $Bloat."
    }
    if (Test-Path ~\AppData\Local\Microsoft\WindowsApps\winget.exe){
        Write-Output "Desinstalando MSTeams..."
        winget uninstall "Microsoft.Teams"
        winget uninstall "Microsoft Teams"
    }
}

Function DebloatThirdParty {
    $Bloatware = @(
        #Sponsored Windows 10 AppX Apps
        #Add sponsored/featured apps to remove in the "*AppName*" format
        "*EclipseManager*"
        "*ActiproSoftwareLLC*"
        "*AdobeSystemsIncorporated.AdobePhotoshopExpress*"
        "*Duolingo-LearnLanguagesforFree*"
        "*PandoraMediaInc*"
        "*CandyCrush*"
        "*BubbleWitch3Saga*"
        "*Wunderlist*"
        "*Flipboard*"
        "*Twitter*"
        "*Pinterest*"
        "*Facebook*"
        "*Minecraft*"
        "*Royal Revolt*"
        "*Sway*"
        "*Roblox*"
        "*Speed Test*"
        "*Dolby*"
        "*Viber*"
        "*ACGMediaPlayer*"
        "*Netflix*"
        "*OneCalendar*"
        "*LinkedInforWindows*"
        "*HiddenCityMysteryofShadows*"
        "*Hulu*"
        "*HiddenCity*"
        "*AdobePhotoshopExpress*"
        "*Disney*"
        "Clipchamp.Clipchamp*"
    )
    Write-Host "Removendo Apps de Terceiros..."
    foreach ($Bloat in $Bloatware) {
        Get-AppxPackage -Name $Bloat| Remove-AppxPackage
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Bloat | Remove-AppxProvisionedPackage -Online
        Get-AppxPackage -AllUsers -Name $Bloat| Remove-AppxPackage
        Write-Host "Trying to remove $Bloat."
    }
}




# Function CreateRestorePoint {
#     Write-Host "Criando ponto de restauração caso algo ruim aconteça"
#     Enable-ComputerRestore -Drive "C:\"
#     Checkpoint-Computer -Description "RestorePoint1" -RestorePointType "MODIFY_SETTINGS"
# }

Function EssentialTweaks {
    Write-Host "Desativando Telemetria..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater" | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy" | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" | Out-Null

    Write-Host "Desabilitando sugestões de aplicativos..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "ContentDeliveryAllowed" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "OemPreInstalledAppsEnabled" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEnabled" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEverEnabled" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353698Enabled" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Type DWord -Value 1

    Write-Host "Disabling Activity History..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -Type DWord -Value 0

    Write-Host "Disabling Location Tracking..."
    If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location")) {
        New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Type String -Value "Deny"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 0

    Write-Host "Disabling automatic Maps updates..."
    Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 0

    Write-Host "Disabling Feedback..."
    If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) {
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue | Out-Null

    Write-Host "Disabling Tailored Experiences..."
    If (!(Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
        New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 1

    Write-Host "Disabling Advertising ID..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Type DWord -Value 1

    Write-Host "Disabling Error reporting..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 1
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Windows Error Reporting\QueueReporting" | Out-Null


    Write-Host "Disabling Shared Experiences..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableCdp" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableMmx" -Type DWord -Value 0

    #Write-Host "Disabling Windows Defender..."
   # Disable-ScheduledTask -TaskName "\Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" | Out-Null
    #Disable-ScheduledTask -TaskName "\Microsoft\Windows\Windows Defender\Windows Defender Cleanup" | Out-Null
    #Disable-ScheduledTask -TaskName "\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" | Out-Null
    #Disable-ScheduledTask -TaskName "\Microsoft\Windows\Windows Defender\Windows Defender Verification"  | Out-Null

    Write-Host "Disabling Storage Sense..."
    Remove-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" -Recurse -ErrorAction SilentlyContinue




    # Windows 11 section
    Write-Host "Hiding Widgets from Taskbar..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -Type DWord -Value 0
    if (Test-Path ~\AppData\Local\Microsoft\WindowsApps\winget.exe){
        Write-Host "Uninstalling Widgets..."
        winget uninstall "Windows web experience pack"
    } 
	
	$ExplorerPath = "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Explorer.lnk"
	If (!(Test-Path $ExplorerPath)) {
    $Shell = New-Object -ComObject Shell.Application
    $Folder = $Shell.Namespace((Get-Item "C:\Windows\explorer.exe").DirectoryName)
    $Item = $Folder.ParseName("explorer.exe")
    $Item.InvokeVerb("Pin to Taskbar")
}

    Write-Host "Disabling Edge Preloading..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge" -Name "AllowPrelaunch" -Type DWord -Value 0
}

Function DisableServices {
    Write-Host "Disabling some services..."

	$services = @(
		#"ALG"                                          # Application Layer Gateway Service(Provides support for 3rd party protocol plug-ins for Internet Connection Sharing)
		#"AJRouter"                                     # Needed for AllJoyn Router Service
		#"AxInstSV"                                     # AllJoyn Router Service
		#"BcastDVRUserService_48486de"                  # GameDVR and Broadcast is used for Game Recordings and Live Broadcasts
		#"cbdhsvc_48486de"                              # Clipboard Service
		"diagnosticshub.standardcollector.service"     # Microsoft (R) Diagnostics Hub Standard Collector Service
		"#DiagTrack"                                    # Diagnostics Tracking Service
		"dmwappushservice"                             # WAP Push Message Routing Service
		#"DPS"                                          # Diagnostic Policy Service (Detects and Troubleshoots Potential Problems)
		"edgeupdate"                                   # Edge Update Service
		"edgeupdatem"                                  # Another Update Service
		"EntAppSvc"                                    # Enterprise Application Management.
		"Fax"                                          # Fax Service
		"fhsvc"                                        # Fax History
		"gupdate"                                      # Google Update
		"gupdatem"                                     # Another Google Update Service
		#"iphlpsvc"                                     # ipv6(Most websites use ipv4 instead)
		"lfsvc"                                        # Geolocation Service
		#"lmhosts"                                      # TCP/IP NetBIOS Helper
		"MapsBroker"                                   # Downloaded Maps Manager
		"MicrosoftEdgeElevationService"                # Another Edge Update Service
		"MSDTC"                                        # Distributed Transaction Coordinator
		#"ndu"                                          # Windows Network Data Usage Monitor (Disabling Breaks Task Manager Per-Process Network Monitoring)
		#"NetTcpPortSharing"                            # Net.Tcp Port Sharing Service
		#"PcaSvc"                                       # Program Compatibility Assistant Service
		#"PerfHost"                                     # Remote users and 64-bit processes to query performance.
		#"PhoneSvc"                                     # Phone Service(Manages the telephony state on the device)
		#"RemoteAccess"                                 # Routing and Remote Access
		#"RemoteRegistry"                               # Remote Registry
		"RetailDemo"                                   # Demo Mode for Store Display
		"SCardSvr"                                     # Windows Smart Card Service
		"SEMgrSvc"                                     # Payments and NFC/SE Manager (Manages payments and Near Field Communication (NFC) based secure elements)
		#"SharedAccess"                                 # Internet Connection Sharing (ICS)
		#"SysMain"                                      # Analyses System Usage and Improves Performance
		#"TrkWks"                                       # Distributed Link Tracking Client
		#"WerSvc"                                       # Windows error reporting
		#"wisvc"                                        # Windows Insider program(Windows Insider will not work if Disabled)
		"WMPNetworkSvc"                                # Windows Media Player Network Sharing Service
		"WpcMonSvc"                                    # Parental Controls
		"WPDBusEnum"                                   # Portable Device Enumerator Service
		"WpnService"                                   # WpnService (Push Notifications may not work)
		#"XblAuthManager"                               # Xbox Live Auth Manager (Disabling Breaks Xbox Live Games)
		#"XblGameSave"                                  # Xbox Live Game Save Service (Disabling Breaks Xbox Live Games)
		#"XboxNetApiSvc"                                # Xbox Live Networking Service (Disabling Breaks Xbox Live Games)
		#"XboxGipSvc"                                   # Xbox Accessory Management Service
		 # HP services
		"HPAppHelperCap"
		"HPDiagsCap"
		"HPNetworkCap"
		"HPSysInfoCap"
		"HpTouchpointAnalyticsService"
		 # Dell services
		"dcpm-notify"                                  # Dell Command | Power Manager Notify
		"DDVCollectorSvcApi"                           # Dell Data Vault Service API
		"DDVDataCollector"                             # Dell Data Vault Collector
		"DDVRulesProcessor"                            # Dell Data Vault Processor
		"Dell.CommandPowerManager.Service"             # Dell.CommandPowerManager.Service
		"DellClientManagementService"                  # Dell Client Management Service
		"DellTechHub"                                  # Dell TechHub
		"DPMService"                                   # Dell Peripheral Manager Service
		"SupportAssistAgent"                           # Dell SupportAssist
		 # Hyper-V services
		#"HvHost"
		#"vmicguestinterface"
		#"vmicheartbeat"
		#"vmickvpexchange"
		#"vmicrdv"
		#"vmicshutdown"
		#"vmictimesync"
		#"vmicvmsession"
		"AdobeARMservice"                             # Adobe Acrobat Update Service
		"FoxitReaderUpdateService"                    # Foxit PDF Reader Update Service
		"StateRepository"                             # State Repository Service
		"StorSvc"                                     # Storage Service
		"WpnService"                                  # Windows Push Notifications System S...
        
	)
	
	foreach ($service in $services) {
		# -ErrorAction SilentlyContinue is so it doesn't write an error to stdout if a service doesn't exist
		$thisService = Get-Service -Name $service -ErrorAction SilentlyContinue
		if ($null -eq $thisService) {
			Write-Host "Serviço $service não encontrado!"
		}
		else {
			Write-Host Service $thisService.Name '('$thisService.DisplayName')' is in $thisService.StartType mode
			if ($thisService.StartType -eq 'Automatic') {
				Write-Host "Stopando $service"...
				Stop-Service "$service" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
				Write-Host "Definindo $service StartupType para Manual"...
				Set-Service "$service"  -ErrorAction SilentlyContinue -StartupType Manual
			}
		}
	}

	# Windows Search must be set to disabled, otherwise it becomes restarting
   # Write-Output "Stopping and disabling Windows Search Service..."
    #Stop-Service "WSearch" -WarningAction SilentlyContinue
    #Set-Service "WSearch" -StartupType Disabled
}

Function DisableScheduledTasks {
    $tasks = @(
        # Windows base scheduled tasks
        "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319"
        "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 64"
        "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 64 Critical"
        "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 Critical"
    
        "\Microsoft\Windows\AppID\SmartScreenSpecific"
    
        "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask"
    
        "\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser"
    
        "\Microsoft\XblGameSave\XblGameSaveTask"
    )
    
	Write-Output "Disabling scheduled tasks..."
    foreach ($task in $tasks) {
        $parts = $task.split('\')
        $name = $parts[-1]
        $path = $parts[0..($parts.length-2)] -join '\'
    
        Disable-ScheduledTask -TaskName "$name" -TaskPath "$path" -ErrorAction SilentlyContinue
    }    
}

Function RestartExplorer {
    Stop-Process -ProcessName explorer -Force
    Start-Sleep -Seconds 3
    Start-Process explorer
}

Function Cor {
	
	# Definir tema para modo escuro
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0

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



# Main function invocation
# CreateRestorePoint;
EssentialTweaks;
DisableServices;
DisableScheduledTasks;
Customize;
DebloatMS;
DebloatThirdParty;
RestartExplorer;
Cor;

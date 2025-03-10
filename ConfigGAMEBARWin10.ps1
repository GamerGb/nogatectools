# Define funções Win32 para manipulação de janelas
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    
    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
    
    [DllImport("user32.dll")]
    public static extern void SwitchToThisWindow(IntPtr hWnd, bool fAltTab);
}
"@

# Define a classe para simular pressionamento de teclas
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public static class KeyboardSimulator {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);
    
    public const int VK_TAB = 0x09;
    public const int VK_SPACE = 0x20;

    public static void PressKey(int vKey) {
        keybd_event((byte)vKey, 0, 0, UIntPtr.Zero); // Pressiona a tecla
        keybd_event((byte)vKey, 0, 2, UIntPtr.Zero); // Solta a tecla
    }
}
"@

# Abre as configurações da Game Bar
$settingsProc = Start-Process "ms-settings:gaming-gamebar" -PassThru -WindowStyle Normal

# Aguarda até a janela abrir completamente
$timeout = 10  # Tempo máximo de espera em segundos
while ($timeout -gt 0) {
    $settingsHWND = (Get-Process -Name "SystemSettings" -ErrorAction SilentlyContinue | Select-Object -First 1).MainWindowHandle
    if ($settingsHWND -ne [IntPtr]::Zero) {
        break
    }
    Start-Sleep -Milliseconds 500
    $timeout -= 0.5
}

# Se a janela abriu, traz para o primeiro plano
if ($settingsHWND -ne [IntPtr]::Zero) {
    [Win32]::ShowWindow($settingsHWND, 5)  # 5 = SW_SHOW
    Start-Sleep -Milliseconds 500
    [Win32]::SwitchToThisWindow($settingsHWND, $true)
    Start-Sleep -Milliseconds 500
    [Win32]::SetForegroundWindow($settingsHWND)
}

# Minimiza a janela do script atual (PowerShell)
$currentHWND = (Get-Process -Id $PID).MainWindowHandle
if ($currentHWND -ne [IntPtr]::Zero) {
    [Win32]::ShowWindow($currentHWND, 2)  # 2 = SW_MINIMIZE
}

# Define os códigos das teclas a serem simuladas
$keystrokes = @(
    [KeyboardSimulator]::VK_TAB,  # Tab
    [KeyboardSimulator]::VK_TAB,  # Tab	
    [KeyboardSimulator]::VK_SPACE, # Space (Desativa a Game Bar)
    [KeyboardSimulator]::VK_TAB,  # Tab
    [KeyboardSimulator]::VK_SPACE  # Space (Desativa capturas de tela)
)

# Simula os pressionamentos com intervalo entre eles
foreach ($key in $keystrokes) {
    [KeyboardSimulator]::PressKey($key)
    Start-Sleep -Milliseconds 500
}

# Aguarda um pouco antes de finalizar e fecha o Settings
Start-Sleep -Seconds 1
Stop-Process -Name "SystemSettings" -Force

# Define funções Win32 para manipulação de janelas
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
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

# Abre o ms-settings:gaming-gamebar e captura o objeto do processo
$settingsProc = Start-Process "ms-settings:gaming-gamebar" -PassThru

# Aguarda o tempo necessário para a janela carregar
Start-Sleep -Seconds 5

# Traz a janela do ms-settings para o primeiro plano
$settingsHWND = $settingsProc.MainWindowHandle
if ($settingsHWND -ne [IntPtr]::Zero) {
    [Win32]::SetForegroundWindow($settingsHWND)
}

# Minimiza a janela do script atual (PowerShell)
$currentHWND = (Get-Process -Id $PID).MainWindowHandle
if ($currentHWND -ne [IntPtr]::Zero) {
    [Win32]::ShowWindow($currentHWND, 2)  # 2 = SW_MINIMIZE
}

# Define os códigos das teclas a serem simuladas
$keystrokes = @(
    9,     # Tab
    9,     # Tab	
    32,    # Space
    9,     # Tab
    32     # Space
)

# Simula os pressionamentos com intervalo entre eles
foreach ($key in $keystrokes) {
    [KeyboardSimulator]::PressKey($key)
    Start-Sleep -Milliseconds 500
}

# Aguarda um pouco antes de finalizar e fecha o Settings
Start-Sleep -Seconds 1
Stop-Process -Name 

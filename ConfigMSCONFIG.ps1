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
    
    public const int VK_RIGHT = 0x27;
    public const int VK_TAB   = 0x09;
    public const int VK_SPACE = 0x20;
    public const int VK_ENTER = 0x0D;

    public static void PressKey(int vKey) {
        keybd_event((byte)vKey, 0, 0, UIntPtr.Zero); // Pressiona a tecla
        keybd_event((byte)vKey, 0, 2, UIntPtr.Zero); // Solta a tecla
    }
}
"@

# Inicia o msconfig e obtém o objeto do processo
$msconfigProc = Start-Process msconfig -PassThru -WindowStyle Normal

# Aguarda o msconfig carregar (aguarda até 10 segundos)
$timeout = 10
while ($timeout -gt 0) {
    $msconfigHWND = $msconfigProc.MainWindowHandle
    if ($msconfigHWND -ne [IntPtr]::Zero) {
        break
    }
    Start-Sleep -Milliseconds 500
    $timeout -= 0.5
}

# Se a janela estiver carregada, traz para o primeiro plano
if ($msconfigHWND -ne [IntPtr]::Zero) {
    [Win32]::ShowWindow($msconfigHWND, 5)  # 5 = SW_SHOW
    Start-Sleep -Milliseconds 500
    [Win32]::SetForegroundWindow($msconfigHWND)
    Start-Sleep -Milliseconds 500
}

# Minimiza a janela atual do script (PowerShell)
$currentHWND = (Get-Process -Id $PID).MainWindowHandle
if ($currentHWND -ne [IntPtr]::Zero) {
    [Win32]::ShowWindow($currentHWND, 2)  # 2 = SW_MINIMIZE
}

# Define os códigos das teclas a serem simuladas
$keystrokes = @(
    [KeyboardSimulator]::VK_TAB,
    [KeyboardSimulator]::VK_TAB,
    [KeyboardSimulator]::VK_TAB,
    [KeyboardSimulator]::VK_TAB,
    [KeyboardSimulator]::VK_RIGHT,
    [KeyboardSimulator]::VK_RIGHT,
    [KeyboardSimulator]::VK_TAB,
    [KeyboardSimulator]::VK_TAB,
    [KeyboardSimulator]::VK_TAB,
    [KeyboardSimulator]::VK_SPACE,
    [KeyboardSimulator]::VK_ENTER
)

# Simula os pressionamentos com intervalo entre eles
foreach ($key in $keystrokes) {
    [KeyboardSimulator]::PressKey($key)
    Start-Sleep -Milliseconds 300
}

Start-Sleep -Seconds 2

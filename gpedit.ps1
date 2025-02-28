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
    public static extern short GetAsyncKeyState(int vKey);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);
    
    public const int VK_TAB = 0x09;
    public const int VK_DOWN = 0x28;
    public const int VK_SPACE = 0x20;

    public static void PressKey(int vKey) {
        keybd_event((byte)vKey, 0, 0, UIntPtr.Zero); // Press key
        keybd_event((byte)vKey, 0, 2, UIntPtr.Zero); // Release key
    }
}
"@

# Abre o gpedit.msc e captura o objeto do processo
$gpeditProc = Start-Process "gpedit.msc" -PassThru

# Aguarda o tempo necessário para a janela carregar
Start-Sleep -Seconds 6

# Traz a janela do gpedit para o primeiro plano
$gpeditHWND = $gpeditProc.MainWindowHandle
if ($gpeditHWND -ne [IntPtr]::Zero) {
    [Win32]::SetForegroundWindow($gpeditHWND)
}

# Minimiza a janela atual do script (PowerShell)
$currentHWND = (Get-Process -Id $PID).MainWindowHandle
if ($currentHWND -ne [IntPtr]::Zero) {
    [Win32]::ShowWindow($currentHWND, 2)  # 2 = SW_MINIMIZE
}

# Define os códigos das teclas a serem simuladas
$keystrokes = @(
    40,    # Down
    40,    # Down
    40,    

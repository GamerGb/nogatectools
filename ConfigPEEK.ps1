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
    public static extern short GetAsyncKeyState(int vKey);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);
    
    public const int VK_TAB = 0x09;
    public const int VK_DOWN = 0x28;
    public const int VK_SPACE = 0x20;
    public const int VK_ENTER = 0x0D;

    public static void PressKey(int vKey) {
        keybd_event((byte)vKey, 0, 0, UIntPtr.Zero); // Pressiona a tecla
        keybd_event((byte)vKey, 0, 2, UIntPtr.Zero); // Libera a tecla
    }
}
"@

# Inicia o SystemPropertiesPerformance e captura o objeto do processo
$perfProc = Start-Process "SystemPropertiesPerformance" -PassThru

# Aguarda até a janela abrir completamente
$timeout = 10  # Tempo máximo de espera em segundos
while ($timeout -gt 0) {
    $perfHWND = $perfProc.MainWindowHandle
    if ($perfHWND -ne [IntPtr]::Zero) {
        break
    }
    Start-Sleep -Milliseconds 500
    $timeout -= 0.5
}

# Se a janela abriu, traz para o primeiro plano
if ($perfHWND -ne [IntPtr]::Zero) {
    [Win32]::ShowWindow($perfHWND, 5)  # 5 = SW_SHOW
    Start-Sleep -Milliseconds 500
    [Win32]::SwitchToThisWindow($perfHWND, $true)
    Start-Sleep -Milliseconds 500
}

# Minimiza a janela atual do script (PowerShell)
$currentHWND = (Get-Process -Id $PID).MainWindowHandle
if ($currentHWND -ne [IntPtr]::Zero) {
    [Win32]::ShowWindow($currentHWND, 2)  # 2 = SW_MINIMIZE
}

# Define os códigos das teclas a serem simuladas
$keystrokes = @(
    9, 40, 40, 40, 40, 40, 40, 40, 32, # Marca "Ajustar para melhor desempenho"
    40, 40, 32,                            # Marca "Ativar suavização de fontes"
    40, 40, 40, 40, 40, 40, 32,        # Marca "Mostrar miniaturas em vez de ícones"
    40, 32,                                # Marca "Usar sombras para rótulos de ícones"
    9, 13                    # Aplica as alterações e confirma
)

# Simula os pressionamentos com intervalo entre eles
foreach ($key in $keystrokes) {
    [KeyboardSimulator]::PressKey($key)
    Start-Sleep -Milliseconds 300
}

# Aguarda um pouco antes de finalizar
Start-Sleep -Seconds 3

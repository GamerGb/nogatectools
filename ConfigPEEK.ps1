# Adiciona a função para manipular janelas usando a biblioteca user32.dll
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

# Traz a janela do PowerShell para o primeiro plano
$currentHWND = (Get-Process -Id $PID).MainWindowHandle
if ($currentHWND -ne [IntPtr]::Zero) {
    [Win32]::SetForegroundWindow($currentHWND)
}

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

# Aguarda até que a janela tenha um handle válido
$timeout = 10  # Tempo máximo de espera em segundos
do {
    Start-Sleep -Milliseconds 500
    $perfHWND = $perfProc.MainWindowHandle
    $timeout -= 0.5
} while (($perfHWND -eq [IntPtr]::Zero) -and ($timeout -gt 0))

# Se a janela não abriu corretamente, encerra o script
if ($perfHWND -eq [IntPtr]::Zero) {
    Write-Host "Erro: Não foi possível obter a janela do SystemPropertiesPerformance."
    exit 1
}

# Garante que estamos apenas manipulando a janela correta
if ($perfProc.ProcessName -eq "SystemPropertiesPerformance") {
    [Win32]::ShowWindow($perfHWND, 5)  # 5 = SW_SHOW
    Start-Sleep -Milliseconds 500
    [Win32]::SetForegroundWindow($perfHWND)  # Traz para o primeiro plano
    Start-Sleep -Milliseconds 500
} else {
    Write-Host "Erro: O processo capturado não é o SystemPropertiesPerformance."
    exit 1
}

# Minimiza a janela do PowerShell apenas se existir
if ($currentHWND -ne [IntPtr]::Zero) {
    [Win32]::ShowWindow($currentHWND, 2)  # 2 = SW_MINIMIZE
}

# Define os códigos das teclas a serem simuladas
$keystrokes = @(
    9, 40, 40, 40, 40, 40, 40, 40, 32, # Marca "Ajustar para melhor desempenho"
    40, 40, 32,                        # Marca "Ativar suavização de fontes"
    40, 40, 40, 40, 40, 40, 32,        # Marca "Mostrar miniaturas em vez de ícones"
    40, 32,                            # Marca "Usar sombras para rótulos de ícones"
    9, 13                               # Aplica as alterações e confirma
)

# Simula os pressionamentos com intervalo entre eles
foreach ($key in $keystrokes) {
    [KeyboardSimulator]::PressKey($key)
    Start-Sleep -Milliseconds 500
}

# Aguarda um pouco antes de finalizar
Start-Sleep -Seconds 3

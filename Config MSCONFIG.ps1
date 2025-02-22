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

# Abre o SystemPropertiesPerformance
start msconfig

# Aguarda o tempo necessário para a janela ser carregada
Start-Sleep -Seconds 2

# Simula a navegação e a seleção
$keystrokes = @(
    39,    # Seta Direita
    39,    # Seta Direita
    39,    # Seta Direita
    39,    # Seta Direita
    39,    # Seta Direita
    9,     # Tab	
    9,     # Tab
    9,     # Tab
    9,     # Tab	
    32,     # Space
    #13 # Enter


)

foreach ($key in $keystrokes) {
    [KeyboardSimulator]::PressKey($key)
	    Start-Sleep -Milliseconds 300  # Intervalo entre os pressionamentos
}

# Aguarda um pouco antes de finalizar
Start-Sleep -Seconds 1

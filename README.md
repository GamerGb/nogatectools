# Nogatec Tools

![Nogatec Tools Banner]([https://via.placeholder.com/1200x200/000000/00FF00?text=Nogatec+Tools](https://raw.githubusercontent.com/GamerGb/nogatectools/refs/heads/main/NogatecLogo.ico))

**Nogatec Tools** é um script .bat que automatiza o processo de instalação, configuração e atualização de drivers, além de realizar a instalação e ativação do Office e do Windows. O script oferece uma interface gráfica interativa e ajusta configurações automaticamente conforme o sistema operacional.

## ⚙️ Instalação

### Requisitos:
- **Sistema Operacional**: Windows 10 ou 11 (64 bits)
- **Permissões**: O script precisa ser executado com **privilegios elevados**.
- **Dependências**: O script instala as dependências automaticamente.
- **Conexão com a Internet**: Necessária para baixar drivers e acessar repositórios na nuvem.

### Como Instalar:
1. Baixe o script **Nogatec_Tools.bat**.
2. Execute o script com **privilegios elevados** (botão direito → "Executar como administrador").
3. O script instalará as dependências automaticamente e começará a execução.

---

## 🛠️ Configuração

- **Configuração Automática**: O script detecta automaticamente a versão do Windows e ajusta a configuração para Windows 10 ou 11.
- **Personalização**: Algumas opções estão disponíveis via menu interativo, como instalação básica, gamer, e configurações específicas do sistema operacional.
- **Nuvem e GitHub**: Configurações são carregadas diretamente da nuvem (GitHub), sem necessidade de arquivos locais.

---

## 🖥️ Drivers

- **Detecção Automática**: Detecta automaticamente o modelo da placa-mãe e da placa de vídeo.
- **Suporte a Marcas**: Suporta a detecção e instalação de drivers de marcas como **Dell**, **HP**, entre outras.
- **Instalação Simples**: Abre o site do fabricante para que o usuário possa procurar e instalar os drivers facilmente.
- **Backup de Drivers**: Não implementado atualmente, mas a instalação de drivers é feita automaticamente.

---

## 🖱️ Uso e Comandos

### Interface Gráfica:
- O **Nogatec Tools** possui um menu interativo onde o usuário pode selecionar a tarefa que deseja executar, incluindo:
  - **Instalação Básica** ou **Gamer**
  - **Instalação e Ativação do Office**
  - **Configuração do Windows (10 ou 11)**
  - **Detecção e Instalação de Drivers**

### Logs:
- O script mantém um log visual no terminal com o status das operações.
  - **Verde**: Sucesso (Operação concluída com êxito)
  - **Vermelho**: Em execução/Erro
  - **Azul**: Erro ou falha durante o processo

---

## 💬 Contribuições

Se você deseja contribuir com melhorias ou correções, fique à vontade para abrir uma **issue** ou um **pull request**.

---

## 📄 Licença

Este projeto está licenciado sob a [Licença MIT](LICENSE).

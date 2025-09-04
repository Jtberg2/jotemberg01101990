#!/bin/bash
#
# Script de validação e correção para instalação do Symantec Endpoint Protection no Ubuntu 22.04.5
# Verifica versão do kernel, headers e dependências. Instala automaticamente pacotes faltando.
#

echo "=== Validação e Correção de Requisitos para Symantec Endpoint Protection ==="

# 1. Verificar versão do kernel em uso
KERNEL_VERSION=$(uname -r)
KERNEL_MAJOR=$(echo $KERNEL_VERSION | cut -d"." -f1)
KERNEL_MINOR=$(echo $KERNEL_VERSION | cut -d"." -f2)

echo ">> Kernel detectado: $KERNEL_VERSION"

if [ "$KERNEL_MAJOR" -eq 5 ] && [ "$KERNEL_MINOR" -eq 15 ]; then
    echo "[OK] Kernel é compatível (5.15.x)."
else
    echo "[ALERTA] Kernel não é 5.15.x. O SEP pode não ser suportado nesta versão."
fi

# 2. Garantir atualização de pacotes
echo ">> Atualizando lista de pacotes..."
sudo apt update -y

# 3. Verificar e instalar headers do kernel
if dpkg -l | grep -q "linux-headers-$(uname -r)"; then
    echo "[OK] Headers do kernel estão instalados."
else
    echo "[INSTALANDO] Headers do kernel..."
    sudo apt install -y "linux-headers-$(uname -r)"
fi

# 4. Verificar e instalar dmidecode
if command -v dmidecode &> /dev/null; then
    echo "[OK] dmidecode está instalado."
else
    echo "[INSTALANDO] dmidecode..."
    sudo apt install -y dmidecode
fi

# 5. Exibir espaço livre
echo ">> Espaço livre em /:"
df -h / | tail -1 | awk '{print $4 " livres"}'

echo "=== Validação e Correção concluídas ==="

#!/bin/bash

# Función para manejar errores
handle_error() {
    echo "Error: Falló la instalación en el paso $1."
    exit 1
}

# Definir versiones y URLs
TERRAFORM_DOCS_VERSION="v0.19.0"
TERRAFORM_DOCS_URL="https://terraform-docs.io/dl/${TERRAFORM_DOCS_VERSION}/terraform-docs-${TERRAFORM_DOCS_VERSION}-$(uname -s | tr '[:upper:]' '[:lower:]')-amd64.tar.gz"
OPA_URL="https://openpolicyagent.org/downloads/latest/opa_linux_amd64"

echo "Iniciando instalación de herramientas..."

# 1. Instalar pip para Python 3
echo "Instalando pip para Python 3..."
sudo apt-get update -y
sudo apt-get install -y python3-pip || handle_error "1 (pip3)"

# 2. Instalar Checkov
echo "Instalando Checkov..."
pip3 install --break-system-packages checkov || handle_error "2 (checkov)"

# 3. Instalar dependencias de HashiCorp
echo "Instalando dependencias de repositorio..."
sudo apt-get install -y gnupg software-properties-common curl || handle_error "3 (deps)"

# 4. Agregar repositorio e Instalar Terraform
echo "Instalando Terraform oficial..."
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install terraform -y || handle_error "4 (terraform)"

# 5. Instalar Terraform-Docs
echo "Instalando Terraform-Docs..."
curl -sSLo terraform-docs.tar.gz "$TERRAFORM_DOCS_URL" || handle_error "5.1"
tar -xzf terraform-docs.tar.gz || handle_error "5.2"
chmod +x terraform-docs
sudo mv terraform-docs /usr/local/bin/ || handle_error "5.3"

# 6. Instalar OPA
echo "Instalando OPA..."
curl -L -o opa "$OPA_URL" || handle_error "6.1"
chmod +x opa
sudo mv opa /usr/local/bin/ || handle_error "6.2"

# 7. Instalar TFLint
echo "Instalando TFLint..."
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash || handle_error "7"

echo "Instalación completada con éxito."
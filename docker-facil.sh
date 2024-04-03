#!/bin/bash
# Autor: AlFcl
# GitHub: https://github.com/alfcl

# Definición de colores
YELLOW='\033[1;33m'
NC='\033[0m'  # No Color

# Selección de idioma
    echo "Select your language / Selecciona tu idioma"
    echo "1. Español"
    echo "2. English"
    read -p "Select your language / Selecciona tu idioma (1-2): " LANG_OPTION

LENG_PATH="leng"

if [ "$LANG_OPTION" == "1" ]; then
    source "${LENG_PATH}/es/messages.txt"
elif [ "$LANG_OPTION" == "2" ]; then
    source "${LENG_PATH}/en/messages.txt"
else
    echo "Invalid option / Opción no válida."
    exit 1
fi

# Convertir todas las líneas del archivo de mensajes en variables
while IFS='=' read -r key value; do
    declare ${key}="${value}"
done < "${LENG_PATH}/${LANG_OPTION}/messages.txt"

# Bienvenida y menú de acciones
echo -e "${YELLOW}${BIENVENIDA}${NC}"
echo "1. ${INSTALAR}"
echo "2. ${DESINSTALAR}"
echo "3. ${CANCELAR}"
echo -e "${YELLOW}${SELECCIONA_OPCION}${NC}"

# Leer la selección del usuario
read -p "(1-3): " ACTION

# Función de instalación para Docker
install_docker() {
    echo -e "${YELLOW}${INICIANDO_INSTALACION} Docker...${NC}"
    sudo apt update
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt update
    sudo apt install -y docker-ce
    echo -e "${YELLOW}${INSTALACION_COMPLETA}${NC}"
}

# Función de instalación para Docker Compose
install_docker_compose() {
    echo -e "${YELLOW}${INICIANDO_INSTALACION} Docker Compose...${NC}"
    sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo -e "${YELLOW}${INSTALACION_COMPLETA}${NC}"
}

# Función de desinstalación para Docker
uninstall_docker() {
    echo -e "${YELLOW}${INICIANDO_DESINSTALACION} Docker...${NC}"
    sudo apt-get purge -y docker-engine docker docker.io docker-ce docker-ce-cli
    sudo apt-get autoremove -y --purge docker-engine docker docker.io docker-ce
    echo -e "${YELLOW}${DESINSTALACION_COMPLETA}${NC}"
}

# Función de desinstalación para Docker Compose
uninstall_docker_compose() {
    echo -e "${YELLOW}${INICIANDO_DESINSTALACION} Docker Compose...${NC}"
    sudo rm /usr/local/bin/docker-compose
    echo -e "${YELLOW}${DESINSTALACION_COMPLETA}${NC}"
}

# Ejecución basada en la selección del usuario
case $ACTION in
    1)
        install_docker
        ;;
    2)
        install_docker_compose
        ;;
    3)
        install_docker
        install_docker_compose
        ;;
    4)
        uninstall_docker
        uninstall_docker_compose
        ;;
    5)
        echo -e "${YELLOW}${OPERACION_CANCELADA}${NC}"
        exit 0
        ;;
    *)
        echo -e "${YELLOW}${OPCION_INVALIDA}${NC}"
        exit 1
        ;;
esac

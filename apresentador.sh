#!/bin/bash

# CRIADOR : LUCIANO PEREIRA DE SOUZA
# REVISOR : LUCIANO PEREIRA DE SOUZA
# FINALIDADE : AO INICIAR O TERMINAL, MOSTRAR O NOME DO SISTEMA, DATA E HORA.

# Versão
versao="1.0"

# Nome do sistema.
sistema=$(hostnamectl | grep "Operating System" | \
          cut -d: -f2- | sed 's/^ *//' | cut -d" " -f1-2)


# Testa argumentos.
if [ $# -ge 1  ]; then
    argumento=$1
    if [ $argumento = "-V" -o $argumento = "--version" ]; then
        echo "Versão : $versao" ; exit 10
    fi
fi


#=== Funções de instalação ===#
function debian_figlet {
    local teste_figlet=$(dpkg -l | grep "figlet" | \
                         tr -s " " | cut -d" " -f2)
    if [ "$teste_figlet" != "figlet" ]; then
        sudo apt install -y figlet
    fi
}

function fedora_figlet {
    sudo yum install -y figlet
}

function arch_figlet {
    sudo pacman install -y figlet
}


#=== Função colocxa texto no final do arquivo bashrc ===#
function bashrc_texto {
    local comando=$(grep "#=== Apresentação BASH ===#" ~/.bashrc)
    if [ "$comando" != "#=== Apresentação BASH ===#" ]; then
        echo '#=== Apresentação BASH ===#
data=$(date +%d/%m/%Y)
hora=$(date +%H:%M:%S)
sistema=$(hostnamectl | grep "Operating System" | \
          cut -d: -f2- | sed "s/^ *//" | cut -d" " -f1-2)
figlet -f future "$sistema"
echo "Bem Vindo, hoje é $data às $hora"
' >> $1
    fi
}



# Verifica se já foi instlado.
function verificador {
    verificado=$(grep "#=== Apresentação BASH ===#" ~/.bashrc)
    if [ "$verificado" = "#=== Apresentação BASH ===#" ]; then
        echo "Já está instalao no seu sistema!" ; exit 2
    fi
}


#=== Instalação ===#
verificador
if [ "$sistema" = "Debian GNU/Linux" ]; then
    debian_figlet ; bashrc_texto ~/.bashrc
elif [ "$sistema" = "Fedora" ]; then
    fedora_figlet ; bashrc_texto ~/.bashrc
elif [ "$sistema" = "Arch Linux" ]; then
    arch_figlet ; bashrc_texto ~/.bashrc
else
    echo "Nenhum sistema detectado!" ; exit 1
fi









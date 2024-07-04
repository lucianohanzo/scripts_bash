#!/bin/bash

clear

# Diretório a ser escaniado.
DirScan="Caminho_Absoluto"

# Arquivo de log, onde fica salvo os logs.
ArqLog="/tmp/remove_repetidos.log"

find $DirScan -type f | sort > /tmp/arquivo_temp.txt

ArquivoTexto=$(cat /tmp/arquivo_temp.txt)

Contador=0
Tamanho_Total=0

OldIFS=$IFS
IFS=$'\n'

#Laço principal.
for x in $ArquivoTexto; do
    ArqScan=$x
    for y in $ArquivoTexto; do
        if [ -e $ArqScan -a $ArqScan != $y ]; then
            Arq01=$(basename $ArqScan)
            Arq02=$(basename $y)
            if [ $Arq01 == $Arq02 ]; then
                Check01=$(md5sum $ArqScan | cut -d" " -f1)
                Check02=$(md5sum $y | cut -d" " -f1)
                if [ $Check01 == $Check02 ]; then
                    Tamanho=$(ls -l $y | cut -d" " -f5)
                    rm $y
                    NomeArq=$(basename $y)
                    echo -n "Arquivo " ; tput setaf 1 bold
                        echo -n "$NomeArq" ; tput sgr0 ; echo " excluido."
                    echo -n "Tamanho do arquivo : " ; tput setaf 14 bold
                    Contador=$(echo $(($Contador + 1)))
                    Tamanho_Total=$(echo $(($Tamanho_Total + $Tamanho)))

                    if [ $Tamanho -lt 1024 ]; then
                        Tamanho=$(echo "$Tamanho Bytes")
                    elif [ $Tamanho -gt 1024 -a $Tamanho -lt 1048576 ]
                    then
                        Tamanho=$(echo "$(bc <<< \
                            "scale=2; $Tamanho / 1024") KiloBytes" |\
                             sed 's/\./\,/') 
                    elif [ $Tamanho -gt 1048576 -a $Tamanho -lt 1073741824 ]
                    then
                        Tamanho=$(echo "$(bc <<< \
                            "scale=2; $Tamanho / 1024^2") MegaBytes" |\
                            sed 's/\./\,/')
                    elif [ $Tamanho -gt 1073741824 -a\
                        $Tamanho -lt 1099511627776 ]; then
                        Tamanho=$(echo "$(bc <<< \
                        "scale=2; $Tamanho / 1024^3") GigaBytes" |\
                        sed 's/\./\,/')
                    fi

                    echo "$Tamanho" ; tput sgr0
                    echo -e "Caminho absoluto : $y\n"
                fi
            fi

        fi
    done
done
IFS=$OldIFS

# Tamanho total dos arquivos excluídos.
if [ $Tamanho_Total -lt 1024 ]; then
    Tamanho_Total=$(echo "$Tamanho_Total Bytes")
elif [ $Tamanho_Total -gt 1024 -a $Tamanho_Total -lt 1048576 ]; then
    Tamanho_Total=$(echo "$(bc <<< \
    "scale=2; $Tamanho_Total / 1024") KiloBytes" | sed 's/\./\,/') 
elif [ $Tamanho_Total -gt 1048576 -a $Tamanho_Total -lt 1073741824 ]; then
    Tamanho_Total=$(echo "$(bc <<< \
    "scale=2; $Tamanho_Total / 1024^2") MegaBytes" | sed 's/\./\,/')
elif [ $Tamanho_Total -gt 1073741824 -a $Tamanho_Total -lt 1099511627776 ]; then
    Tamanho_Total=$(echo "$(bc <<< \
    "scale=2; $Tamanho_Total / 1024^3") GigaBytes" | sed 's/\./\,/')
fi

# Mensagens de log.
Mensagem01=$(echo "Total de Arquivos excluidos : $Contador arquivos")
Mensagem02=$(echo "Foi excluído do disco : $Tamanho_Total")
Mensagem03=$(echo "Dia : $(date +"%d/%m/%Y") às $(date +"%H:%M:%S")")

# Cria 50 traços.
Tracos=$(seq 0 50 | xargs | sed -r 's/[0-9]{,3}//g' | sed 's/ /-/g')

echo -e "$Tracos\n$Mensagem01\n$Mensagem02\n$Mensagem03\n$Tracos\n" |\
    tee -a $ArqLog


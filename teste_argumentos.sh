#!/bin/bash

#=== Descrição ===#
# Esse script mostra como os argumentos interagem no if e for.
# Criador : LUCIANO PEREIRA DE SOUZA 
# Revisor : LUCIANO PEREIRA DE SOUZA 
#==============================================================================

if [ $# -gt 0 ]; then
    clear && echo -e "Nome do script \"$0\"\n"
    echo "Total de argumentos : $#"
    echo "Argumento(s) colocado(s) : $*" 
    echo -e "\nTeste de argumentos, com if."
else
    clear && echo "Nenhum argumento colocado :("
    exit 1
fi

if [ $1 ]; then
    echo "Argumento 1 : $1"
fi

if [ $2 ]; then
    echo "Argumento 2 : $2"
fi

if [ $3 ]; then
    echo "Argumento 3 : $3"
fi

Nu=0
echo -e "\nTeste de argumentos, com for."
for i in $*; do
    Nu=$(echo "$Nu + 1" | bc)
    echo "Argumento $Nu : $i"
done

# Fim do Script.


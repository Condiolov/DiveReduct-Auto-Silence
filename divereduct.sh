#!/usr/bin/env bash
arquivo_log="divereduct_$(date +"%d-%m-%Y_%H:%M").txt"
capa="
 _____  _                          _ _                    _
|  __ \(_)                        | (_)                  | |
| |  | |___   _____ _ __ ___  __ _| |_ ______ _ _ __   __| | ___
| |  | | \ \ / / _ | '__/ __|/ _\` | | |_  / _\` | '_ \ / _\` |/ _ \\
| |__| | |\ V |  __| |  \__ | (_| | | |/ | (_| | | | | (_| | (_) |
|_____/|_| \_/ \___|_|  |___/\__,_|_|_/___\__,_|_| |_|\__,_|\___/
                                                por Thiago Condé
DiveReduct  | Reduz seu video acelerando momentos de silencio e
            | comprime o tamanho do video reduzindo a qualidade.
            | Ajuda: divereduct -h"


help="
Comandos aceitos nessa mesma ordem:
    -h      Esta tela
    -a      Agradecimentos

    -f [\"nomes_arquivo\"] Videos Selecionados a serem reduzidos!!
            Nome do(s) arquivo(s) (mp4 ou mkv) com caminho
            entre aspas duplas separado por espaço  ex:
            divereduct -f \"video1.mp4 video 2.mkv\"

    -n [\"directorio\"] Todos videos da pasta serao reduzidos!!
            Nome do arquivo (mp4 ou mkv) com caminho
            entre aspas duplas separado ex:
            divereduct -f \"video1.mp4\"

    -d      Desligar? use no final do comando: -d 1

    exemplo padrão:
    divereduct -f \"video1.mp4 video 2.mkv\" -d 1


"
capa() {
    clear
    echo -e "${capa}" |& tee -a $arquivo_log
    printf "=%.0s"  $(seq 1 67)


}
ajuda() {
    capa
    echo "$help"
    exit 0
}

tamnhofiles(){
while read B dummy; do
  [ $B -lt 1024 ] && echo ${B} b && break
  KB=$(((B+512)/1024))
  [ $KB -lt 1024 ] && echo ${KB} Kb && break
  MB=$(((KB+512)/1024))
  [ $MB -lt 1024 ] && echo ${MB} Mb && break
  GB=$(((MB+512)/1024))
  [ $GB -lt 1024 ] && echo ${GB} Gb && break
  echo $(((GB+512)/1024)) Tb
done
}
agradecimentos(){
capa
RED1='\033[1;31m'
RED='\033[0;31m'
NC='\033[0m'
agradecimento="
                             ${RED1}'Tudo quanto te vier à mão para fazer,
                                    faze-o conforme as tuas forças,
                                               porque na sepultura,
                                    para onde tu vais, não há obra,
                                        nem indústria, nem ciência,
                                             nem sabedoria alguma.'
                                                            Ec 9.10${NC}

  - Agradecimentos a comunidade https://t.me/KdeBrasilDesenvolvimento
              em especial ao Tomaz Canabrava pela dica do menu dolpin

  - Agradecimentos a comunidade https://t.me/debxpcomunidade
            em especial ao Blau Araujo pelo conteudo de BASH

  - Agradecimentos a comunidade https://www.vivaolinux.com.br
                em especial ao msoliver (espaço no argumento)

  - Agradecimentos a Google por facilitar todo esse aprendizado!!

  ${RED}E muito obrigado a VOCÊ por esta lendo aqui!! Valeu!!

  Meu canal: www.youtube.com/diversalizando${NC}
"

echo -e "$agradecimento"
}

desligar() {
    if [ "${d}" = "1" ]; then
        echo "DESLIGA"
        else
            echo "NÃO DESLIGA"
            fi
}

#Apaga a pasta caso a tenha
if [ -e "./TEMP" ]
    then
    rm -R "./TEMP"
    fi


while getopts hf:n:d:a:v:x: opt; do
        case  "${opt}" in
        h) ajuda    ;;

        f)  f="$OPTARG"
            capa
            ;;
        n)  n="$OPTARG"
            capa
            ;;
        d)  d="$OPTARG"
            ;;
        v)  v="$OPTARG"
            ;;
        x)  x="$OPTARG"
            ;;
        a)  agradecimentos ;;

        *)  capa
        echo -e "\n[$(date +%R)] -----> Argumento invalido!!"
        ajuda;;
        esac
done
shift $((OPTIND-1))
if [ $OPTIND -eq 1 ]; then ajuda; fi


if [ -n "${n}" ]; then

OIFS="$IFS"
IFS=$'\n'

pasta=$(dirname $n)


for file in $(find "$pasta" -regex '.*\.\(mp4\|mkv\)')
do
    todos_pasta="$file $todos_pasta"
done
IFS="$OIFS"
f=$todos_pasta;
fi
 #echo "$todos_pasta"

 #exit 0

################### Apenas Selecionados
if [ -n "${f}" ]; then
    IFS=","
        output=$(echo "${f}" | sed -r 's|mkv\|mp4|&,|g')
        output=$(echo "$output" | sed -r 's|, |,|g')
        output=$(echo "$output" | sed -r 's|, /|,/|g')
        todos_selecionados=(${output//;/ })

       if [ -n "${v}" ]; then
        echo -e "\n       $(tput setaf 0)$(tput setab 3)'----> Redução configurada com cortes secos!!  $(tput sgr 0 )" |& tee -a $arquivo_log
         else
        v="3";
        fi

        if [ "${x}" = "2" ]; then
            echo -e "\n       $(tput setaf 0)$(tput setab 3)'----> Aceleração Ativada em 75%  $(tput sgr 0 )" |& tee -a $arquivo_log
              v="2";
             x="2";
         else
        x="0";
        echo -e "$x"
        fi



        echo -e "\n$(tput setaf 0)$(tput setab 4)[$(date +%R)] -----> Total de ${#todos_selecionados[@]} arquivo(s) a ser(em) comprimido(s): $(tput sgr 0)"  |& tee -a $arquivo_log
        for i in ${!todos_selecionados[@]}; do
            echo "       $(tput setaf 0)$(tput setab 2) $((i+1)) -> ${todos_selecionados[i]} $(tput sgr 0)" |& tee -a $arquivo_log
        done ;

        if [ "${d}" = "1" ]; then
            echo -e "       $(tput setaf 0)$(tput setab 3)'----> Configurado para desligar no final da compressões.  $(tput sgr 0 )" |& tee -a $arquivo_log
        fi

        for i in $output; do
        pasta=$(dirname $i)
            nomes_arquivo=$(echo $i | sed -e "s|$pasta/|ok__|g")
            nome_original=$(echo $i | sed -e "s|$pasta/||g")

#echo $pasta
            echo -e "\n$(tput setaf 0)$(tput setab 2)[$(date +%R)] [$nome_original] -----> Iniciando Aguarde..$(tput sgr 0)" |& tee -a $arquivo_log



            if [[ -f "$i" ]]
                then
                echo "       $(tput setaf 0)$(tput setab 6)'----> Arquivo válido reduzindo...$(tput sgr 0)" |& tee -a $arquivo_log
                SECONDS=0
                 tempo_video1=$(ffmpeg -i $i 2>&1 | grep Duration | cut -d ' ' -f 4 | sed s/,//)
                echo -e "       $(tput setaf 0)$(tput setab 6)'----> Video Original: ${nome_original} | Duração: ${tempo_video1:0:-3} $(tput sgr 0)" |& tee -a $arquivo_log

     python3 /home/thiago/Documentos/_imp/DiveReduct/jumpcutter.py --input_file \'$i\' --output_file \'$pasta/$nomes_arquivo\' --sounded_speed 1 --silent_speed $v --frame_margin 2 --frame_quality 3 --acelerar $x
                else
                    echo -e "       $(tput setaf 0)$(tput setab 1)'----> Arquivo não existe!! $(tput sgr 0) \n" |& tee -a $arquivo_log
                    fi

                    if [[ -f "$nomes_arquivo" ]]
                        then
                        #tempo_video=$(avconv -i $nomes_arquivo 2>&1 | grep "Duration"| cut -d ' ' -f 4 | sed s/,//)
                        #tempo_video1=$(ffmpeg -i $i 2>&1 | grep Duration | cut -d ' ' -f 4 | sed s/,//)
                        tempo_video2=$(ffmpeg -i $nomes_arquivo 2>&1 | grep Duration | cut -d ' ' -f 4 | sed s/,//)

                        reducao_d=$(( $(date -d "${tempo_video1:0:-3}" "+%s") - $(date -d "${tempo_video2:0:-3}" "+%s") ))
                        reducao_d=$(printf "0%d:%02d:%02d" $((reducao_d/60/60)) $((reducao_d/60%60)) $((reducao_d%60)))

                        td=$(stat -c%s "$nomes_arquivo")
                        ta=$(stat -c%s "$i")
                        reducao_t=$((- $td*100/$ta-100))
                        tamanho_depois=$(echo "$td" | tamnhofiles)
                        tamanho_antes=$(echo "$ta" | tamnhofiles)

                        duracao=$(TZ=UTC0 printf '%(%H:%M:%S)T\n' $SECONDS)

                        echo "       $(tput setaf 0)$(tput setab 6)'----> ($duracao) Tempo gasto para a Redução$(tput sgr 0)" |& tee -a $arquivo_log
                        echo "       $(tput setaf 0)$(tput setab 6)'----> ($reducao_t %) Redução de tamanho em Bytes: Antes: $tamanho_antes | Depois: $tamanho_depois $(tput sgr 0)" |& tee -a $arquivo_log
                        echo -e "       $(tput setaf 0)$(tput setab 6)'----> ($reducao_d) Redução na duração: Antes: ${tempo_video1:0:-3}  | Depois: ${tempo_video2:0:-3} $(tput sgr 0) \n" |& tee -a $arquivo_log
                        fi
                        done
                echo -e "\n$(tput setaf 0)$(tput setab 7) Arquivos Reduzidos!! Aperte ENTER para sair!! $(tput sgr 0)" |& tee -a $arquivo_log
fi

    if [ "${d}" = "1" ]; then
        echo "$(tput setaf 0)$(tput setab 7) Seu PC esta desligando, aperte CRTL + C para cancelar!! $(tput sgr 0)"
        sleep 10
        shutdown -h now
        fi

 read
 exit 0

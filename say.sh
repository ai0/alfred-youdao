#!/bin/bash

# 可以指定语言发音
# say -l zn_CN 我爱你中国

PATH='/bin:/usr/bin'
POSITIONAL=()
LANGUAGE=''
VOICE=''
YOUDAO=false

while [[ $# -gt 0 ]]
do
    key=$1

    case $key in
        -l|--language)
            LANGUAGE=$2
            shift
            shift
            ;;
        --yd)
            YOUDAO=true
            shift
            ;;
        *)
            POSITIONAL+=("$1")
            shift
            ;;
    esac
done

set -- "${POSITIONAL[@]}"

if [[ "$YOUDAO" = true ]]; then
    cd $TMPDIR
    curl -s -o $@ "https://dict.youdao.com/dictvoice?audio={$@}&type=2"
    afplay -q 1 $@
    rm $@
else

    if [[ ${#LANGUAGE} -gt 0 ]]; then
        VOICE=$(say -v ? | grep $LANGUAGE | cut -f1 -d ' ' | head -n 1)
    fi

    if [[ ${#VOICE} -gt 0 ]]; then
        say -v $VOICE $@
    else
        say $@
    fi

fi
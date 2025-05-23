# Find the correct path even if dereferenced by a link
__source=$0

if [[ "$__source" == *bash* ]]; then
  __source=${BASH_SOURCE[0]}
fi

__dir="$( dirname $__source )"
while [ -h $__source ]
do
  __source="$( readlink "$__source" )"
  [[ $__source != /* ]] && __source="$__dir/$__source"
  __dir="$( cd -P "$( dirname "$__source" )" && pwd )"
done
__dir="$( cd -P "$( dirname "$__source" )" && pwd )"

export KUBERNETES_PLAYGROUND_PATH=$__dir
unset __dir
unset __source

#for file in `\ls $KUBERNETES_PLAYGROUND_PATH/var/aliases/*.sh`
#do 
#        source $file
#done

export PATH=$KUBERNETES_PLAYGROUND_PATH/bin:$PATH
PATH=$(echo "$PATH" | awk -v RS=':' -v ORS=":" '!a[$1]++{if (NR > 1) printf ORS; printf $a[$1]}')

# indicator for the prompt that this environment is loaded
export PROMPT_ADDITIONS_KUBERNETES_PLAYGOURND="kubernetes-playground"

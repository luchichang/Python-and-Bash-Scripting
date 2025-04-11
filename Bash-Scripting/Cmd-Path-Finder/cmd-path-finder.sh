#!/bin/bash 

#-------------------------------
# finds the path of the given command 
#
#------------------------------

if [ ! -f /tmp/pathfile ]; then
        echo "pathfile not found"
        echo $PATH > /tmp/pathfile && echo "path file created"
fi


bin_path_count=$(( $( echo $PATH | grep -o ":" | wc -l  ) +1 ))

for i in $(seq 1  $bin_path_count)
do
        bin_path=$( cut -d ":" -f $i /tmp/pathfile)
        if [[ -n "$bin_path" && -n "$1" ]]; then
                res=$(find $bin_path -iname $1)
                if [[  "$res" != "" ]]; then
                        echo "Sucess: command $1 is in $bin_path path"
                        exit 0
                fi
        else
                echo "condition fails"
        fi
done

echo "INFO: Command $1 is not in the PATH Executable" && exit 1
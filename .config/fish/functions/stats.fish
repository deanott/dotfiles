function stats
    bass sed '/^#[[:digit:]]\+/d' $HISTFILE | cut -d' ' -f1 | sort | uniq -c | sort -rn | head -n 5 | awk '{ print $2 ": " $1 }'

end
#!/bin/bash

clear

ascii=$(cat <<'EOF'
      ____    __   ____  _____  ___  ____  ____    __
     (  _ \  /__\ (_  _)(  _  )/ __)( ___)(  _ \  /__\
      ) _ < /(__)\  )(   )(_)(( (__  )__)  )   / /(__)\
     (____/(__)(__)(__) (_____)\___)(____)(_)\_)(__)(__)
                 R E A D Y   T O   R E T R O
EOF
)

GREEN=$'\e[1;32m'
PURPLE=$'\e[1;35m'
RESET=$'\e[0m'

for i in {1..10}; do
    clear

    if (( i % 2 == 0 )); then
        printf "%b%s%b\n" "$GREEN" "$ascii" "$RESET"
    else
        printf "%b%s%b\n" "$PURPLE" "$ascii" "$RESET"
    fi

    sleep 0.5
done

clear
printf "%b%s%b\n" "$GREEN" "$ascii" "$RESET"
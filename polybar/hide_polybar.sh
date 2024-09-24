#!/bin/bash

# Configuração do Polybar
BAR="example" # Nome da barra no arquivo de configuração do Polybar

# Função para verificar se uma janela está em tela cheia
is_fullscreen() {
    xprop -id $1 | grep -q "_NET_WM_STATE_FULLSCREEN"
}

# Loop para monitorar janelas
while true; do
    WIN_ID=$(xdotool getactivewindow)
    if is_fullscreen $WIN_ID; then
        polybar-msg cmd hide
    else
        polybar-msg cmd show
    fi
    sleep 0.5
done

#!/bin/bash

function rainbow_text {
    local text="$1"
    local colors=(31 32 33 34 35 36)
    local color_count=${#colors[@]}
    local i=0
    for (( j=0; j<${#text}; j++ )); do
        printf "\e[${colors[$i]}m${text:$j:1}"
        ((i=(i+1)%color_count))
    done
    printf "\e[0m\n"
}

function green_text {
    echo -e "\e[32m$1\e[0m"
}

function red_text {
    echo -e "\e[31m$1\e[0m"
}

function orange_text {
    echo -e "\e[33m$1\e[0m"
}

function install_package {
    local package_name="$1"
    local install_message="$2"
    local success_message="$3"
    local error_message="$4"

    orange_text "$install_message"
    if apk add "$package_name"; then
        green_text "$success_message"
    else
        red_text "$error_message"
    fi
}

function prompt_and_install {
    local prompt_message="$1"
    local package_name="$2"
    local success_message="$3"
    local error_message="$4"

    read -p "$prompt_message (y/n): " choice
    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
        install_package "$package_name" "$prompt_message" "$success_message" "$error_message"
    fi
}

rainbow_text "Setup your VPS in one second. By itsoffkey."

sleep 3

install_package "python3" "Installing python..." "Python installed!" "Error installing python."
install_package "py3-pip" "Installing python pip..." "Python pip installed!" "Error installing python pip."
install_package "nodejs" "Installing Node.js..." "Node.js installed!" "Error installing Node.js."
install_package "openjdk11" "Installing OpenJDK..." "OpenJDK installed!" "Error installing OpenJDK."
install_package "git" "Installing Git..." "Git installed!" "Error installing Git."
install_package "curl" "Installing Curl..." "Curl installed!" "Error installing Curl."
install_package "docker" "Installing Docker..." "Docker installed!" "Error installing Docker."

read -p "Need to install nginx? (y/n): " nginx_choice
if [[ "$nginx_choice" == "y" || "$nginx_choice" == "Y" ]]; then
    install_package "nginx" "Installing nginx..." "Nginx installed!" "Error installing nginx."
else
    # Установка apache при подтверждении пользователя, если nginx не установлен
    read -p "Need to install apache? (y/n): " apache_choice
    if [[ "$apache_choice" == "y" || "$apache_choice" == "Y" ]]; then
        if ! command -v nginx &> /dev/null; then
            install_package "apache2" "Installing apache..." "Apache installed!" "Error installing apache."
        else
            red_text "Nginx is already installed. Skipping apache installation."
        fi
    fi
fi

#!/bin/sh

#adding flags cuz pretty lol
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -h|--help)
            echo "Usage: script.sh [-h|--help] [-v|--verbose]"
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
    shift
done

echo "Downloading the latest Discord Client"
    if [[ "$VERBOSE" == true ]]; then
        wget -O discord.tar.gz "https://discord.com/api/download?platform=linux&format=tar.gz"
    else
        wget -q --show-progress -O discord.tar.gz "https://discord.com/api/download?platform=linux&format=tar.gz"
    fi
echo "Creating the discord-latest directory and Extracting the files"
if [ -d "discord-latest" ]; then
    tar xf discord.tar.gz -C discord-latest
else
    mkdir discord-latest && tar xf discord.tar.gz -C discord-latest
fi


echo "We are going to use sudo to copy the extracted files to /opt/discord. Please enter your password to continue: "
sudo cp -R discord-latest/Discord/* /opt/discord

#patching a weird permission issue some instances need to fix
read -p "Due to some wierd permissions fault, some installs require you to fix the /dev/shim permission. Would you like to fix that now? (y/n): " answer

if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    echo "Running the command..."
    sudo chmod 1777 /dev/shm
else
    echo "Command not executed."
fi

#Running the program so it can properly initiate
echo -e "We are going to do a test run to make sure that it has properly installed. If you have any errors, please open a bug report with a copy of this command log!\n"

if [[ "$VERBOSE" == true ]]; then
    discord & PID=$!
    sleep 5
    kill -9 $PID
else
    discord &>/dev/null & PID=$!
    sleep 5
    kill -9 $PID &>/dev/null
fi

echo -e "\n    Closed Program: Discord\n"

#now for external utils
read -p "Discord should now be installed. If you would like to patch the client, please respond with B (betterdiscord), V (Vencord), or N (no) (bvn): " answer2

if [[ "$answer2" == "b" || "$answer2" == "B" ]]; then
    echo -p "checking if betterdiscord is installed...\n"

    if [[ -f "/usr/local/bin/betterdiscordctl" ]]; then
        echo "It was!"
        sudo betterdiscordctl self-upgrade && betterdiscordctl reinstall
    else
        echo "It wasnt!"
        curl -O https://raw.githubusercontent.com/bb010g/betterdiscordctl/master/betterdiscordctl && chmod +x betterdiscordctl && sudo mv betterdiscordctl /usr/local/bin && betterdiscordctl install
    fi
elif [[ "$answer2" == "v" || "$answer2" == "V" ]]; then
    sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"
else
    echo "Stock is better anyways lmao!"
fi
echo "Thank you for using fetch-discord.sh by v1p3rhax"

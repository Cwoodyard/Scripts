#!/bin/bash
# Due to how i was processing the args before, I am just adding a simple catch so that it registers the args properly now.
url=""
while [ "$#" -gt 0 ]; do
    case "$1" in
        -h|--help)
            echo 'Usage: youtube-dl-preset.sh [-h|--help] "url"'
            echo $1
            exit 0
            ;;
        -u|--url)
            shift
            if [ -n "$1" ]; then
                url="$1"
            else
                echo "Error: --url requires a value."
                exit 1
            fi
            ;;
        -*)
            echo "Unknown option: $1"
            exit 1
            ;;
        *)
            url="$1"
            ;;
    esac
    shift
done

# Adding a check to see if the required apps are installed to execute the script properly
missing=()
for cmd in yt-dlp ffmpeg; do
    if ! command -v "$cmd" &> /dev/null; then
        missing+=("$cmd")
    fi
done

if [ ${#missing[@]} -ne 0 ]; then
    echo "The following required command(s) are missing: ${missing[*]}"
    echo "Please install them before running this script."
    exit 1
fi

# Back to our regularly scheduled code
if [[ -z "$url" ]]; then
    echo "What is the url to the video/playlist you would like me to download?" 
    read url
fi

# get project name and move to the folder before starting the download
echo "what is the name of the project?"
read projName
mkdir "$projName"
cd "$projName"

# Start downloading the link provided on execution 
yt-dlp -vf "616+ba/620+ba/bv+ba/b" --write-subs --sub-lang en --write-auto-sub --convert-subs="srt" --cookies-from-browser firefox --no-check-certificate --add-metadata --convert-thumbnails jpg --ppa "ThumbnailsConvertor:-q:v 1" --embed-thumbnail -o "%(playlist_index)s - %(title)s.%(ext)s" -o "subtitle:%(title)s.%(ext)s" $url

# Exit project dir and copy to the final location if needed
cd .. 
exitFolder=''
qAnswer=''

echo "Would you like to move the completed project to a specific folder? [y/n] " 
read qAnswer

if [[ "$qAnswer" != "y" && "$qAnswer" != "Y" ]]; then
    echo "Exiting without moving the project."
    exit 0
elif [[ "$qAnswer" == "y" || "$qAnswer" == "Y" ]]; then
    echo "Please enter the full path to the exit folder: "
    read exitFolder
    mv -iv "$projName" "$exitFolder"
    echo "Project moved to $exitFolder"
fi
# Make sure to change this location to the folder you want it to be moved too after
# all the downloading is done. AKA i put it in the intake folder for manual review

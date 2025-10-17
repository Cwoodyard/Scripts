# Make sure to change this location to the folder you want it to be moved too after
# all the downloading is done. AKA i put it in the intake folder for manual review
exitFolder='{enter exit folder here}'

# get project name and move to the folder before starting the download
echo "what is the name of the project?"
read projName
mkdir "$projName"
cd "$projName"

# Start downloading the link provided on execution
yt-dlp -vf "616+ba/620+ba/bv+ba/b" --write-subs --sub-lang en --write-auto-sub --convert-subs="srt" --cookies-from-browser firefox --no-check-certificate --add-metadata --convert-thumbnails jpg --ppa "ThumbnailsConvertor:-q:v 1" --embed-thumbnail -o "%(playlist_index)s - %(title)s.%(ext)s" -o "subtitle:%(title)s.%(ext)s" $1

# Exit project dir and copy to the intake folder for manual review
cd .. 
# Not a good way to delete the file after the completion, will work on later
mv -iuv "$projName" "$exitFolder"
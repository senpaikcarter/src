echo "Downloading Curseforge Yall"

wget https://curseforge.overwolf.com/downloads/curseforge-latest-linux.zip

echo "undressin the zip"

unzip curseforge-latest-linux.zip

echo "removing zip"

ZIP=$(ls | grep "zip")
echo "deleting $ZIP"
sleep 5
rm $ZIP

echo "congratulations you can now run ./Curseforge and tab to autocomplete"
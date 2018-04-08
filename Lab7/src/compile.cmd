Taskkill /IM main.exe /F
gcc -c Main.adb Data.adb
gnatbind main
gnatlink main
.\main.exe
@echo ** File Download *************************************
curl -L -o "checkload_tcmd1000x64.exe" "https://totalcommander.ch/win/tcmd1000x64.exe"
@echo ** Hash Definition ***********************************
@echo 01250adbda3826003d3b1233a2b96657f63b00e6a7f879ceb857d20f74d687e679db875355c3f25e5aa2ca45f6185089bd530de9320f94bbeaf1ac61dfb00b4f
@echo ** Hash Actual Download ******************************
certutil -hashfile "tcmd1000x64.exe" sha512
@echo ******************************************************

@echo ** File Download *************************************
curl -L -o "checkload_lazarus-2.2.2-fpc-3.2.2-win64.exe" "https://kumisystems.dl.sourceforge.net/project/lazarus/Lazarus%20Windows%2064%20bits/Lazarus%202.2.2/lazarus-2.2.2-fpc-3.2.2-win64.exe"
@echo ** Hash Definition ***********************************
@echo c8aeb04bc82ddf5ec439193cd545351a5dc4c197bf3aa86c4bed4efbdc3cd7d27745a484655b6976e9378b0be314398e9f425c9012a538ef617457a8b51662cf
@echo ** Hash Actual Download ******************************
certutil -hashfile "lazarus-2.2.2-fpc-3.2.2-win64.exe" sha512
@echo ******************************************************

@echo ** File Download *************************************
curl -L -o "checkload_python-3.10.4-amd64.exe" "https://www.python.org/ftp/python/3.10.4/python-3.10.4-amd64.exe"
@echo ** Hash Definition ***********************************
@echo 32e6dadf7b1b97df21bef707f010f96cb39704616d7355cb067f6ea6ae8d077fcb2586223b90b728060d0ad0584c4aace2c808970e71eb8485f5d2b3eed3be23
@echo ** Hash Actual Download ******************************
certutil -hashfile "python-3.10.4-amd64.exe" sha512
@echo ******************************************************

@echo ** File Download *************************************
curl -L -o "checkload_emacs-28.1-installer.exe" "https://ftp.gnu.org/gnu/emacs/windows/emacs-28/emacs-28.1-installer.exe"
@echo ** Hash Definition ***********************************
@echo 8bc847e0c35fcb27cd1e1d09623606d113001c8f9343246bf299ae5a907c57c088c8609ccc9227ec294577a6b0e9519c557c28e95ee01ecc3633740ccbd58daa
@echo ** Hash Actual Download ******************************
certutil -hashfile "emacs-28.1-installer.exe" sha512
@echo ******************************************************

@echo ** File Download *************************************
curl -L -o "checkload_Git-2.36.1-64-bit.exe" "https://github.com/git-for-windows/git/releases/download/v2.36.1.windows.1/Git-2.36.1-64-bit.exe"
@echo ** Hash Definition ***********************************
@echo 1acfdfd599825af00636f7aea063350f99eb7958a6cb65539a817d20902b31c4e611fbe0f7d0271493237a406f244efb1935a320fccbfc2de9cf03efc8826d95
@echo ** Hash Actual Download ******************************
certutil -hashfile "Git-2.36.1-64-bit.exe" sha512
@echo ******************************************************

@echo ** File Download *************************************
curl -L -o "checkload_firefox-installer-x64.exe" "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US"
@echo ** Hash Definition ***********************************
@echo 6eb1755256f4f77c84d8cda4a2087f62a5fe129d23c2b0674e1ec8eccc9282ca0fe5fe6320c11d9c1aeb0e91f47baee416ebef02f77d35982074e21229179236
@echo ** Hash Actual Download ******************************
certutil -hashfile "firefox-installer-x64.exe" sha512
@echo ******************************************************

@echo ** File Download *************************************
curl -L -o "checkload_inno-setup.exe" "https://jrsoftware.org/download.php/is.exe?site=2"
@echo ** Hash Definition ***********************************
@echo be4a517ea178b988931548bf2cc7cdda2fc5a66da5ff82e4ed60bacd1854a79ea26bed41138a65d6392fca1e22517f78d5053bd09bb98a6b4c6bad1e3b6c28f9
@echo ** Hash Actual Download ******************************
certutil -hashfile "inno-setup.exe" sha512
@echo ******************************************************


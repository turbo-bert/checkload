# What is Checkload

    TL;DR

    Use URLs from a TXT file to download and hash (SHA-512) files on windows 10+.

`checkload` helps to use curl for downloading a batch of file from the internet. After downloading it checks the files contents against a given SHA-512 checksum. This is a very simple task if you're using MacOS or Linux. But for Windows this can be quite a hassle.

`checkload` brings its own SHA-512 from Openssl/Freepascal and uses curl (yes, from Windows 10 you have this) from your PATH.

You can define a checkload.txt file containing always tuples of 4-lines just like:

    LOWER-CASE-SHA512
    FILE-NAME-POSTFIX-WITHOUT-DIRECTORIES-TO-SAVE-FILE-AS
    HTTP-OR-HTTPS-URL-FOR-RETRIEVAL
    AN-EMPTY-LINE-BECAUSE-IT-IS-NICE
    ...

For security reasons, the files will be downloaded to `$CWD/.tmpfile` then hashed und if valid renamed to the given name *AND* a prefix `checkload_` right in front.

*Remember:* `checkload.txt` files must originate a trustworthy source! Parts from it will run in your terminal!

It is a little bit like pipenv. But just a little bit.

# File Format

A typical `checkload.txt` file would be

    01250adbda3826003d3b1233a2b96657f63b00e6a7f879ceb857d20f74d687e679db875355c3f25e5aa2ca45f6185089bd530de9320f94bbeaf1ac61dfb00b4f
    tcmd1000x64.exe
    https://totalcommander.ch/win/tcmd1000x64.exe
    
    32e6dadf7b1b97df21bef707f010f96cb39704616d7355cb067f6ea6ae8d077fcb2586223b90b728060d0ad0584c4aace2c808970e71eb8485f5d2b3eed3be23
    python-3.10.4-amd64.exe
    https://www.python.org/ftp/python/3.10.4/python-3.10.4-amd64.exe
    

# Supported Platforms and Dependencies

Of course you need the command line client of `curl` in your PATH.

  * Windows 10 x64 (fpc 3.2.2, laz 2.2.0)
  * MacOS 12.4+ (fpc 3.2.2, laz 2.2.0)
  * CHECKLOAD compiles with fpc 3.2.2 under probably any Linux (including Raspberry Pi)

# Download

## Windows 64 Bit

Find a build for Windows 64 https://github.com/turbo-bert/checkload/releases/download/v1.0.1/checkload.exe

Or if you're in in need, do this in a cmd window:

    curl -L -O "https://github.com/turbo-bert/checkload/releases/download/v1.0.1/checkload.exe"

## MacOS M1

Sorry! No hardware available. See the Paypal link beneath section `Contribute` ;)

## MacOS Intel

There is also a MacOS Intel (built on 12.4) executable https://github.com/turbo-bert/checkload/releases/download/v1.0.1/checkload

Or if you're in in need, do this in a Terminal window:

    curl -L -O "https://github.com/turbo-bert/checkload/releases/download/v1.0.1/checkload"

No warranties for anything. Binaries are un-signed.

# Example Use Case

## Windows Freepascal Setup

Assume you have spawned an empty Windows 10/2022 system:

    curl -L -O "https://github.com/turbo-bert/checkload/releases/download/v1.0.1/checkload.exe"
    curl -L -O "https://raw.githubusercontent.com/turbo-bert/checkload/main/presets/windows-developer/checkload.txt"
    checkload run

To see more progress updates you can also run

    checkload run -v

If you want to avoid running the binary take a look at the alternative rendered BAT file at https://raw.githubusercontent.com/turbo-bert/checkload/main/presets/windows-developer/no-checkload.bat

# FAQ

Why don't you use the tfphttpclient for downloading?
- Because it is a mess to get a recent and "safer" openssl version linked.

Why the h*** FreePascal?
- Because it is very easy to create compact exe files with almost no runtime dependencies.

# License

CHECKLOAD is free software. Use it for whatever you like.

# Contribute/Feedback

You think this is actually useful? You want to contribute or give-away money? Or you have an idea/feature you'd like to see? Create an issue or send money. https://www.paypal.me/turbobert82?country.x=DE&locale.x=de_DE

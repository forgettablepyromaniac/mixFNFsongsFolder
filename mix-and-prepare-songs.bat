@echo off
setlocal enabledelayedexpansion

if not exist "MixedFiles" mkdir "MixedFiles"

for /r %%d in (.) do (
    pushd "%%d"
    for %%i in ("%%~d") do set "dirname=%%~nxi"

    if exist "Inst.ogg" (
        if exist "Voices.ogg" (
            ffmpeg -y -i "Inst.ogg" -i "Voices.ogg" -filter_complex "[0:a][1:a]amix=inputs=2:duration=longest" "..\MixedFiles\!dirname!-mixed.wav"
            echo Mixed Inst.ogg and Voices.ogg into MixedFiles\!dirname!-mixed.wav
        ) else (
            if exist "Voices-Opponent.ogg" (
                if exist "Voices-Player.ogg" (
                    ffmpeg -y -i "Inst.ogg" -i "Voices-Opponent.ogg" -i "Voices-Player.ogg" -filter_complex "[0:a][1:a][2:a]amix=inputs=3:duration=longest" "..\MixedFiles\!dirname!-mixed.wav"
                    echo Mixed Inst.ogg, Voices-Opponent.ogg, and Voices-Player.ogg into MixedFiles\!dirname!-mixed.wav
                ) else (
                    echo Voices-Player.ogg not found in the current directory
                )
            ) else (
                echo Voices-Opponent.ogg not found in the current directory
            )
        )
    ) else (
        echo Inst.ogg not found in the current directory
    )
    popd
)

echo Finished processing all directories.
pause
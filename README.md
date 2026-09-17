# Wolfenstein RPG for PSP

An attempt to port Wolfenstein RPG Game to PSP
This is a work-in-progress project, current status: running, but currently unplayable due to limited capacity of PSP's RAM. When there are a lot of enemies, game stutters. I did this port with vibe coding and I am still trying to learn how to code for PSP. Pull requests and any help are welcome!
If you want to help, pm me at tg:@imp_symm

This port builds a native PSP homebrew EBOOT with the local PSPDEV toolchain,
SDL2, SDL2_mixer, OpenGL, OpenAL, zlib, and the existing hash library. Desktop
CMake builds remain unchanged.

## Build

Install PSPDEV with SDL2, SDL2_mixer, OpenAL, OpenGL, zlib, and the PSP system libraries,
then set `PSPDEV` and run:

```sh
./build-psp.sh
```

The output is `build-psp/src/EBOOT.PBP`.

## Install

Create `PSP/GAME/WolfensteinRPG/` on the Memory Stick and copy the EBOOT and
the legally obtained original archive beside it:

```text
PSP/GAME/WolfensteinRPG/
|-- EBOOT.PBP
`-- Wolfenstein RPG.ipa
```

## Crash log

The game writes `WolfensteinRPG.log` beside the EBOOT while it starts. If the
game crashes, copy that file from `PSP/GAME/WolfensteinRPG/` before launching
again and inspect the last `[stage]` entry. It identifies the last completed
startup step; `SDL_* failed` and `ZIP error` entries include the reported error.
The log is overwritten on each launch.

The archive is opened relative to the EBOOT's runtime directory. PSP save and
config files are written to the standard Memory Stick path
`PSP/SAVEDATA/WOLFRPG01/`. Original game data is not included.

The port keeps the original multiple-file save format inside that directory.
It does not yet open the interactive `sceUtilitySavedata` dialog or generate
official PSP `PARAM.SFO` metadata.

Sound effects continue to use OpenAL. Music uses SDL2_mixer's streamed music
path: the requested WAV is extracted in chunks to a temporary file under the
PSP save directory, then loaded with `Mix_LoadMUS`. Only one music track is
materialized at a time and the temporary file is replaced when tracks change.

## Controls

| PSP input | Action |
| --- | --- |
| D-pad up/down | Move forward/backward; navigate menus |
| D-pad left/right | Turn left/right; change menu page |
| Analog stick | Move and strafe |
| Cross | Attack, talk, use, or select |
| Square | Pass turn |
| Triangle | Automap |
| Circle or Start | Open menu or go back |
| L/R | Previous/next weapon |

## PSP limitations and risks

The build uses the existing fixed-function OpenGL renderer and OpenAL backend
through the PSP SDL/SDK libraries. No PPSSPP or real-hardware validation is
included in this repository. Rendering compatibility, memory use, audio
latency, suspend/resume, and performance still need emulator or hardware
verification.

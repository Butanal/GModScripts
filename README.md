# GModScripts
A few small Garry's Mod scripts originally written for my server.
Files :
* `cl_better_antiafk.lua` : a modification to [the official TTT gamemode's AFK check](https://github.com/Facepunch/garrysmod/blob/0f26a0e43dc5f49dfc138ec58db67ea6f34b4fb8/garrysmod/gamemodes/terrortown/gamemode/cl_init.lua#L334). It's heavier resource-wise because it hooks `StartCommand` instad of using a timer, but it isn't retarded, as it solely relies on the player's mouse position and pushed buttons to detemine if he's afk (instead of for example his position which can be modified if the player is pushed around). Also, the resource impact of using StartCommand doesn't seem noticeable. Note : edited a few things and didn't test, but it should work properly.

Note : the provided license is obviously limited by the original license of these scripts if they aren't original.

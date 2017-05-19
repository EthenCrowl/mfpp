# mfpp
A preprocessor for [Minecraft functions](http://minecraft.gamepedia.com/Function)

mfpp is still in alpha, planned features include macros and other time-saving devices.

# Syntax

Conditionals:

    if (selector) <
        ...
    >
    else <
        ...
    >
    
## Processing
To process the file <input>, do:
    perl mfpp.pl <input>

Once mfpp finishes executing, copy the main function file, `<input>.mcfunction`, anywhere in the world's function folder, and copy the auxiliary files into the world's `mfpp` namespace.

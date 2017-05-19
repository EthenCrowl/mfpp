# mfpp
A preprocessor for [Minecraft functions](http://minecraft.gamepedia.com/Function)

mfpp is still in alpha, planned features include improved macros, recursion, and other time-saving devices.

# Syntax

Conditionals:

    if (selector) <
        ...
    >
    else <
        ...
    >

Macros:

    define macroname <
        ...
    >
    ...
    <macroname>
    
## Processing
To process the file `<input>`, do:

    perl mfpp.pl <input>

Once mfpp finishes executing, copy the main function file, `<input>.mcfunction`, anywhere in the world's function folder, and copy the auxiliary files (`<input>.<some number>.mcfunction`) into the world's `mfpp` namespace.

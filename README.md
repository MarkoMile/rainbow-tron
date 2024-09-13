# RAINBOW TRON - a version of the classic videogame on the ZX Spectrum

# About

This is a version of the classic "Tron" videogame, programmed in Z80 assembly for the ZX Spectrum 48K. It can be run in an emulator, or on the actual device.
The program was first written and assembled in 2022, then disassembled and documented in 2024.

- See [Usage](#usage) for instructions on how to use this repository.
- See [Examples](#examples) for example media of the game.
- See [Backstory](#backstory) if you want to read more about the story behind this project.

# Examples

<table>
    <tbody>
        <tr>
            <td align="center">
                <img src="media/p1_wins_wall.png" alt="player1_wins_wall" style="width:100%">
            </td>
            <td align="center">
                <img src="media/start.png" alt="start" style="width:100%">
            </td align="center">
        </tr>
        <tr>
            <td align="center">
                <img src="media/p2_wins.png" alt="player2_wins_cut" style="width:100%">
            </td>
            <td align="center">
                <img src="media/p2_wins_wall.png" alt="player2_wins_wall" style="width:100%">
            </td align="center">
        </tr>
    </tbody>
<table>

# Usage

### Prerequisites

Before running the program, make sure you have the following:

- A working ZX Spectrum 48K emulator
- (optional) a working ZX Spectrum 48K, connected to a color screen

To play the game, you can load the provided `tron.tap` file into the emulator.
Depending on the emulator you might have to start the game yourself. This can be done with the following commands:

```
(J)LOAD (CTRL+P)"" (CTRL+SHIFT+I)CODE  --> this loads the program into the memory from the tape
(T)RANDOMIZE (CTRL+SHIFT+L)USR 32768 --> this will run the program
```

NOTE: Inside the brackets is what you are supposed to press to write the command

### Keybindings

- #### Player1 (Blue)
  - W -> up
  - A -> left
  - S -> down
  - D -> right
- #### Player2 (Yellow)
  - I -> up
  - J -> left
  - K -> down
  - L -> right

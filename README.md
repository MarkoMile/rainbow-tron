# RAINBOW TRON - a version of the classic videogame on the ZX Spectrum

# About

This is a version of the classic "Tron" videogame, programmed in Z80 assembly for the ZX Spectrum 48K. It can be run in an emulator, or on the actual device.
The program was first written and assembled in 2022, then disassembled and documented in 2024. 

 * See [Usage](#usage) for instructions on how to use this repository.
 * See [Examples](#examples) for example media of the game.
 * See [Backstory](#backstory) if you want to read more about the story behind this project.

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

* A working ZX Spectrum 48K emulator (ex. fuse)
* (optional) a working ZX Spectrum 48K, connected to a color screen

### Starting the game

To play the game, you can load the provided `tron.tap` file into the emulator.
You can also load the binary file if your emulator supports that.
Depending on the emulator you might have to start the game yourself. This can be done with the following commands:
```
(J)LOAD (CTRL+P)"" (CTRL+SHIFT+I)CODE  --> this loads the program into the memory from the tape

(T)RANDOMIZE (CTRL+SHIFT+L)USR 32768 --> this will run the program
```
NOTE: Some emulators automatically load the program into memory, so running the second command could be enough; Inside the brackets is what you are supposed to press on the keyboard to write the command.

### Keybindings
* #### Player1 (Blue)
  * W -> up
  * A -> left
  * S -> down
  * D -> right
* #### Player2 (Yellow)
  * I -> up
  * J -> left
  * K -> down
  * L -> right

# Assembling

If you want to assemble it for yourself, I recommend using pasmo assembler. That's the one that worked best for me.

It should be pretty straight forward, after installing pasmo assembler you just execute this command in the root directory: 

```pasmo ./tron.asm ./tron.bin```

And if you want a .tap (tape) file:

```pasmo --tap ./tron.asm ./tron.tap```
 
# Backstory

This project really deserves a backstory. In 2022 I attended my first winter seminar as an older attendee in the Petnica Science Center. This meant that, for the first time, I was starting my cycle of seminars with some prior experience. It was a great feeling, and I was really looking forward to the next week or so I would be spending there. We were learning about computer architecture and the assembly language. Specifically, we were learning about assembly for the Z80 microprocessor, which seemed a little unusual. But there was a catch! The reason we were programming for the Z80 was because we would be running our programs on a REAL Sinclair ZX Spectrum! When I found out, I got really excited. That's exactly my father's first computer. After some practice exercises, and learning the basics of programming in assembly, we got assigned projects. Mine was to recreate the videogame "Tron". I went for a simple approach, with 2 players racing around the screen and trying to cut each other off without running into anything. We had very little time, around 2 days in total to make these projects from nothing. Nevertheless, I managed to pull through - without compromising time spent hanging out! The most exciting part had come. It was time to run our programs on an actual ZX Spectrum. Only some of us had finished our projects, and we still had some trouble actually getting them on the Spectrum, but after everything, that was easy. It was extremely fun to move on from an emulator to the real deal. I was proud. I had proven to myself, for the first time, how fast I could learn something new (I had never seen assembly code before this), and I had a really cool project to show to my dad!

2 years later, I started uploading my projects to the internet, documenting them, and collecting all the parts that got scattered on different devices. My goal was to have all my projects in one place, and with good enough documentation that I could run them anytime without too much trouble. When it was time for this project, I couldn't find my assembly file anywhere! I was devastated. I searched for months, on different devices, backups, clouds, and even asked around in the Petnica Science Center. Nobody had any idea where it could be. The more I searched, the more I had to accept that it was most likely lost somewhere, possibly even deleted on accident. The only thing I managed to find was a binary file (that didn't work) and the working "tape" file that we used to load the program on the real ZX Spectrum. There was hope. When I realized that the assembly file was gone for good, I knew I had to disassemble the "tape" file and recover my lost assembly code. So that's what I did. That's why this project actually spans almost 3 years and has 2 parts - assembly and disassembly. It was tough disassembling the code because I no longer had any clue what I was looking at. But, after finishing the process, nostalgia hit me, and it felt like I was back in 2022 again.

# Checkers from Hell

How would you play a checkers game with a naughty sister who doesn't obey the rules? What would you do when she moves few pieces at a time? Or moves pieces backwards? Or moves... your pieces?! You can try to play by the original rules... or play by her rules! Enter this real time checkers simulation, with rules changing wildly every 16 seconds. Welcome to... Checkers from Hell ! 

![](https://raw.githubusercontent.com/Koshmaar/SisterCheckers/master/screen.jpg)

Hint: the game doesn't enforce the rules. Players have to cooperate to make it work... or don't cooperate for even more fun.

**Browser playable link: http://hubert-rutkowski.pl/downloads/CheckersFromHell/index.html**

GGJ project: http://globalgamejam.org/2015/games/checkers-hell

Diversifiers used: 
*Noise generator* - The mechanic of the game is based on players having to stay in constant communication with each other.


## Software used:
* haxe, haxeFlixel, Nape
* FlashDevelop, Gimp, Firefox
* git, babun (preconfigured cygwin shell under windows)
* Resources: cgTextures,  cheri liney font (free for personal use), music "Silver UFOs" by "Spinning Clocks" (free jazz tune)
* based on haxe demo http://haxeflixel.com/demos/MouseEventManager/

## Credits: 
Hubert "Koshmaar" Rutkowski

I spent 6h from the weekend on another event (company party), wasted about 3.5 hours trying to run game on android tablet/phone (recent bug commited to haxe made this impossible), and spent also quite a lot of time learning Haxe and some libraries, installing compiler and tools (first use of Gimp after years), configuring laptop and babun... so bearing this all in mind, I'm quite happy with the resultant game.

## Changelog

25 january - Version 1.0 - Jam version
* checkers logic
* music
* works!

Versions improved after jam:

26 january Version 1.1
* moves are counted only if they are correct
* can't kill own pieces
* music shortened and compressed

Version 1.2
* pieces have small shadow, they appear to be higher when dragged


## TODO

- implement queen and fix bug (long move only in 2 to 7 o clock direction)
- add simple AI based on minmax
- add score counting
- maybe menu, maybe short in-game explanation
- more visual polish? and sounds?
- test on android, add multitouch capabilities

## License

Attribution-Noncommercial-Share Alike 3.0 version of the Creative Commons License: http://creativecommons.org/licenses/by-nc-sa/3.0/

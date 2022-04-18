# seigaiha
A simple norns script that plays arpeggios while drawing a seigaiha pattern on the screen.

### recommended listening
Set the clock to between 80 and 120 bpm, add some reverb and maybe play a field recording in the norns tape.

### how it works
The step function uses the MusicUtil library to select a chord at random from the pentatonic scale with a random root note. It then waits until the next sync quantum of 4 beats before it plays the notes in that chord using the polyperc engine with a half beat pause between each note. The process is then repeated with a new chord played each time.

To draw the pattern a table 'bows' is used which can contain up to 36 rainbows to draw on the screen. The step function finds an empty slot when choosing a new chord and as the notes are played the value of that rainbow in the bows table increases from 0 to 1. The redraw function loops through the table and calculates the x and y coordinates for each rainbow before drawing them as 4 arcs.

### extending the script
The following are a few suggestions to add functionality to the script. The awake script does a lot of these and is a great resource.

- add some engine options (release, cutoff, pw etc) and the scale as params so they can be altered and saved as presets
- change how fast the notes are played or how long the pause is after each chord. Add rests, a chance of not playing a note - make it more musical (or less)! 
- select a handful of root notes when the script starts and only use those or use the sequins library to repeat a pattern
- add some softcut effects like the awake halfsecond delay
- output midi or crow, switch in a different engine or write your own
- draw a different pattern by exploring the screen library - lines, circles, the world is your geometric oyster

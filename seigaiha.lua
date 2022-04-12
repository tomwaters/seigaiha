-- seigaiha
engine.name = 'PolyPerc'
MusicUtil = require "musicutil"
scale = MusicUtil.SCALES[11]

bows = {}
counter = 0
max = 36
root_note = 43

function init()
  engine.release(3)
  engine.pw(0.6)
  clock.run(step)
end

function update()
  redraw()
end

function step()
  while true do
    -- if screen is full, restart
    if counter == max then
      bows = {}
      counter = 0
    end

    -- find an unused rainbow
    bow = nil
    repeat
      bow = math.random(max) - 1
    until bows[bow] == nil
    bows[bow] = 0
    counter = counter + 1

    -- select a random chord from the scale and play through the notes
    chord_idx = math.random(#scale.chords[1])
    chord = MusicUtil.CHORDS[scale.chords[1][chord_idx]]
    chord_root = root_note + scale.intervals[math.random(#scale.intervals)]
    for i=1, #chord.intervals do
      clock.sync(0.5)
      freq = MusicUtil.note_num_to_freq(chord_root + chord.intervals[i])
      engine.hz(freq)
      
      bows[bow] = bows[bow] + (1 / #chord.intervals)
      redraw()
    end
    
    clock.sync(4)
  end
end

function redraw()
  radius = 10
  screen.clear()  
  screen.aa(1)
  
  for b = 0, max - 1 do
    if bows[b] ~= nil then
      x = (b % 6 * ((radius * 2) + 1)) + 2
      y = ((math.floor(b / 6) + 1) * (radius - 1) + 2)
      
      if y % 2 > 0 then x = x - radius - 1 end
      
      -- loop for first rainbow on alt rows that repeats at start and end of row
      while true do
        screen.move(x, y)
        for i=0, radius / 3 do
          screen.arc(x + radius, y, radius - (i * 2), math.pi, math.pi + (math.pi * bows[b]))
          screen.stroke()
        end
        if x < 0 then x = 128 - radius else break end
      end
    end
  end
  
  screen.update()
end
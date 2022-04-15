-- seigaiha delay
engine.name = 'PolyPerc'
MusicUtil = require "musicutil"
scale = MusicUtil.SCALES[11]

bows = {}
counter = 0
max = 36
root_note = 43

function init()
  engine.release(4)
  engine.pw(0.6)
  scinit()
  clock.run(step)
end

function scinit()
  audio.level_cut(1.0)
  audio.level_adc_cut(0)
  audio.level_eng_cut(1)

  for i=1,2 do
    softcut.enable(i, 1)
    softcut.play(i, 1)
    softcut.loop(i, 1)
    softcut.rec(i, 1)
    
    softcut.level(i, 0.9)
    softcut.level_input_cut(1, i, 1.0)
	softcut.level_input_cut(2, i, 1.0)
    
  	softcut.loop_start(i, 1)
  	softcut.loop_end(i, 3)
  	softcut.position(i, 1)
  	
  	softcut.rec_level(i, 1)
  	softcut.pre_level(i, 0.65)
  	
  	softcut.filter_dry(i, 0.075);
  	softcut.filter_fc(i, 1800);
  	softcut.filter_lp(i, 0);
  	softcut.filter_bp(i, 1.0);
  	softcut.filter_rq(i, 2.0);
  end
    
  softcut.pan(1, -1.0)
  softcut.pan(2, 1.0)
  softcut.rate(1, 1.25)
  softcut.rate(2, 2)
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
    clock.sync(8)
    for i=1, #chord.intervals do
      freq = MusicUtil.note_num_to_freq(chord_root + chord.intervals[i])
      engine.hz(freq)
      
      bows[bow] = bows[bow] + (1 / #chord.intervals)
      redraw()
      clock.sync(0.5)      
    end
  end
end

function redraw()
  radius = 10
  margin = 2
  screen.clear()  
  screen.aa(1)
  
  for b = 0, max - 1 do
    if bows[b] ~= nil then
      x = (b % 6 * ((radius * 2) + 1)) + margin
      y = ((math.floor(b / 6) + 1) * (radius - 1) + margin)

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
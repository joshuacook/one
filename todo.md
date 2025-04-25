# **jf_looper Development Task List**

> *All tasks are written for a Norns 3.0 environment with a Monome Grid 128 in portrait orientation.*

---

## 1  Wire BPM param to clock
- **Read param on init** – replace the temporary hard-coded `120` with `params:get("bpm")` in both the Softcut length calculation and the `clock.sync` metro.
- **Hot-update listener** – create a `params.action` callback so changing BPM from the PARAMS menu restarts the transport at the new rate.
- **UI refresh** – forward BPM changes to the progress-ring tick so visual timing stays locked.

## 2  Implement Softcut record routine
- **`arm_record(v)` helper** – clear buffer, set `position 0`, enable `rec 1` & `play 1`.
- **Quantised start/stop** – use `clock.sync(1)` to launch on next bar 1 and `clock.sync(16)` to auto-stop.
- **Fade ramp** – apply `softcut.fade_time(v, params:get("fade_ms")/1000)` before start & stop calls.

## 3  Play/mute level logic
- **Mute** – store current level in table, then `softcut.level(v,0)`.
- **Unmute** – restore stored level.
- **LED feedback** – ensure LED state changes immediately when toggled.

## 4  Persist WAV buffers on save
- **File naming** – `000.wav … 005.wav` (three-digit, zero-padded).
- **Write mono** – `softcut.buffer_write_mono(dir..fn, 0, len)` for active loops only.
- **Error handling** – guard against I/O failures and show a screen message if save fails.

## 5  XML load / deserialize
- **Parse XML** – extend `lubxml` with a very small loader or swap in `xml2lua`.
- **Load WAVs** – for each `<loop>` node load file into buffer with `softcut.buffer_read_mono`.
- **Restore params** – level, mute state, and pointer positions.

## 6  Project chooser UI
- **List directory names** – read `dust/data/jf_looper/projects/`.
- **Encoder navigation** – scroll list with E2/E3, press K3 to load.
- **Safety prompt** – confirm overwrite if unsaved changes exist.

## 7  Autosave daemon
- **Param toggle** – `autosave_interval` (0 = off, 32 = every two cycles, etc.).
- **Background clock thread** – `clock.run` that waits `interval` bars and invokes `save_current()`.
- **Visual cue** – brief screen flash or message when autosave succeeds.

## 8  Grid rotation test & polish
- **Test all four rotations** – verify logical → physical mapping for tap, hold, and faders.
- **Persist setting** – ensure `grid_rot` is written to PARAM file.
- **Doc** – add a troubleshooting tip for users whose grid appears wired incorrectly.

## 9  MIDI clock out
- **24 PPQN timer** – call `midi_device:clock()` every `clock.get_beat_sec()/24` seconds.
- **Start/Stop** – send `:start()` on K2 play, `:stop()` on K2 stop or K3 panic.
- **Device selector** – PARAM pick-list populated from `midi.vports`.

## 10  CPU / buffer safety checks
- **Max length guard** – prevent total buffered audio from exceeding ~180 sec stereo.
- **Panic clear** – K3 panic flushes buffers and resets states to EMPTY.
- **Warning overlay** – notify user if RAM limit is approached.

## 11  README update & license
- **Key & LED legend** – diagram for quick reference.
- **Install instructions** – `scp` or Maiden drag-and-drop; requires Norns 2.8+.
- **License** – MIT or GPL-3, depending on contribution preferences.

---
*Last updated {DATE}*
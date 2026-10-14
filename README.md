# Clarity Bar

**Clarity Bar** is a QuickShell (Wayland) panel for Arch/Hyprland, built as the successor bar for the Clarity workstation.

It is a per-module desktop bar using a shared Grok-inspired aesthetic (`Hero.qml`, `PanelBox`, `BarChip`) and one `Bar.qml` composition per monitor.

## Modules

- Weather (wttr.in; auto-IP or pinned coords)
- Clock (+ monthly calendar flyout)
- Anvil (host metrics)
- CPU
- GPU
- Memory
- IP
- Volume
- Voice (Whisper PTT + typing injection)
- AI status
- Notes (flyout)

Modules can be ordered/reordered in `Bar.qml`.

## Run

```bash
quickshell -d -c clarity-bar
```

`~/.config/quickshell/clarity-bar` -> `/home/warpuppy/Projects/ClarityBar`

## Launchers

- `voice-ptt.py` — runs Faster-Whisper, types text via wtype/xdotool.
- `voice-ptt-flyout.py` — flyout panel (top-right beneath voice chip).
- `voice-ptt-last.txt`, `voice-ptt-history.txt`, `/tmp/voice-ptt.state`.

## Config

- `~/.config/voice-ptt.json` (`model`, `threads`, `language`, `typing_delay_ms`).
- default model: `tiny.en` (small model too slow on this host).

## Notes

- Grok module intentionally disabled by user preference.
- See `Infrastructure-Facts.md` / project vault for monitor mapping: LG primary, AOC secondary.

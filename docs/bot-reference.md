# MiniHotKeysHider - bot reference

Version 1.1.7. Interface versions: 120100, 50504, 40402, 38002, 38000,
30405, 30300, 20506, 11509 (retail plus the classic client lines). Saved
variables: MiniHotKeysHiderDB (per character).

## What it does

Hides the hotkey text and the macro name text on the default action bars for
a cleaner look. That is its only job.

## How it works

- Sets the HotKey and Name font strings to alpha 0 on buttons 1-12 of:
  ActionButton, MultiBarBottomLeftButton, MultiBarBottomRightButton,
  MultiBarRightButton, MultiBarLeftButton, MultiBar5Button, MultiBar6Button,
  MultiBar7Button, and PetActionButton.
- Applies shortly after entering the world (deferred one frame so the change
  sticks).
- When you untick the option the text is restored to full alpha, but only if
  this addon was the one that hid it, to avoid fighting other addons that
  manage hotkey text.
- Only the default Blizzard bars are affected; custom bar addons are not.

## Settings

Options -> AddOns -> MiniHotKeysHider. There are no slash commands.

| Setting | Type | Default | Effect |
|---|---|---|---|
| Hide Character HotKeys | checkbox | on | Hides hotkey and macro name text on the default action bars for this character. Applies immediately on click. |

The setting is saved per character.

## Troubleshooting

- "Hotkeys are hidden on one character but not another": the setting is per
  character; toggle it on each character.
- "It doesn't hide my Bartender/Dominos/ElvUI bars": only the default
  Blizzard action bars are supported.
- "Macro names disappeared too": intended; the addon hides both hotkey text
  and macro name text together, there is no separate toggle.

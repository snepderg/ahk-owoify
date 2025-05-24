# Clipboard Owoifier (ahk-owoify)

Clipboard Owoifier is an AutoHotkey v2 script that transforms ("Owoifies") selected text in any application, such as Discord, by applying playful text modifications. It supports toggling features like forced lowercase, stuttering, and appending cute phrases after punctuation.

Made using AutoHotKey V2 ❤

* Use at your own peril. Some people may find you annoying, so try to be polite.

## Features

- Owoifies selected text with fun transformations
- Adds random cute appends after punctuation
- Optional stuttering effect
- Option to force all text to lowercase
- Special handling for Discord code blocks
- Easy-to-use hotkeys for toggling features
**Restores your clipboard after processing, so your original clipboard content is preserved**

## Hotkeys

- **CTRL+ALT+O**: Owoify selected text
- **CTRL+ALT+L**: Toggle forced lowercase
- **CTRL+ALT+S**: Toggle stutter
- **CTRL+ALT+A**: Toggle appends after punctuation
- **CTRL+ALT+H**: Show help message

## Usage

1. Download and install [AutoHotkey v2](https://www.autohotkey.com/).
2. Run `clipboard_owoifier.ahk`.
3. Select text in any application.
4. Press `CTRL+ALT+O` to Owoify the selected text.

## Configuration

You can adjust the following settings at the top of [`clipboard_owoifier.ahk`](clipboard_owoifier.ahk):

- `stutterChance`: Controls how often stuttering occurs (higher = less frequent).
- `isLowercase`: Force all output to lowercase.
- `stutterEnabled`: Enable/disable stuttering.
- `appendsEnabled`: Enable/disable appends after punctuation.

## Logging

Errors and events are logged to `owo_dev.log` in the script directory.

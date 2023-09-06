## Installation

### From Source Code

1. Clone this repository or download the source code.
2. Open Terminal and navigate to the directory containing the source code.
3. Compile the Swift code:
    ```bash
    swiftc -o RemoveDoublePresses.app/Contents/MacOS/RemoveDoublePresses KeyFilter.swift
    ```
4. Move the `Info.plist` file to `RemoveDoublePresses.app/Contents/`:
    ```bash
    mv Info.plist RemoveDoublePresses.app/Contents/
    ```
5. Double-click `RemoveDoublePresses.app` to run or use `open RemoveDoublePresses.app` from Terminal.

## Permissions

The app needs accessibility permissions to monitor key events. On the first run, it will ask for the necessary permissions.

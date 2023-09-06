## Installation

### From Source Code

1. Clone this repository or download the source code.
2. Open the `KeyFilter.swift` file in a text editor and set the `targetKeyCode` to the key code you want to filter. For example, 38 is for the "j" key.
    ```swift
    let targetKeyCode: CGKeyCode = 38  // Change this to set the targeted key. 38 is for "j"
    ```
3. Save the file and close the text editor.
4. Open Terminal and navigate to the directory containing the source code.
5. Compile the Swift code:
    ```bash
    swiftc -o RemoveDoublePresses.app/Contents/MacOS/RemoveDoublePresses KeyFilter.swift
    ```
6. Move the `Info.plist` file to `RemoveDoublePresses.app/Contents/`:
    ```bash
    mv Info.plist RemoveDoublePresses.app/Contents/
    ```
7. Double-click `RemoveDoublePresses.app` to run or use `open RemoveDoublePresses.app` from Terminal.

## Permissions

The app needs accessibility permissions to monitor key events. On the first run, it will ask for the necessary permissions.

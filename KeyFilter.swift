import Cocoa

let threshold: UInt64 = 100_000_000  // 100 milliseconds in nanoseconds
var lastKeyPressTime = DispatchTime.now()

func eventTapCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    if type == .keyDown {
        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
        if keyCode == 38 {  // 38 is the virtual key code for "j"
            let currentTime = DispatchTime.now()
            let elapsedTime = currentTime.uptimeNanoseconds - lastKeyPressTime.uptimeNanoseconds
            
            if elapsedTime >= threshold {
                lastKeyPressTime = currentTime
                return Unmanaged.passRetained(event)
            } else {
                return nil
            }
        }
    }
    return Unmanaged.passRetained(event)
}

// Request Accessibility Permissions
if !AXIsProcessTrustedWithOptions(["AXTrustedCheckOptionPrompt": true] as NSDictionary) {
    let alert = NSAlert()
    alert.messageText = "This app needs accessibility permissions."
    alert.runModal()
}

// Check and Add to User Startup Items using AppleScript
let checkScript = """
tell application "System Events"
    set isPresent to false
    repeat with aItem in login items
        if name of aItem is "RemoveDoublePresses" then
            set isPresent to true
            exit repeat
        end if
    end repeat
    isPresent
end tell
"""

let addScript = """
tell application "System Events"
    make new login item at end with properties {path:"\(Bundle.main.bundlePath)", hidden:false}
end tell
"""

if let checkScriptObject = NSAppleScript(source: checkScript) {
    var errorDict: NSDictionary? = nil
    let output = checkScriptObject.executeAndReturnError(&errorDict)
    if let error = errorDict {
        print("Error checking startup item: \(error)")
    } else {
        if output.booleanValue == false {
            if let addScriptObject = NSAppleScript(source: addScript) {
                addScriptObject.executeAndReturnError(&errorDict)
                if let error = errorDict {
                    print("Error adding startup item: \(error)")
                }
            }
        }
    }
}

// Setup Event Tap
let eventMask = (1 << CGEventType.keyDown.rawValue)
guard let eventTap = CGEvent.tapCreate(tap: .cghidEventTap, place: .headInsertEventTap, options: .defaultTap, eventsOfInterest: CGEventMask(eventMask), callback: eventTapCallback, userInfo: nil) else {
    print("Failed to create event tap")
    exit(1)
}

let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
CGEvent.tapEnable(tap: eventTap, enable: true)

// Run Loop
CFRunLoopRun()

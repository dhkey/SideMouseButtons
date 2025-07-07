//
//  ButtonsEmulator.swift
//  SideMouseButtons
//
//  Created by Denis Yazan on 08.07.2025.
//

import Cocoa

func switchDesktop(direction: String) {
    let keyCode: Int
    switch direction {
    case "right":
        keyCode = 124 // →
    case "left":
        keyCode = 123 // ←
    default:
        return
    }
    
    let script = """
    tell application "System Events"
        launch
        key code \(keyCode) using control down
    end tell
    """

    if let appleScript = NSAppleScript(source: script) {
        var error: NSDictionary?
        appleScript.executeAndReturnError(&error)

        if let error = error {
            print("AppleScript error: \(error)")
        }
    }
}

//
//  ContentView.swift
//  SideMouseButtons
//
//  Created by Denis Yazan on 07.07.2025.
//

import Cocoa

class GlobalMouseMonitor {
    private var monitor: Any?

    init() {
        checkAccessibilityPermissions()
        setupMouseMonitor()
    }

    func checkAccessibilityPermissions() {
        let checkOptPrompt = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString
        let options = [checkOptPrompt: true]
        let granted = AXIsProcessTrustedWithOptions(options as CFDictionary)
    }

    func setupMouseMonitor() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: [.otherMouseDown]) { event in
            switch event.buttonNumber {
            case 3:
                switchDesktop(direction: "right")
            case 4:
                switchDesktop(direction: "left")
            default:
                break
            }
        }
    }

    deinit {
        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
        }
    }
}

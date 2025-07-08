//
//  GlobalMouseMonitor.swift
//  SideMouseButtons
//
//  Created by Denis Yazan on 08.07.2025.
//
import Cocoa

class GlobalMouseMonitor {
    private var eventTap: CFMachPort?
    private(set) var isRunning = false
    
    init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        guard !isRunning else { return }
        
        if !AXIsProcessTrusted() {
            requestAccessibilityPermissions()
            return
        }
        
        let eventMask = (1 << CGEventType.otherMouseDown.rawValue) | (1 << CGEventType.otherMouseUp.rawValue)
        
        eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
                let monitor = Unmanaged<GlobalMouseMonitor>.fromOpaque(refcon!).takeUnretainedValue()
                return monitor.handleEvent(proxy: proxy, type: type, event: event)
            },
            userInfo: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        )
        
        guard let eventTap = eventTap else {
            print("Failed to create event tap")
            return
        }
        
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        
        CGEvent.tapEnable(tap: eventTap, enable: true)
        
        isRunning = true
        print("Mouse monitor started")
    }
    
    private func handleEvent(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent) -> Unmanaged<CGEvent>? {
        switch type {
        case .otherMouseDown:
            let buttonNumber = event.getIntegerValueField(.mouseEventButtonNumber)
            
            switch buttonNumber {
            case 3:
                switchDesktop(direction: "left")
                return nil
            case 4:
                switchDesktop(direction: "right")
                return nil
            default:
                break
            }
            
        case .otherMouseUp:
            let buttonNumber = event.getIntegerValueField(.mouseEventButtonNumber)
            
            if buttonNumber == 3 || buttonNumber == 4 {
                return nil
            }
            
        case .tapDisabledByTimeout:
            if let eventTap = eventTap {
                CGEvent.tapEnable(tap: eventTap, enable: true)
            }
            
        default:
            break
        }
        
        return Unmanaged.passUnretained(event)
    }
    
    func stopMonitoring() {
        guard isRunning else { return }
        
        if let eventTap = eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
            CFMachPortInvalidate(eventTap)
            self.eventTap = nil
        }
        
        isRunning = false
        print("Mouse monitor stopped")
    }
    
    private func requestAccessibilityPermissions() {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "Accessibility Permission Required"
            alert.informativeText = "This app needs accessibility permissions to intercept mouse button events. Please enable it in System Preferences > Security & Privacy > Accessibility, then restart the app."
            alert.addButton(withTitle: "Open System Preferences")
            alert.addButton(withTitle: "Cancel")
            
            if alert.runModal() == .alertFirstButtonReturn {
                NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!)
            }
        }
    }
    
    deinit {
        stopMonitoring()
    }
}

func switchDesktop(direction: String) {
    let keyCode: Int
    switch direction {
    case "right":
        keyCode = 124
    case "left":
        keyCode = 123
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

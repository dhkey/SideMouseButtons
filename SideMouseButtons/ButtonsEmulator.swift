//
//  EventInterceptor.swift
//  SideMouseButtons
//
//  Created by Denis Yazan on 08.07.2025.
//
import Cocoa

class EventInterceptor {
    private var eventTap: CFMachPort?
    
    func startIntercepting() {
        guard AXIsProcessTrusted() else {
            print("Accessibility permissions required")
            return
        }
        
        let eventMask = (1 << CGEventType.otherMouseDown.rawValue) | (1 << CGEventType.otherMouseUp.rawValue)
        
        eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
                return EventInterceptor.handleEvent(proxy: proxy, type: type, event: event, refcon: refcon)
            },
            userInfo: nil
        )
        
        guard let eventTap = eventTap else {
            print("Failed to create event tap")
            return
        }
    
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)

        CGEvent.tapEnable(tap: eventTap, enable: true)
        
        print("Event interceptor started")
    }
    
    private static func handleEvent(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
        
        switch type {
        case .otherMouseDown:
            let buttonNumber = event.getIntegerValueField(.mouseEventButtonNumber)
            
            switch buttonNumber {
            case 3:
                switchDesktop(direction: "right")
                return nil
            case 4:
                switchDesktop(direction: "left")
                return nil
            default:
                break
            }
            
        case .otherMouseUp:
            let buttonNumber = event.getIntegerValueField(.mouseEventButtonNumber)
            
            if buttonNumber == 3 || buttonNumber == 4 {
                return nil
            }
            
        default:
            break
        }
        
        return Unmanaged.passUnretained(event)
    }
    
    func stopIntercepting() {
        if let eventTap = eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
            CFMachPortInvalidate(eventTap)
            self.eventTap = nil
            print("Event interceptor stopped")
        }
    }
    
    deinit {
        stopIntercepting()
    }
}


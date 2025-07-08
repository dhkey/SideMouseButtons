//
//  AppDelegate.swift
//  SideMouseButtons
//
//  Created by Denis Yazan on 08.07.2025.
//
import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var mouseMonitor: GlobalMouseMonitor?
    var showMenuItem: NSMenuItem?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        createStatusItem()
        mouseMonitor = GlobalMouseMonitor()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        mouseMonitor?.stopMonitoring()
    }
    
    func createStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "arrow.left.and.right", accessibilityDescription: "Switch Desktop")
        }
        
        let menu = NSMenu()
        
        // Add toggle for monitoring
        let monitorMenuItem = NSMenuItem(title: "Toggle Monitoring", action: #selector(toggleMonitoring), keyEquivalent: "m")
        menu.addItem(monitorMenuItem)
        
        showMenuItem = NSMenuItem(title: "Hide icon", action: #selector(toggleStatusIcon), keyEquivalent: "h")
        menu.addItem(showMenuItem!)
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Exit", action: #selector(quit), keyEquivalent: "q"))
        
        statusItem?.menu = menu
    }
    
    @objc func toggleMonitoring() {
        guard let monitor = mouseMonitor else { return }
        
        if monitor.isRunning {
            monitor.stopMonitoring()
            statusItem?.button?.image = NSImage(systemSymbolName: "arrow.left.and.right.slash", accessibilityDescription: "Monitoring Disabled")
        } else {
            monitor.startMonitoring()
            statusItem?.button?.image = NSImage(systemSymbolName: "arrow.left.and.right", accessibilityDescription: "Switch Desktop")
        }
    }
    
    @objc func toggleStatusIcon() {
        if statusItem != nil {
            NSStatusBar.system.removeStatusItem(statusItem!)
            statusItem = nil
        } else {
            createStatusItem()
        }
    }
    
    @objc func quit() {
        mouseMonitor?.stopMonitoring()
        NSApplication.shared.terminate(nil)
    }
}

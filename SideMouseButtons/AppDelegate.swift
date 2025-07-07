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

    func createStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "arrow.left.and.right", accessibilityDescription: "Switch Desktop")
        }
        let menu = NSMenu()
        showMenuItem = NSMenuItem(title: "Hide icon", action: #selector(toggleStatusIcon), keyEquivalent: "h")
        menu.addItem(showMenuItem!)
        menu.addItem(NSMenuItem(title: "Exit", action: #selector(quit), keyEquivalent: "q"))
        statusItem?.menu = menu
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
        NSApplication.shared.terminate(nil)
    }
}

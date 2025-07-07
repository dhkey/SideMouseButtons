//
//  menu.swift
//  SideMouseButtons
//
//  Created by Denis Yazan on 08.07.2025.
//

import Cocoa

class StatusBarController {
    private var statusItem: NSStatusItem

    init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "arrow.left.and.right", accessibilityDescription: "Switch Desktop")
        }
        constructMenu()
    }

    private func constructMenu() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Вийти", action: #selector(quit), keyEquivalent: "q"))
        statusItem.menu = menu
    }

    @objc func quit() {
        NSApplication.shared.terminate(nil)
    }
}

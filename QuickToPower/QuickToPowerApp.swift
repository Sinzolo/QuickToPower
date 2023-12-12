//
//  QuickToPowerApp.swift
//  QuickToPower
//
//  Created by Melchizedek Gray on 12/12/2023.
//

import SwiftUI

@main
struct QuickToPowerApp: App {
    
    @State var isLowPowerModeEnabled: Bool = ProcessInfo.processInfo.isLowPowerModeEnabled
    @State var menuBarIcon: String = ProcessInfo.processInfo.isLowPowerModeEnabled ? "tortoise.fill" : "hare.fill"

    var body: some Scene {
        MenuBarExtra("QuickToPower", systemImage: menuBarIcon) {
            ContentView(isLowPowerModeEnabled: $isLowPowerModeEnabled, menuBarIcon: $menuBarIcon)
        }
    }
}

//
//  ContentView.swift
//  QuickToPower
//
//  Created by Melchizedek Gray on 12/12/2023.
//

import SwiftUI

struct ContentView: View {
    
    @Binding var isLowPowerModeEnabled: Bool
    @Binding var menuBarIcon: String

        func toggleLowPowerMode() {
            let process = Process()
            process.launchPath = "/usr/bin/osascript"
            if isLowPowerModeEnabled {
                process.arguments = ["-e", "do shell script \"sudo pmset -a lowpowermode 0\" with prompt \"QuickToPower wants to disable Low Power Mode\" with administrator privileges"]
            }
            else {
                process.arguments = ["-e", "do shell script \"sudo pmset -a lowpowermode 1\" with prompt \"QuickToPower wants to enable Low Power Mode\" with administrator privileges"]
            }
            process.launch()
            process.waitUntilExit()
            isLowPowerModeEnabled = ProcessInfo.processInfo.isLowPowerModeEnabled
            toggleMenuBarIcon()
        }
    
    func toggleMenuBarIcon() {
        menuBarIcon = isLowPowerModeEnabled ? "tortoise.fill" : "hare.fill"
    }
    
    func quit() {
        NSApplication.shared.terminate(nil)
    }
    
    var body: some View {
        Button(action: toggleLowPowerMode) {
            HStack {
                if isLowPowerModeEnabled {
                    Image(systemName: "tortoise.fill")
                    Text("Low Power Mode: On")
                }
                else {
                    Image(systemName: "hare.fill")
                    Text("Low Power Mode: Off")
                }
            }
        }
        Button(action: quit) {
            HStack {
                Image(systemName: "xmark")
                Text("Quit")
            }
        }
    }
}

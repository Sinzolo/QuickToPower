//
//  ContentView.swift
//  QuickToPower
//
//  Created by Melchizedek Gray on 12/12/2023.
//

import SwiftUI
import IOKit.ps     // Used to check charge state

struct ContentView: View {
    
    @Binding var isLowPowerModeEnabled: Bool
    @Binding var menuBarIcon: String
    @State var isCharging: Bool = false

    /**
     Toggles low power mode.
     */
    func toggleLowPowerMode() {
        isCharging = getIsCharging()
        // If charging, ask them if they still want to turn it on.
        if isCharging && !isLowPowerModeEnabled {
            let alert = NSAlert()
            alert.messageText = "Are you sure you want to enable Low Power Mode while your laptop is plugged in?"
            alert.informativeText = "Low Power Mode can reduce performance when the laptop is connected to a power source."
            alert.addButton(withTitle: "Enable Low Power Mode")
            alert.addButton(withTitle: "Cancel")

            // If they press cancel, return
            if (alert.runModal().rawValue == 1001) {
                return
            }
        }
        
        let action = isLowPowerModeEnabled ? "disable" : "enable"
        let prompt = "QuickToPower wants to \(action) Low Power Mode"
        let scriptCommand = "sudo pmset -a lowpowermode \(isLowPowerModeEnabled ? 0 : 1)"
        _ = runScript(command: scriptCommand, prompt: prompt, adminPriv: false)
        /// ** If execution fails due to needing elavated permisions, set adminPriv to true **
        /// I found a way online that allows sudo to accept my fingerprint instead of asking for a password
        /// everytime. This means that adminPriv can be set to false and sudo will automatically ask me for
        /// my fingerprint. When true, it instead asks for password.
        /// Edit sudo using the command:
        /// sudo vi /etc/pam.d/sudo
        /// Then add the line:
        /// auth sufficient pam_tid.so
        /// at the top of the file._
        /// You'll probs have to google how to use vi.
        /// Then come back here and change adminPriv to false and it should ask for your fingerpint instead.

        isLowPowerModeEnabled = ProcessInfo.processInfo.isLowPowerModeEnabled
        updateMenuBarIcon()
    }
    
    /**
     Runs a terminal command using AppleScript and returns the output if there is one.
     - parameter command: command to run as type String
     - parameter prompt: prompt to show the user if admin privilages are requested as type String
     - parameter adminPriv: true if admin privilages are needed as type Bool
     - returns: String of output or nil if no output.
     */
    func runScript(command: String, prompt: String?, adminPriv: Bool) -> String? {
        let updatedPrompt = (prompt != nil) ? " with prompt \"" + prompt! + "\"" : ""
        let updatedAdmin = adminPriv ? " with administrator privileges" : ""
        let finalScript = " \"" + command + "\"" + updatedPrompt + updatedAdmin

        let process = Process()
        process.launchPath = "/usr/bin/osascript"
        process.arguments = ["-e", "do shell script" + finalScript]
        let pipe = Pipe()   // Pipe used to grab the output
        process.standardOutput = pipe
        process.launch()
        process.waitUntilExit()

        // Grabs the output and returns it
        guard let data = try? pipe.fileHandleForReading.readToEnd() else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /**
     Returns true if the device is getting power from AC power and false if battery power.
     This function will return true even if not charging but connected to AC power.
     - returns: a boolean. True if AC power, false otherwise.
     */
    func getIsCharging() -> Bool {
        let info = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let sources = IOPSCopyPowerSourcesList(info).takeRetainedValue() as [CFTypeRef]
        if let batterySource = sources.first {
            //Print pSource to see details about charge state
            let pSource = IOPSGetPowerSourceDescription(info, batterySource).takeUnretainedValue() as NSDictionary
            return pSource[kIOPSPowerSourceStateKey] as? String == "AC Power" ? true : false
        }
        return false
    }
    
    /**
     Updates the menu bar icon depending on whether low power mode is active.
     */
    func updateMenuBarIcon() {
        menuBarIcon = isLowPowerModeEnabled ? "tortoise.fill" : "hare.fill"
    }
    
    /**
     Quits the application
     */
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

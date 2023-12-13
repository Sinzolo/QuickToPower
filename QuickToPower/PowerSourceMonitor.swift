
/// Trying to figure out how to update the app automatically when the device starts charging


//import Foundation
//import IOKit.ps.IOPowerSources
//
//class PowerSourceMonitor {
//    private let runLoopSource: CFRunLoopSourceRef
//
//    init() {
//        let runLoopSource = IOPSNotificationCreateRunLoopSource(powerSourceChangeNotificationCallback) { (context) in
//            self.handlePowerSourceChange()
//        }
//        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopDefaultMode)
//
//        self.runLoopSource = runLoopSource
//    }
//
//    private func handlePowerSourceChange() {
//        // Get the latest power source information
//        let powerSources = IOPSCopyPowerSourcesInfo()
//        defer { CFRelease(powerSources) }
//
//        // Update the UI or take other actions based on the new power source information
//    }
//
//    func startMonitoring() {
//        CFRunLoopRunInMode(kCFRunLoopDefaultMode, .maxDuration, false)
//    }
//
//    func stopMonitoring() {
//        CFRunLoopRemoveSource(CFRunLoopGetCurrent(), self.runLoopSource, kCFRunLoopDefaultMode)
//        CFRunLoopStop(CFRunLoopGetCurrent())
//    }
//}

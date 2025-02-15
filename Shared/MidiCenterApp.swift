//
//  MidiCenterApp.swift
//  Shared
//
//  Created by Tristan Leblanc on 27/12/2020.
//

import SwiftUI
import SwiftMidiCenter

@main
struct MidiCenterApp: App {
    
    var midiCenter: MidiCenter { MidiCenter.shared }
    
    var body: some Scene {

        WindowGroup("MidiCenter") {
            MidiCenterAppView().environmentObject(midiCenter)
        }
        .commands {
            MidiCenterCommands()
        }
    }
}

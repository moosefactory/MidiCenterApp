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
    //@ObservedObject var midiCenter = MidiCenter()
    
    var midiCenter: MidiCenter { MidiCenter.shared }
    
    var body: some Scene {
//        DocumentGroup(newDocument: MidiCenterDocument()) { file in
//            ProjectView(document: file.$document)
//        }
        WindowGroup("MidiCenter") {
            MidiCenterAppView().environmentObject(midiCenter)
        }
        .commands {
            MidiCenterCommands()
        }
    }
}

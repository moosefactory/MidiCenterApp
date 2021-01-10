//
//  MidiCenterCommands.swift
//  MidiCenterApp
//
//  Created by Tristan Leblanc on 28/12/2020.
//

import SwiftUI
import SwiftMidiCenter

struct MidiCenterCommands: Commands {
    
    var body: some Commands {
        CommandMenu("MidiCenter") {
            Section {
                Button("Reset") {
                    resetMidiCenter()
                }
            }
        }
    }
    
    private func resetMidiCenter() {
        do {
            try MidiCenter.shared.reset()
        } catch {
            print(error)
        }
    }
}

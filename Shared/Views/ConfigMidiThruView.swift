//
//  MidiThruView.swift
//  MidiCenterApp
//
//  Created by Tristan Leblanc on 28/12/2020.
//

import SwiftUI
import SwiftMidiCenter

struct ConfigMidiThruView: View {
    // The document midi configuration
    @ObservedObject var midiConfig: MidiConfiguration

    // Document midi thru
    @ObservedObject var midiThru: MidiConnection
    
    private var inputs: [UsedMidiInput] { midiConfig.inputs }

    var body: some View {
        VStack {
            ConfigMidiInputView(midiConfig: midiConfig, midiWire: midiThru)
            ConfigMidiOutputView(midiConfig: midiConfig, midiWire: midiThru)
        }
    }
}

struct ConfigMidiThruView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigMidiThruView(midiConfig: MidiConfiguration.test, midiThru: MidiConnection.test)
    }
}

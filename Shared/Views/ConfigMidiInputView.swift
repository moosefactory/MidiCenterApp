//
//  MidiInputView.swift
//  MidiCenterApp
//
//  Created by Tristan Leblanc on 27/12/2020.
//

import SwiftUI
import SwiftMidiCenter

struct ConfigMidiInputView: View {
    
    @ObservedObject var midiConfig: MidiConfiguration
    
    var midiWire: MidiConnection?
    
    private var inputs: [UsedMidiInput] { midiConfig.inputs }
    
    var body: some View {
        
        let menuInputs = [UsedMidiInput.none] + inputs
        
        GroupBox(label: Label("Input", systemImage: "pianokeys")) {
            Menu("Port") {
                ForEach(menuInputs, id: \.self) { input in
                    Button(input.name) {
                        //midiWire?.sourceRef = input.ref
                    }
                    .disabled(!input.isAvailable)
                    .opacity(input.isAvailable ? 1 : 0.5)
                    
                }
            }
        }.padding(/*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
}

#if DEBUG
struct ConfigMidiInputView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigMidiInputView(midiConfig: MidiConfiguration.test)
    }
}
#endif

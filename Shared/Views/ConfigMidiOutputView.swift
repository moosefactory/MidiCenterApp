//
//  MidiOutputView.swift
//  MidiCenterApp
//
//  Created by Tristan Leblanc on 28/12/2020.
//


import SwiftUI
import SwiftMidiCenter

struct ConfigMidiOutputView: View {
    
    @ObservedObject var midiConfig: MidiConfiguration
    
    var midiWire: MidiConnection?

    private var outputs: [UsedMidiInput] { midiConfig.outputs }
    
    var body: some View {
        
        let menuOutputs = [UsedMidiInput.none] + outputs
        
        GroupBox(label: Label("Output", systemImage: "pianokeys")) {
            Menu("Port") {
                ForEach(menuOutputs, id: \.self) { output in
                    Button(output.name) {
                        //midiWire?.destRef = output.ref
                    }.disabled(!output.isAvailable)
                }
            }
        }.padding(/*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
}

#if DEBUG
struct MidiOutputView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigMidiOutputView(midiConfig: MidiConfiguration.test)
    }
}
#endif

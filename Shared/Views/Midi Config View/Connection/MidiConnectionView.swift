//
//  MidiThruView.swift
//  MidiCenterApp
//
//  Created by Tristan Leblanc on 29/12/2020.
//

import SwiftUI
import SwiftMidiCenter
import SwiftMIDI

struct MidiConnectionView: View {
    
    @EnvironmentObject var midiCenter: MidiCenter
    
    @ObservedObject var connection: MidiConnection
    
    //    @State var selectedInputs: Set<String> = Set<String>()
    //    @State var selectedOuputs: Set<String> = Set<String>()
    //    var selectedMaskTypes = [MidiEventTypeMaskSelector]()
    
    var body: some View {
        
        // Rebuilds picker items on the fly
        var inputItems = MFPickerItemsStore(items: midiCenter.inputs.map({
            MFPickerItem(name: $0.name, identifier: "\($0.uuid)", disabled: !$0.available)
        }))
        
        var outputItems = MFPickerItemsStore(items: midiCenter.outputs.map({
            MFPickerItem(name: $0.name, identifier: "\($0.uuid)", disabled: !$0.available)
        }))
        
        VStack {
            HStack {
                Button("All Note Off") {
                    do {
                        try connection.sendAllNoteOff()
                    } catch {
                        print(error)
                    }
                }
                Button("Note Channel 1") {
                    do {
                        try connection.sendOneNote()
                    } catch {
                        print(error)
                    }
                }
                Button("Note all channels") {
                    do {
                        try connection.sendOneNoteAllChannels()
                    } catch {
                        print(error)
                    }
                }
                Button("Chord Channel 1") {
                    do {
                        try connection.sendOneChord()
                    } catch {
                        print(error)
                    }
                }
                Button("Send Chord all channels") {
                    do {
                        try connection.sendOneChordOnAllChannels()
                    } catch {
                        print(error)
                    }
                }
            }
            #if os(iOS)
            VStack {
                MFPickerView(items: inputItems, selection: $connection.sourceIdentifiers)
                MFPickerView(items: outputItems, selection: $connection.destinationIdentifiers)
            }
            #else
            HStack {
                MFPickerView(items: inputItems, selection: $connection.sourceIdentifiers)
                MFPickerView(items: outputItems, selection: $connection.destinationIdentifiers)
            }
            #endif
            
            TabView {
                VStack {
                    GroupBox(label: Label("Filter", image: "pianokeys")) {
                        MidiFilterView(filter: $connection.filterSettings)
                    }
                }
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("Filter")
                }
                
                // Transpose Matrix is far too slow to display
                //
                // Limitation of swiftUI, or bad usage
                
                //                VStack {
                //                    GroupBox(label: Label("Input Transpose", image: "")) {
                //                        ChannelTransposeView(label: "Semitones:", transpositions: $connection.channelsTranspose)
                //                    }
                //
                //                    GroupBox(label: Label("Output Transpose", image: "")) {
                //
                //                        TransposeMatrixView(transposeMatrix: $connection.transposeMatrix)
                //                    }
                //                }
                //                    .tabItem {
                //                        Image(systemName: "2.square.fill")
                //                        Text("Transpose")
                //                    }
            }.padding(10)
            
            HStack {
                Toggle("Enabled", isOn: $connection.enabled)
                Toggle("Thru", isOn: $connection.midiThru)
            }.frame(alignment: .leading)
            
            Button("Update") {
                do {
                    //                    MidiCenter.shared.updateConnection(coreThruUUID: <#T##UUID#>, sources: T##[MidiOutlet], destinations: <#T##[MidiOutlet]#>)
                } catch {
                    print(error)
                }
            }
        }
        .padding(10)
        .frame(alignment: .topLeading)
    }
}

struct MidiThruView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        MidiConnectionView(connection: MidiConnection.test)
            .environmentObject(MidiCenter.shared)
            .colorScheme(ColorScheme.dark)
        
        MidiConnectionView(connection: MidiConnection.test)
            .environmentObject(MidiCenter.shared)
            .colorScheme(ColorScheme.light)
        
    }
}



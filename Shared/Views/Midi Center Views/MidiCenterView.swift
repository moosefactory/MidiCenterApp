//
//  ContentView.swift
//  Shared
//
//  Created by Tristan Leblanc on 27/12/2020.
//

import SwiftUI
import SwiftMidiCenter

/// MidiCenter view displays global objects
/// - midi inputs
/// - midi outputs

struct MidiCenterView: View {
    
    @EnvironmentObject var midiCenter: MidiCenter

    var body: some View {
        TabView {
            MidiOutletTableView(showInputs: true)
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("Inputs")
                }
            MidiOutletTableView(showInputs: false)
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Outputs")
                }
        }.padding(10)
    }
}

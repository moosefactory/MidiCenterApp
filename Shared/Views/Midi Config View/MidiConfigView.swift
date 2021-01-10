//
//  MidiConfigView.swift
//  MidiCenterApp
//
//  Created by Tristan Leblanc on 02/01/2021.
//

import SwiftUI
import SwiftMidiCenter

/// Midi Config View displays objects that are configurable by the user
/// - Input ports

struct MidiConfigView: View {
    
    @EnvironmentObject var midiCenter: MidiCenter

    var body: some View {
        TabView {
            MidiConnectionTableView(port: midiCenter.client.inputPort)
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("Input Ports")
                }
        }.padding(10)
    }
}

struct MidiConfigView_Previews: PreviewProvider {
    static var previews: some View {
        MidiConfigView()
    }
}

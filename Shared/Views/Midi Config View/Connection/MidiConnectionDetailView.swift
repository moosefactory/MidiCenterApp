//
//  MidiThruDetailView.swift
//  MidiCenterApp
//
//  Created by Tristan Leblanc on 29/12/2020.
//

import SwiftUI
import SwiftMidiCenter

struct MidiConnectionDetailView: View {
    
    @EnvironmentObject var midiCenter: MidiCenter

    @ObservedObject var midiConnection: MidiConnection
    
    var body: some View {
        VStack {
            MidiConnectionView(connection: midiConnection)
        }
        .navigationTitle(midiConnection.name)
        .frame(alignment: .leading)
//        #if os(iOS)
//        .navigationBarTitleDisplayMode(.inline)
//        #endif
        
    }
}

#if DEBUG
struct MidiThruDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MidiConnectionDetailView(midiConnection: MidiConnection.test)
            .environmentObject(MidiCenter.shared)
    }
}
#endif

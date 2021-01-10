//
//  MidiCenterAppView.swift
//  MidiCenterApp
//
//  Created by Tristan Leblanc on 02/01/2021.
//

import SwiftUI
import SwiftMidiCenter

struct MidiCenterAppView: View {
    var body: some View {
        VStack {
            Button("Reset Midi") {
                do {
                    try MidiCenter.shared.reset()
                } catch {
                    print(error)
                }
            }
        TabView {
            MidiCenterView()
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("Center")
                }
            MidiConfigView()
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Config")
                }
        }
            
        }.padding(10)
        
    }
}

struct MidiCenterAppView_Previews: PreviewProvider {
    static var previews: some View {
        MidiCenterAppView()
    }
}

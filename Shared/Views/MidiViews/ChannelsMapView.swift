//
//  ChannelsMapView.swift
//  MidiCenterApp
//
//  Created by Tristan Leblanc on 09/01/2021.
//


import SwiftUI
import SwiftMIDI

struct ChannelsMapView: View {
    
    @State var label: String = ""
    @Binding var mapping: MidiChannelsMap
    
    //@State var internalChannels: UInt16 = 0
    
    var body: some View {
        let formatter = NumberFormatter()
        
        HStack(spacing: 1.0) {
            if !label.isEmpty {
                Text(label)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .frame(width: 60)
                    .font(.caption)
            }
            ForEach(0..<16) { i in
                TextField("", value: $mapping.channels[i], formatter: formatter)
                    .font(.caption)
                    .frame(width: 24)
            }
        }
        .background(Color.clear)
    }
}

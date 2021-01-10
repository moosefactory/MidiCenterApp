//
//  ChannelTransposeView.swift
//  MidiCenterApp
//
//  Created by Tristan Leblanc on 07/01/2021.
//

import SwiftUI
import SwiftMIDI

struct ChannelsTransposeView: View {
    
    @State var label: String = ""
    @Binding var transpositions: MidiChannelsTranspose
    
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
                TextField("", value: $transpositions.transpose[i], formatter: formatter)
                    .font(.caption)
                    .frame(width: 24)
            }
        }
        .background(Color.clear)
    }
}

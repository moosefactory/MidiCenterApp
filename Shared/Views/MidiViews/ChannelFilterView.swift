//
//  ChannelFilterView.swift
//  MidiCenterApp
//
//  Created by Tristan Leblanc on 06/01/2021.
//

import SwiftUI

struct ChannelFilterView: View {
    
    @State var label: String = ""

    @Binding var channels: UInt16
    
    @State var internalChannels: UInt16 = 0
    
    @State var dragLocation: CGPoint?
    
    
    var body: some View {
        
        let drag = DragGesture(minimumDistance: 0).onChanged { value in
            dragLocation = value.location
        }
        
        HStack(spacing: 1.0) {
            if !label.isEmpty {
                Text(label)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .frame(width: 60)
                    .font(.caption)
            }
            ForEach(0..<16) { i in
                BitToggleView(channels: $channels, bit: UInt8(i))
            }
        }
        .background(Color.clear)
        .gesture(drag)
    }
}

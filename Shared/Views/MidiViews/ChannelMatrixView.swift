//
//  ChannelMatrixView.swift
//  MidiCenterApp
//
//  Created by Tristan Leblanc on 07/01/2021.
//

import SwiftUI
import SwiftMIDI

struct ChannelMatrixView: View {
    
    @Binding var channelMatrix: MidiChannelMatrix
    
    var body: some View {
        VStack {
            ForEach(0..<16) { i in
                let chan = String("0\(i+1)".suffix(2))
                ChannelFilterView(label: "Ch \(chan)", channels: $channelMatrix.mask[i])
            }
        }
    }
}

struct ChannelMatrixView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelMatrixView(channelMatrix: Binding<MidiChannelMatrix>( get: {
            return MidiChannelMatrix()
        }, set: { _ in }))
    }
}

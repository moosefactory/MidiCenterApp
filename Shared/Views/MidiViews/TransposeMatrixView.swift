//
//  TransposeMatrixView.swift
//  MidiCenterApp
//
//  Created by Tristan Leblanc on 07/01/2021.
//

import SwiftUI
import SwiftMIDI

struct TransposeMatrixView: View {
    @Binding var transposeMatrix: MidiChannelsTransposeMatrix
    
    var body: some View {
        VStack {
            ForEach(0..<16) { i in
                let chan = String("0\(i+1)".suffix(2))
                ChannelsTransposeView(label: "Ch \(chan)", transpositions: $transposeMatrix.transpose[i])
            }
        }
    }
}

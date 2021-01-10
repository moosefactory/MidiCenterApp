//
//  MidiRangeView.swift
//  MidiCenterApp
//
//  Created by Tristan Leblanc on 09/01/2021.
//

import SwiftUI
import SwiftMIDI

struct MidiRangeView: View {
    @State var label: String = "Range"
    @Binding var midiRange: MidiRange
    
    var body: some View {
        GroupBox(label: Text(label)) {
            HStack {
                Text("Lower:").frame(width: 60)
                TextField("", value: $midiRange.lower, formatter: NumberFormatter()).frame(width: 60)
                Text("Higher:").frame(width: 60)
                TextField("", value: $midiRange.higher, formatter: NumberFormatter()).frame(width: 60)
            }
        }
    }
}

//struct MidiRangeView_Previews: PreviewProvider {
//    static var previews: some View {
//        MidiRangeView(label: "Note Range", midiRange: NoteRange())
//    }
//}

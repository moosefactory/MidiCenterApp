//
//  ProjectView.swift
//  MidiCenter
//
//  Created by Tristan Leblanc on 27/12/2020.
//

import SwiftUI
import SwiftMidiCenter

struct ProjectView: View {
    @Binding var document: MidiCenterDocument
    
    var midiConfig: MidiConfiguration {
        return document.data.midiConfiguration
    }

    var body: some View {
        VStack {
            GroupBox(label: Text("Project")) {
                VStack {
                    TextField("Name", text: $document.data.name)
                }
                .padding(10)
            }
            .padding(20)
        }
    }
}

#if DEBUG
struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView(document: .constant(MidiCenterDocument()))
    }
}
#endif

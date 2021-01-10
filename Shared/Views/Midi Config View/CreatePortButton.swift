//
//  CreatePortButton.swift
//  MidiCenterApp
//
//  Created by Tristan Leblanc on 02/01/2021.
//

import SwiftUI
import SwiftMIDI
import SwiftMidiCenter

struct CreatePortButton: View {
    
    var title: String
    var portType: InputPortType
    
    @State var gotError: Bool = false
    @State var error: SwiftMIDI.MidiError?
    
    var body: some View {
        Button(title) {
            createPort(type: portType)
        }.alert(isPresented: $gotError) { () -> Alert in
            Alert(title: Text("Error"),
                  message: Text("\(self.error!.description)"),
                  dismissButton: .default(Text("Close")))
        }
    }
    
    func createPort(type: InputPortType) {
        do {
            try MidiCenter.shared.createPort(type: portType)
        } catch {
            self.error = error as? SwiftMIDI.MidiError
            gotError = self.error != nil
        }
    }
    
}

struct CreatePortButton_Previews: PreviewProvider {
    static var previews: some View {
        CreatePortButton(title: "New Port", portType: .events)
    }
}

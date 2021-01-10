//
//  Dialog.swift
//  MidiCenterApp
//
//  Created by Tristan Leblanc on 05/01/2021.
//

import SwiftUI
import SwiftMidiCenter


struct NewConnectionDialog: View {
    @Environment(\.presentationMode) var presentationMode
    
    /// Edited value, passed from outside
    @Binding var value: NewConnectionInfo?
    
    /// Prompt message
    var prompt: String = ""
    
    /// The value currently edited
    @State var editedValue: NewConnectionInfo
    
    var portTypes = ConnectionType.allStrings
    
    @State private var selectedPortType = 0
    
    /// Init the Dialog view
    /// Passed @binding value is duplicated to @state value while editing
    init(prompt: String, value: Binding<NewConnectionInfo?>) {
        _value = value
        self.prompt = prompt
        _editedValue = State<NewConnectionInfo>(initialValue: value.wrappedValue ?? NewConnectionInfo(name: "main"))
    }
    
    var body: some View {
        VStack {
            Text(prompt).padding()
            
            
            Form {
                Section {
                    TextField("", text: $editedValue.name)
                        .frame(width: 200, alignment: .center)
                }
                Section {
                    ChannelFilterView(channels: $editedValue.channels)
                }
                Section {
                    Picker(selection: $editedValue.connectionTypeIndex, label: Text("Strength")) {
                        ForEach(0 ..< portTypes.count) {
                            Text(self.portTypes[$0])
                        }
                    }
                }
            }
            
            HStack {
                Button("OK") {
                    self.value = editedValue
                    self.presentationMode.wrappedValue.dismiss()
                }
                Button("Dismiss") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }.padding()
        }
        .padding()
    }
}

#if DEBUG

struct Dialog_Previews: PreviewProvider {
    
    static var previews: some View {
        var info = NewConnectionInfo(name: "Test")
        NewConnectionDialog(prompt: "Name", value: Binding<NewConnectionInfo?>.init(get: { info }, set: {info = $0 ?? NewConnectionInfo(name: "Test")}))
    }
}

#endif

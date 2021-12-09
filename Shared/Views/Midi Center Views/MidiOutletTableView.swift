//
//  MidiOutletTableView.swift
//  MidiCenter
//
//  Created by Tristan Leblanc on 29/12/2020.
//

import SwiftUI
import SwiftMidiCenter

struct MidiOutletTableView: View {
    
    @State var showInputs: Bool = true
    
    @EnvironmentObject var midiCenter: MidiCenter
    
    var body: some View {
        List {
            let outlets = showInputs ?
                midiCenter.inputs :
                midiCenter.outputs
            withAnimation {
                ForEach(outlets, id: \.self) { input in
                    MidiOutletCell(input: input)
                        .disabled(!input.available)
                        .opacity(input.available ? 1 : 0.5)
                }
            }
        }
    }
}

struct MidiOutletCell: View {
    var input: MidiOutlet
    var refStr: String {
        return input.ref == 0 ? "" : " - Ref: \(input.ref)"
    }
    var body: some View {
        HStack {
            Image(systemName: "pianokeys")
            VStack(alignment: .leading) {
                Text(input.name)
                let uuid = String(input.uuid.uuidString.prefix(8))
                Text("Outlet \(uuid)… ref:\(refStr) id:\(input.uniqueID)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

#if DEBUG

struct MidiOutletTableView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MidiOutletTableView().environmentObject(MidiCenter.test)
                .environment(\.colorScheme, .light)
            MidiOutletTableView().environmentObject(MidiCenter.test)
                .environment(\.colorScheme, .dark)
        }
    }
}

#endif

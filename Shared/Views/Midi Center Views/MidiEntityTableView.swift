//
//  MidiEntityTableView.swift
//  MidiCenterApp
//
//  Created by Tristan Leblanc on 10/01/2021.
//

import SwiftUI
import SwiftMidiCenter

struct MidiEntityTableView: View {
    
    @EnvironmentObject var midiCenter: MidiCenter
    
    var body: some View {
        List {
            let devices = midiCenter.entities
            withAnimation {
                ForEach(devices, id: \.self) { entity in
                    MidiEntityCell(entity: entity)
                        .disabled(!entity.available)
                        .opacity(entity.available ? 1 : 0.5)
                }
            }
        }
    }
}

struct MidiEntityCell: View {
    var entity: MidiEntity
    var refStr: String {
        return entity.ref == 0 ? "" : " - Ref: \(entity.ref)"
    }
    var body: some View {
        HStack {
            Image(systemName: "pianokeys")
            VStack(alignment: .leading) {
                Text(entity.name)
                Text("Outlet \(refStr)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

#if DEBUG

struct MidiEntityTableView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MidiEntityTableView().environmentObject(MidiCenter.test)
                .environment(\.colorScheme, .light)
            MidiEntityTableView().environmentObject(MidiCenter.test)
                .environment(\.colorScheme, .dark)
        }
    }
}

#endif

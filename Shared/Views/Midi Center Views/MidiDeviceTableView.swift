//
//  MidiDeviceTableView.swift
//  MidiCenterApp
//
//  Created by Tristan Leblanc on 10/01/2021.
//

import SwiftUI
import SwiftMidiCenter

struct MidiDeviceTableView: View {
    
    @EnvironmentObject var midiCenter: MidiCenter
    
    var body: some View {
        List {
            let devices = midiCenter.devices
            withAnimation {
                ForEach(devices, id: \.self) { device in
                    MidiDeviceCell(device: device)
                        .disabled(!device.available)
                        .opacity(device.available ? 1 : 0.5)
                }
            }
        }
    }
}

struct MidiDeviceCell: View {
    var device: MidiDevice
    var refStr: String {
        return device.ref == 0 ? "" : " - Ref: \(device.ref)"
    }
    var body: some View {
        HStack {
            Image(systemName: "pianokeys")
            VStack(alignment: .leading) {
                Text(device.name)
                Text("Outlet \(refStr)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

#if DEBUG

struct MidiDeviceTableView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MidiDeviceTableView().environmentObject(MidiCenter.test)
                .environment(\.colorScheme, .light)
            MidiDeviceTableView().environmentObject(MidiCenter.test)
                .environment(\.colorScheme, .dark)
        }
    }
}

#endif

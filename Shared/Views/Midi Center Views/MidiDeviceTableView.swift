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
    
    @State var showExternalDevices: Bool
    
    var body: some View {
        List {
            let devices = showExternalDevices ? midiCenter.externalDevices : midiCenter.devices
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
        HStack(alignment: .top) {
            Image(systemName: "pianokeys")
            VStack(alignment: .leading) {
                Text(device.name)
                Text("Outlet \(refStr)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                ForEach(device.entities, id: \.self) { entity in
                    VStack(alignment: .leading) {
                        Text("[\(entity.ref)]   \(entity.name)")
                        VStack(alignment: .leading) {
                            ForEach(entity.sources, id: \.self) { source in
                                Text("In: [\(source)]   \(source.name)")
                                    .font(.subheadline)
                                    .foregroundColor(.orange)
                            }
                        }.padding(.leading, 10)
                        VStack(alignment: .leading) {
                            ForEach(entity.destinations, id: \.self) { destination in
                                Text("Out: [\(destination)]   \(destination.name)")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }.padding(.leading, 10)
                    }.padding(.leading,20)
                }.padding(.leading,20)
            }
        }.multilineTextAlignment(.leading)
    }
}

#if DEBUG

struct MidiDeviceTableView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MidiDeviceTableView(showExternalDevices: false).environmentObject(MidiCenter.test)
                .environment(\.colorScheme, .light)
            MidiDeviceTableView(showExternalDevices: true).environmentObject(MidiCenter.test)
                .environment(\.colorScheme, .dark)
        }
    }
}

#endif

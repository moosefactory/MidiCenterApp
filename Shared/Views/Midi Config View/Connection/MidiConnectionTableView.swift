//
//  MidiThruTableView.swift
//  MidiCenterApp
//
//  Created by Tristan Leblanc on 29/12/2020.
//

import SwiftUI
import SwiftMIDI

import SwiftMidiCenter

struct MidiConnectionTableView: View {
    
    @EnvironmentObject var midiCenter: MidiCenter
    
    @ObservedObject var port: InputPort
    
    /// Is the input dialog displayed
    @State var dialogDisplayed = false
    
    /// The info to edit
    @State var info: NewConnectionInfo? = nil
    
    @State var gotError: Bool = false
    @State var error: SwiftMIDI.MidiError?
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                // Top function buttons
                // - New connection
                // - remove all connections
                HStack {
                    
                    Button("New") {
                        dialogDisplayed = true
                    }
                    .sheet(isPresented: $dialogDisplayed, onDismiss: {
                        guard let info = info else {
                            return
                        }
                        do {
                            let connection = try MidiCenter.shared.client.newConnection(with: info)
                            print("Connection created: \(connection)")
                        }
                        catch {
                            print("Can't create new connection")
                        }
                    }) {
                        NewConnectionDialog(prompt: "New Connection", value: $info)
                    }
                    
                    Button("Remove All") {
                        MidiCenter.shared.removeAllMidiConnections()
                    }
                    .disabled(MidiCenter.shared.client.connections.isEmpty)
                }
                .onChange(of: info, perform: { value in
                    guard let info = value else {
                        return
                    }
                    do {
                        let connection = try MidiCenter.shared.client.newConnection(with: info)
                        print("Created connection :\r\(connection)")
                    }
                    catch {
                        print("Can't create new connection")
                    }
                    self.info = nil
                })
                .alert(isPresented: $gotError) { () -> Alert in
                    Alert(title: Text("iOSDevCenters"),
                          message: Text("\(self.error!.description)"),
                          primaryButton: .default(Text("Okay"), action: {
                            
                          }), secondaryButton: .default(Text("Dismiss")))
                }
                
            List {
                ForEach(midiCenter.client.connections.filter({$0.inputPort == port})) { connection in
                    NavigationLink(destination: MidiConnectionDetailView(midiConnection: connection)) {
                        MidiConnectionCell(connection: connection)
                    }
                }
            }
            .navigationTitle("Midi Thru Connections")
            }
        }
        .padding(10)
    }
    
    func createConnection() {
        do {
            guard let info = info else { return }
            let connection = try MidiCenter.shared.client.newConnection(with: info)
            print("Created connection:\r\(connection)")
        } catch {
            self.error = error as? SwiftMIDI.MidiError
            gotError = self.error != nil
        }
    }
}



struct MidiConnectionCell: View {
    var connection: MidiConnection
    var refStr: String {
        return "\(connection.uuid)"
    }
    
    var body: some View {
        HStack {
            Image(systemName: "pianokeys")
            VStack(alignment: .leading) {
                Text(connection.name)
                Text("\(refStr)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

#if DEBUG
//
//struct MidiThruTableView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            MidiConnectionTableView(port: InputPort()).environmentObject(MidiCenter.test)
//                .environment(\.colorScheme, .light)
//            MidiConnectionTableView(port: InputPort()).environmentObject(MidiCenter.test)
//                .environment(\.colorScheme, .dark)
//        }
//    }
//}
#endif

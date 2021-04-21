//
//  MidiConfiguration.swift
//  MidiCenterApp
//
//  Created by Tristan Leblanc on 28/12/2020.
//

import Foundation
import SwiftMidiCenter
import CoreMIDI
import Combine

class UsedMidiInput: Codable, MidiObject, Identifiable, Hashable {
    
    static func == (lhs: UsedMidiInput, rhs: UsedMidiInput) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    var uuid: UUID = UUID()
    
    var uniqueID: Int { return ref.properties.uniqueID }
    var ref: MIDIObjectRef
    var name: String
    
    var isAvailable: Bool { return ref != 0 }
    
    func setUnvailable() {
        self.ref = 0
    }
    
    func setMidiRef(_ ref: MIDIObjectRef) {
        self.ref = ref
    }
    
    enum CodingKeys: String, CodingKey {
        case ref
        case uuid
        case name
    }
    
    init(name: String, ref: MIDIObjectRef) {
        self.name = name
        self.ref = ref
    }
    
    init(with outlet: MidiOutlet) {
        self.name = outlet.name
        self.ref = outlet.ref
    }
    
    static let none = UsedMidiInput(name: "None", ref: 0)
}

class MidiConfiguration: Codable, ObservableObject {
    var inputs = [UsedMidiInput]()
    var outputs = [UsedMidiInput]()
        
    enum CodingKeys: String, CodingKey {
        case inputs
        case outputs
    }

    func registerMidiOutlets() {
        MidiCenter.shared.forEachInput { outlet in
            // if midi input is not in document, we add it
            if !self.inputs.contains(where: {
                $0.name == outlet.name
            }) {
                self.inputs.append(UsedMidiInput(with: outlet))
            }
        }
        MidiCenter.shared.forEachOutput { outlet in
            // if midi output is not in document, we add it
            if !self.outputs.contains(where: {
                $0.name == outlet.name
            }) {
                self.outputs.append(UsedMidiInput(with: outlet))
            }
        }
    }
    
    func syncMidiOutlets(with midiBay: MidiPatchBay) {
        
        // First register new inputs if any
        registerMidiOutlets()
        
        // Update document inputs accordingly to MidiCenter available inputs
        for input in inputs.enumerated() {
            // Check if midi center input is already registered in midi settings inputs
            let midiCenterOutlet = midiBay.input.outlet(for: input.element.name)
            let known = midiCenterOutlet != nil
            
            print("Input '\(midiCenterOutlet?.name)' known: \(known), ref = \(midiCenterOutlet?.ref)")

            if let ref = midiCenterOutlet?.ref, known  {
                inputs[input.offset].setMidiRef(ref)
            } else {
                // No more reference to CoreMidi input
                inputs[input.offset].setUnvailable()
            }
        }

        
        // Update document outputs accordingly to MidiCenter available outputs
        for output in outputs.enumerated() {
            // Check if midi center input is already registered in midi settings inputs
            let midiCenterOutlet = midiBay.output.outlet(for: output.element.name)
            let known = midiCenterOutlet != nil
            
            print("Input '\(midiCenterOutlet?.name)' known: \(known), ref = \(midiCenterOutlet?.ref)")

            if let ref = midiCenterOutlet?.ref, known  {
                outputs[output.offset].setMidiRef(ref)
            } else {
                // No more reference to CoreMidi input
                outputs[output.offset].setUnvailable()
            }
        }
        
        objectWillChange.send()
    }

    #if DEBUG
    static let test: MidiConfiguration = {
       let mc = MidiConfiguration()
        mc.inputs = [UsedMidiInput(name: "Midi Device 1", ref: 0), UsedMidiInput(name: "Device X", ref: 0)]
        return mc
    }()
    #endif
}

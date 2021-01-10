//
//  MidiConnection+Test.swift
//  MidiCenterApp
//
//  Created by Tristan Leblanc on 08/01/2021.
//

import Foundation
import SwiftMIDI
import SwiftMidiCenter

extension MidiConnection {
    
    public func sendAllNoteOff() throws {
        var events = [MidiEvent]()
        for i in 0..<128 {
            events.append(MidiEvent(type: .noteOff, timestamp: 0, channel: 0, value1: UInt8(i), value2: 0))
        }
        try send(events: events)
    }
    
    public func sendOneNote() throws {
        let events = [MidiEvent(type: .noteOn, timestamp: 0, channel: 0, value1: UInt8(48), value2: 96)]
        try send(events: events)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            try? self.send(events: events.asNotesOff)
        }
    }
    
    public func sendOneNoteAllChannels() throws {
        var events = [MidiEvent]()
        for i in 0..<16 {
            events += [MidiEvent(type: .noteOn, timestamp: 0, channel: UInt8(i), value1: UInt8(48), value2: 96)]
            try? send(events: events)
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            try? self.send(events: events.asNotesOff)
        }
    }
    
    public func sendOneChord() throws {
        var events = [MidiEvent]()
            events += [
                MidiEvent(type: .noteOn, timestamp: 0, channel: 0, value1: UInt8(48), value2: 85),
                MidiEvent(type: .noteOn, timestamp: 0, channel: 0, value1: UInt8(52), value2: 96),
                MidiEvent(type: .noteOn, timestamp: 0, channel: 0, value1: UInt8(55), value2: 100)
            ]
            try send(events: events)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            try? self.send(events: events.asNotesOff)
        }

    }
    
    public func sendOneChordOnAllChannels() throws {
        var events = [MidiEvent]()
        for i in 0..<16 {
            events += [
                MidiEvent(type: .noteOn, timestamp: 0, channel: UInt8(i), value1: UInt8(48), value2: 85),
                MidiEvent(type: .noteOn, timestamp: 0, channel: UInt8(i), value1: UInt8(52), value2: 96),
                MidiEvent(type: .noteOn, timestamp: 0, channel: UInt8(i), value1: UInt8(55), value2: 100)
            ]
        }
        try send(events: events)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            try? self.send(events: events.asNotesOff)
        }

    }

}

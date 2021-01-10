//
//  MidiCenterAppModel.swift
//  MidiCenterApp
//
//  Created by Tristan Leblanc on 27/12/2020.
//

import Foundation
import SwiftMidiCenter
import CoreMIDI
import Combine

class MidiCenterAppModel: Codable {
    var name: String
    var midiConfiguration: MidiConfiguration
        
    var midiCenterObservation: AnyCancellable?
    
    enum CodingKeys: String, CodingKey {
        case name
        case midiConfiguration
    }
    
    init(name: String = "Untitled", midiConfiguration: MidiConfiguration = MidiConfiguration()) {
        self.name = name
        self.midiConfiguration = midiConfiguration
        startObserve()
    }
    
    func startObserve() {
        midiCenterObservation = MidiCenter.shared.$midiBay.sink { midiBay in
            self.midiConfiguration.syncMidiOutlets(with: midiBay)
        }
    }
}

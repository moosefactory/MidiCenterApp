//
//  MidiFilterView.swift
//  MidiCenterApp
//
//  Created by Tristan Leblanc on 08/01/2021.
//

import SwiftUI
import SwiftMIDI

struct MidiFilterView: View {
    
    @Binding var filter: MidiFilterSettings
    
    var body: some View {
        
        let eventTypeItems = MFPickerItemsStore(items: MidiEventTypeMaskSelector.allCases.map ({
            MFPickerItem(name: $0.description, identifier: $0.identifier, disabled: false)
        }))

        let selectedMaskIdentifiers = Binding<Set<String>>(get: {
            let mask = $filter.eventTypes.wrappedValue
            var out = [MidiEventTypeMaskSelector]()
            if mask.contains(eventType: .noteOn) || mask.contains(eventType: .noteOff) {
                out.append(.notes)
            }
            if mask.contains(eventType: .pitchBend) {
                out.append(.pitchBend)
            }
            if mask.contains(eventType: .afterTouch) || mask.contains(eventType: .polyAfterTouch)  {
                out.append(.afterTouch)
            }
            if mask.contains(eventType: .control) {
                out.append(.controls)
            }
            if mask.contains(eventType: .programChange) {
                out.append(.programChange)
            }
            if mask.contains(eventType: .realTimeMessage) {
                out.append(.clock)
            }
            return Set(out.map {$0.identifier})
        }, set: {
            var mask = MidiEventTypeMask(rawValue: 0)
            print("--- \(mask)")
            $0.forEach { id in
                let sel = MidiEventTypeMaskSelector(with: id)
                mask.rawValue = mask.rawValue | sel.mask.rawValue
                print("\(id) => \(sel) => \(mask)")
            }

            $filter.eventTypes.wrappedValue = mask
        })

        VStack {
                MFPickerView(items: eventTypeItems, selection: selectedMaskIdentifiers)

            GroupBox(label: Label("Input Channel", image: "")) {
                ChannelFilterView(label: "Enable:", channels: $filter.channels)
            }
            HStack {
                Text("Global Transpose").font(.caption).frame(width:120)
                TextField("", value: $filter.globalTranspose, formatter: NumberFormatter()).frame(width: 60)
            }

            GroupBox(label: Label("Channels Mapping", image: "")) {
                ChannelsMapView(label: "Semitones:", mapping: $filter.channelsMap)
            }

            GroupBox(label: Label("Channels Transposition", image: "")) {
                ChannelsTransposeView(label: "Semitones:", transpositions: $filter.channelsTranspose)
            }
            
            GroupBox(label: Label("Range", image: "")) {
                MidiRangeView(label: "Note", midiRange: $filter.noteRange)
                MidiRangeView(label: "Velocity", midiRange: $filter.velocityRange)
            }
        }
    }
}

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
    
    let eventTypeItems = MFPickerItemsStore(items: MidiEventTypeMaskSelector.allCases.map ({
        MFPickerItem(name: $0.description, identifier: $0.identifier, disabled: false)
    }))

    var body: some View {
        let selectedMaskIdentifiers = Binding<Set<UUID>>(get: {
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
            
            let identifiers = out.map { $0.identifier }
            let items = eventTypeItems.items(for: identifiers)
            return Set(items.compactMap {$0.uuid})
        }, set: {
            var mask = MidiEventTypeMask(rawValue: 0)
            print("--- \(mask)")
            let items = eventTypeItems.items(for: Array($0))
            items.forEach { item in
                let sel = MidiEventTypeMaskSelector(with: item.identifier)
                mask.rawValue = mask.rawValue | sel.mask.rawValue
                print("\(item.identifier) => \(sel) => \(mask)")
            }
            
            $filter.eventTypes.wrappedValue = mask
        })
        
        VStack {
            MFPickerView(title: "Event Types", items: eventTypeItems, selection: selectedMaskIdentifiers)
            
            GroupBox(label: Label("Input Channel", image: "")) {
                ChannelFilterView(label: "Enable:", channels: $filter.channels)
            }
            HStack {
                Text("Global Transpose").font(.caption).frame(width:120)
                TextField("", value: $filter.globalTranspose, formatter: NumberFormatter()).frame(width: 60)
            }
            
            GroupBox(label: Label("Channels Mapping", image: "")) {
                ChannelsMapView(label: "Destination Channel:", mapping: $filter.channelsMap)
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

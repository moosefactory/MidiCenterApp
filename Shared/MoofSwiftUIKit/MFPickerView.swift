//
//  MFPickerView.swift
//  MidiCenterApp
//
//  Created by Tristan Leblanc on 29/12/2020.
//

import SwiftUI

class MFPickerItemsStore: ObservableObject {
    @Published var items: [MFPickerItem]
    
    var isEmpty: Bool { items.isEmpty }
    var count: Int { return items.count }
    init(items: [MFPickerItem]) {
        self.items = items
    }
}

class MFPickerItem: ObservableObject, Identifiable {
    enum Identifiers: String {
        case none
        case all
        case separator
    }
    
    var identifier: String
    @Published var name: String
    @Published var canSelect: Bool
    @Published var disabled: Bool
    
    init(name: String, identifier: String = UUID().uuidString, canSelect: Bool = true, disabled: Bool = false) {
        self.name = name
        self.identifier = identifier
        self.canSelect = canSelect
        self.disabled = disabled
    }
    
    public static let none = MFPickerItem(name: "None", identifier: Identifiers.none.rawValue)
    
    public static let all = MFPickerItem(name: "All", identifier: Identifiers.all.rawValue)
    
    public static let separator = MFPickerItem(name: "", identifier: Identifiers.separator.rawValue, canSelect: false)
}

extension MFPickerItem: Hashable {
    static func == (lhs: MFPickerItem, rhs: MFPickerItem) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}


struct MFPickerCellView: View {
    @ObservedObject var item: MFPickerItem
    var selected: Bool
    
    var body: some View {
        withAnimation {
            HStack {
                Image(systemName: "checkmark")
                    .opacity(selected ? 1 : 0)
                Text(item.name)
                    .multilineTextAlignment(.leading)
            }
            .disabled(item.disabled)
            .opacity(item.disabled ? 0.5 : 1)
        }
    }
}

struct MFPickerView: View {
    
    @ObservedObject var items: MFPickerItemsStore
    
    @Binding var selection: Set<String>
    
    @State var showNone: Bool = true
    @State var showAll: Bool = true
    @State var hideDisabledItems: Bool = false

    var body: some View {
        GroupBox(label: Label("Sources", systemImage: "pianokeys")) {
            VStack(alignment: .leading) {
                ForEach(displayedItems) { item in
                    HStack(alignment: .top) {
                        MFPickerCellView(item: item, selected: isItemSelected(item))
                    }
                    .onTapGesture {
                        didTap(item: item)
                    }
                }
            }
        }
        .padding(/*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        .frame(width: 300)
    }
    
    func isItemSelected(_ item: MFPickerItem) -> Bool {
        switch item.identifier {
        case MFPickerItem.Identifiers.none.rawValue:
            return selection.isEmpty || items.isEmpty
        case MFPickerItem.Identifiers.all.rawValue:
            return selection.count == items.count
        default:
            return selection.contains(item.identifier)
        }
    }
    
    var displayedItems: [MFPickerItem] {
        var displayedItems = [MFPickerItem]()
        if showNone {
            displayedItems.append(MFPickerItem.none)
        }
        if showAll && !items.isEmpty {
            displayedItems.append(MFPickerItem.all)
        }
        if !displayedItems.isEmpty && !items.isEmpty {
            displayedItems.append(MFPickerItem.separator)
        }
        if hideDisabledItems {
            displayedItems += items.items.filter({
                !$0.disabled
            })
        } else {
            displayedItems += items.items
        }
        return displayedItems
    }
    
    func didTap(item: MFPickerItem) {
        guard item.canSelect else { return }
        switch item.identifier {
        case MFPickerItem.Identifiers.none.rawValue:
            selection.removeAll()
        case MFPickerItem.Identifiers.all.rawValue:
            selection = selection.union(items.items.map { $0.identifier })
        default:
            if selection.contains(item.identifier) {
                self.selection.remove(item.identifier)
            } else {
                self.selection.insert(item.identifier)
            }
        }
    }
}

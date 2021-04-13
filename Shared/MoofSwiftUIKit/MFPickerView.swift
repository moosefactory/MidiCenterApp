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
        case any
    }
    
    /// Unique id
    let uuid: UUID
    
    /// identifier, set by user
    /// identifier should be unique, but does not have to. Use uuid for uniqueness
    let identifier: String
    
    /// Displayed name
    @Published var name: String
    
    /// Is item selectable
    @Published var canSelect: Bool
    
    /// Is item selectable
    @Published var disabled: Bool
    
    /// Initializer
    init(name: String, identifier: String = Identifiers.any.rawValue, uuid: UUID = UUID(), canSelect: Bool = true, disabled: Bool = false) {
        self.name = name
        self.uuid = uuid
        self.identifier = identifier
        self.canSelect = canSelect
        self.disabled = disabled
    }
    
    /// Extra items
    public static let none = MFPickerItem(name: "None", identifier: Identifiers.none.rawValue)
    public static let all = MFPickerItem(name: "All", identifier: Identifiers.all.rawValue)
    public static let separator = MFPickerItem(name: "", identifier: Identifiers.separator.rawValue, canSelect: false)
}

extension MFPickerItem: Hashable {
    static func == (lhs: MFPickerItem, rhs: MFPickerItem) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

extension MFPickerItem: CustomStringConvertible {
    public var description: String {
        return "Item \(identifier) - name : \(name) - uuid: \(uuid.uuidString.prefix(4))…"
    }
}

extension MFPickerItemsStore {
    func items(for identifiers: [String]) -> [MFPickerItem] {
        return identifiers.compactMap { identifier in
            items.first(where: {$0.identifier == identifier})
        }
    }

    func items(for uuids: [UUID]) -> [MFPickerItem] {
        return uuids.compactMap { uuid in
            items.first(where: {$0.uuid == uuid})
        }
    }
}

struct MFPickerCellView: View {
    
    @ObservedObject var item: MFPickerItem
    
    @State var selected: Bool
    
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
    
    @State var title: String

    /// The items store
    @ObservedObject var items: MFPickerItemsStore
    
    /// The selected items uuids
    @Binding var selection: Set<UUID>
    
    /// Picker options
    @State var showNone: Bool = true
    @State var showAll: Bool = true
    @State var hideDisabledItems: Bool = false

    var body: some View {
        GroupBox(label: Label(title, systemImage: "pianokeys")) {
            VStack(alignment: .leading) {
                ForEach(displayedItems) { item in
                    HStack(alignment: .top) {
                        let selected = isItemSelected(item)
                        MFPickerCellView(item: item, selected: selected)
                    }
                    .onTapGesture {
                        didSelect(item: item)
                    }
                }
            }
        }
        .padding(/*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        .frame(width: 300)
    }
    
    func isItemSelected(_ item: MFPickerItem) -> Bool {
        switch item.uuid {
        case MFPickerItem.none.uuid:
            return selection.isEmpty || items.isEmpty
        case MFPickerItem.all.uuid:
            return selection.count == items.count
        default:
            return selection.contains(item.uuid)
        }
    }
    
    /// Returns all displayed items
    ///
    /// It adds the .none and .all custom items if options are set
    
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
    
    var selectedItems: [MFPickerItem] {
        return items.items.compactMap { item in
            return selection.contains(where: { item.uuid == $0 }) ? item : nil
        }
    }
    /// Events handling
    
    func didSelect(item: MFPickerItem) {
        print("Did select \(item)")

        guard item.canSelect else { return }
        switch item.uuid {
        case MFPickerItem.none.uuid:
            selection.removeAll()
        case MFPickerItem.all.uuid:
            selection = selection.union(items.items.map { $0.uuid })
        default:
            if selection.contains(item.uuid) {
                self.selection.remove(item.uuid)
            } else {
                self.selection.insert(item.uuid)
            }
        }
        print(selectedItems)
    }
}

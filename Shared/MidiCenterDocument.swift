//
//  MidiCenterDocument.swift
//  Shared
//
//  Created by Tristan Leblanc on 27/12/2020.
//

import SwiftUI
import UniformTypeIdentifiers
import SwiftMidiCenter
import Combine

extension UTType {
    static var exampleText: UTType {
        UTType(exportedAs: "com.moosefactory.midiCenterApp")
    }
}

struct MidiCenterDocument: FileDocument, Codable {
        
    var data: MidiCenterAppModel
    
    init(name: String = "My Doc") {
        self.data = MidiCenterAppModel(name: name, midiConfiguration: MidiConfiguration())
    }

    enum CodingKeys: String, CodingKey {
        case data
    }
    
    static var readableContentTypes: [UTType] { [.exampleText] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        let projectData = try JSONDecoder().decode(Self.self, from: data)
        projectData.data.midiConfiguration.syncMidiOutlets(with: MidiCenter.shared.midiBay)
        projectData.data.startObserve()
        self = projectData
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(self)
        return .init(regularFileWithContents: data)
    }
}

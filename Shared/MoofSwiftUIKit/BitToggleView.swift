//
//  BitToggleView.swift
//  Dialog
//
//  Created by Tristan Leblanc on 06/01/2021.
//

import SwiftUI

struct BitToggleView: View {
    @Binding var channels: UInt16
    
    @State var bit: UInt8 = 0
    @State var internalChannels: UInt16 = 0
    
    init(channels: Binding<UInt16>, bit: UInt8) {
        _channels = channels
        _bit = State<UInt8>(initialValue: bit)
        _internalChannels = State<UInt16>(initialValue: channels.wrappedValue)
    }

    var mask: UInt16 { return (0x0001 << UInt16(bit)) }
    
    var body: some View {
        let str = String("0\(bit+1)".suffix(2))
        
        let toggleBind = Binding<Bool>( get: {
            return (internalChannels & mask) > 0
        }, set: {
            if $0 {
                channels = channels | mask
            } else {
                channels = channels & ~mask
            }
            internalChannels = channels
        })

        SquareToggleView(label: str, toggle: toggleBind)
    }
}

//struct BitToggleView_Previews: PreviewProvider {
//    static var previews: some View {
//        BitToggleView(channels: 0x00C3, bit: 1)
//    }
//}

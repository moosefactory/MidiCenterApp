//
//  SquareToggleView.swift
//  MidiCenterApp
//
//  Created by Tristan Leblanc on 06/01/2021.
//

import SwiftUI

struct SquareToggleView: View {
    
    @State var label: String
    @Binding var toggle: Bool

    var body: some View {
        Text(label)
            .font(.caption)
            .frame(width: 24, height: 24, alignment: .center)
            .background(toggle ? Color.green : Color.gray)
            .foregroundColor(.black)
            .onTapGesture {
                toggle.toggle()
            }
    }
}
//
//struct SquareToggleView_Previews: PreviewProvider {
//    static var previews: some View {
//        SquareToggleView(label: "01", toggle: true)
//        SquareToggleView(label: "02", toggle: false)
//    }
//}

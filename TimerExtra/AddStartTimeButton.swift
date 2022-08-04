//
//  AddStartTimeButton.swift
//  TimerExtra
//
//  Created by carl on 02/08/2022.
//

import SwiftUI

struct AddStartTimeButton: View {
    var label: String
    
    var doubleHeight = false
    var action: ()->() = {}
    
    var body: some View {
        Button(action: self.action) {
            Spacer()
            Text(label)
                .padding(doubleHeight ? 15 : 2)
            Spacer()
        }
        .buttonStyle(.borderedProminent)
        .tint(.secondary)
    }
}

struct AddStartTimeButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            AddStartTimeButton(label: "+ 1 second")
            AddStartTimeButton(label: "+ 1 second", doubleHeight: true)
        }
    }
}

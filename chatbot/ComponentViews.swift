 //
//  messageView.swift
//  basicChatbot
//
//  Created by Alfred Francis on 2022-12-09.
//

import SwiftUI

struct individualMessageView: View {
    var msg: String
    var isUserMessage: Bool
    var body: some View {
        HStack {
            if isUserMessage == true {
                Spacer()
                Text(msg)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            } else {
                Text(msg)
                    .padding()
                    .background(.regularMaterial)
                    .cornerRadius(10)
                Spacer()
            }
        }
        .padding()
    }
}

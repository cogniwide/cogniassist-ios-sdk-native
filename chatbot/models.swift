//
//  File.swift
//  CogniAssist
//
//  Created by Alfred Francis on 09.12.22.
//

import Foundation

struct UserMessage {
    var message: String
    let sender: String
}

struct Message: Hashable, Encodable, Decodable {
    var text: String?
    let senderType: String?
}


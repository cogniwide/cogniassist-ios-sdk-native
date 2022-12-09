//
//  getBotResponse.swift
//  basicChatbot
//
//  Created by Alfred Francis on 2022-12-09.
//

import Foundation


func getBotResponse(sender: String, message: String) -> [Message] {
    // call https://external-proxy.lycabot.com/bots/638f36c036af37a93533cd91/default/webhooks/rest/
    // with message and sender as body and get response

    let params = ["message": message, "sender": sender]
    let jsonData = try? JSONSerialization.data(withJSONObject: params)
    let url = URL(string: "https://external-proxy.lycabot.com/bots/638f36c036af37a93533cd91/default/webhooks/rest/webhook")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = jsonData
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")

    var messages: [Message] = []
    var responseString = ""
    let semaphore = DispatchSemaphore(value: 0)
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print(error?.localizedDescription ?? "No data")
            return
        }
        responseString = String(data: data, encoding: .utf8)!
        
        let response = try! JSONDecoder().decode([Message].self, from: responseString.data(using: .utf8)!)
        for msg in response {
            messages.append(Message(text: msg.text, senderType: "bot"))
        }
        semaphore.signal()
    }
    task.resume()
    semaphore.wait()
    return messages
}

//
//  ContentView.swift
//  basicChatbot
//
//  Created by Alfred Francis on 2022-12-09.
//

import SwiftUI

struct ContentView: View {
    let defaults = UserDefaults.standard
    // initiliaze sender with uuid
    @State private var sender = UUID().uuidString
    @State private var messageText = ""
    @State var messages: [Message] = []
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ForEach(messages, id: \.self) { message in
                        // check if message is from user or bot and display view accordingly
                        if message.senderType == "user" {
                            individualMessageView(msg: message.text ?? "NA" , isUserMessage: true)
                        } else {
                            individualMessageView(msg:  message.text ?? "Chat element not supported", isUserMessage: false)
                        }
                    }.rotationEffect(.degrees(180))
                }.rotationEffect(.degrees(180))
                
                HStack {
                    TextField("Message", text: $messageText)
                        .padding()
                        .background(.regularMaterial)
                        .cornerRadius(10)
                    
                    Button {
                        postMessage(msg: messageText)
                    } label: {
                        Image(systemName: "paperplane.fill")
                    }
                    .disabled(messageText.isEmpty)
                    .padding()
                    .font(.title)
                }
                .padding()
            }
            .onAppear(perform: {
                if let data = defaults.object(forKey: "messages") as? Data,
                   let decoded = try? JSONDecoder().decode([Message].self, from: data)  {
                        messages = decoded
                } else {
                    messages = getBotResponse(sender: sender, message: "/default/welcome")
                }
            })
            .navigationTitle("Cogniassist")
        }
    }
    func postMessage(msg: String) {
        withAnimation {
            messages.append(Message(text: msg, senderType: "user"))
            self.messageText = ""
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    messages.append(contentsOf: getBotResponse(sender: sender, message: msg))
                    if let encoded = try? JSONEncoder().encode(messages) {
                        defaults.set(encoded, forKey: "messages")
                    }
                }
            }
        }
    }
}

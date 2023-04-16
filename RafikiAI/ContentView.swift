//
//  ContentView.swift
//  RafikiAI
//
//  Created by Makori Chacha on 2023-04-10.
//

import SwiftUI
// What happens when you run the app on your phone. do the files get saved on the device and then get ran through there? What is the process.
import Combine

struct ContentView: View {
    @State var messageText:String = ""
    @State var messages: [String] = ["Welcome to RafikiAI, how may I assist you?"]
    @State var chatMessages: [ChatMessage] = []
    let openAIService = OpenAIService()
    @State var cancellables = Set<AnyCancellable>()
    var body: some View {
        VStack{
            Text("RafikiAI")
                .font(.largeTitle)
                .bold()
            ScrollView{
                // Why do we use the slash .self, why not just self.
                ForEach(chatMessages, id: \.self) { message in
                    // Use the new data structure.
                    viewMessage(chatMessage: message)
                }.rotationEffect(Angle(degrees: 180))
               
            }.rotationEffect(Angle(degrees: 180))
           
            HStack(spacing:2){
                TextField("Type your message...",text: $messageText )
                {
                    // On commit enclosure.
                    sendChatMessage(message: messageText)
                    
                }
                    .frame(width: UIScreen.main.bounds.width*0.75, height:UIScreen.main.bounds.height*0.06)
                    .background(Color.gray.opacity(0.11))
                    .padding()
                    .cornerRadius(20)
                Button {
                 
                    if !messageText.isEmpty {
                        sendChatMessage(message: messageText)
                    }
                  
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.largeTitle)
                }
                

            }
        }.padding()
          
    }
   
   // Add a drag gesture to remove the keyboard after you're done typing.
    
    func sendChatMessage(message: String) {
        let myMessage = ChatMessage(id: UUID().uuidString,content: messageText,dateCreated: Date(), sender: .me)
        chatMessages.append(myMessage)
        openAIService.sendChatMessage(message: messageText).sink { completion in
            // Handle error
        }receiveValue: { response in
            guard let textResponse = response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn:"\""))) else { return }
            let gptMessage = ChatMessage(id: response.id, content: textResponse, dateCreated: Date(), sender: .gpt)
            chatMessages.append(gptMessage)
        }
        .store(in: &cancellables)
            
        messageText = ""
    }
    
    func viewMessage(chatMessage: ChatMessage) -> some View{
        HStack{
            
            if chatMessage.sender == .me {Spacer()}
            Text(chatMessage.content)
//                .foregroundColor(chatMessage.sender == .me ? .white : .black)
//                .background(chatMessage.sender == .me ? .blue : .gray.opacity(0.1))
//                .padding()
                .buttonBorderShape(.roundedRectangle)
                //.border(Color.black) // Adds a rectangular border around the text.
                .padding()
                .foregroundColor(chatMessage.sender == .me ? .white : .black)
                .background(chatMessage.sender == .me ? Color.blue : .gray)
                .cornerRadius(15)
                .padding(.horizontal,14)
            if chatMessage.sender == .gpt {Spacer()}
            
            
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct ChatMessage : Hashable{
    let id :String
    let content: String
    let dateCreated: Date
    let sender: MessageSender
}

enum MessageSender{
    // How are these used, what are the rules and properties?
    case gpt
    case me
}
extension ChatMessage{
    // How are these used, what are the rules and properties?
    static let initialMessage: [ChatMessage] = [ChatMessage(id: UUID().uuidString, content: "Welcome to RafikiAI! How may I assist you?", dateCreated: Date(), sender: .gpt)]
    
}

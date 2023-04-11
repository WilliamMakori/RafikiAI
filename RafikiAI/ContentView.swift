//
//  ContentView.swift
//  RafikiAI
//
//  Created by Makori Chacha on 2023-04-10.
//

import SwiftUI

struct ContentView: View {
    @State var messageText:String = ""
    @State var messages: [String] = ["Welcome to RafikiAI, how may I assist you?"]
    
    var body: some View {
        VStack{
            Text("RafikiAI")
                .font(.largeTitle)
                .bold()
            ScrollView{
                // Why do we use the slash .self, why not just self.
                ForEach(messages, id: \.self) {text in
                    if text.contains("[USER]") {
                        let newText = text.replacingOccurrences(of: "[USER]", with: "") // Replace the user string with an empty string
                        
                        HStack{
                            Spacer() // Push the message box all the way to the right of the screen
                            Text(newText)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue.opacity(0.8))
                                .padding(.horizontal,16)
                                .padding(.bottom,10)
                                .shadow(radius: 10)
                            
                        }
                        
                    }
                    else {
                        HStack{
                            Text(text)
                                .padding()
                                .foregroundColor(.black)
                                .background(Color.white.opacity(0.8))
                                .padding(.horizontal,16)
                                .padding(.bottom,10)
                                .shadow(radius: 10)
                            Spacer()
                        }
                    }
                    // Rotation effect read on it.
                    
                }.rotationEffect(.degrees(180))
            }.rotationEffect(.degrees(180))
            HStack(spacing:2){
                TextField("Type your message...",text: $messageText )
                    .frame(width: UIScreen.main.bounds.width*0.75, height:UIScreen.main.bounds.height*0.06)
                    .background(Color.gray.opacity(0.11))
                    .padding()
                    .cornerRadius(20)
                    .onSubmit{
                        // What happens when you submit the question through the
                        sendMessage(message: messageText)
                    }
                Button {
                    // This should submit the question that we asked and return an answer that will be displayed on the screen.
                    sendMessage(message: messageText)
                  
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.largeTitle)
                    
                }
                

            }
        }
    }
    func sendMessage(message: String) {
        // This should append the message to the messages array
        // Should clear the messageText variable
        // should send the message to the rafiki response func and get a message back that will be displayed on the screen.
        
        withAnimation{
            messages.append("[USER]" + message)
            self.messageText = ""
        }
        // Dispatch queues SwiftUI
        // One second delay.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            withAnimation{
                messages.append(jibuLaRafiki(message: message)) // How is it we can access this file when it's declared in another file.
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

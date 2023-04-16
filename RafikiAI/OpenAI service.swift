//
//  OpenAI service.swift
//  RafikiAI
//
//  Created by Makori Chacha on 2023-04-15.
//

import Foundation
import Alamofire  // Helps us in making URL requests
import Combine

class OpenAIService{
    // this is the completion endpoint
    let baseUrl = "https://api.openai.com/v1/" // BaseUrl is upto v1.
    // Completions endpoint.
    // We'll be able to use this with other completions
    
    // Make a way for us to call this data.
    
    func sendChatMessage(message: String) -> AnyPublisher<OpenAICompletionsResponse,Error>{
        
        // This message is the user's input
        // body
        let body  = OpenAICompletionsBody(model: "text-davinci-003", prompt: message ,temperature: 0.7, max_tokens: 256)
        
        // headers
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(Constants.openAPIKey)"
        ]
        
        return Future{[weak self] promise in
            guard let self = self else {return }
            AF.request(self.baseUrl + "completions", method: .post, parameters: body, encoder: .json, headers: headers).responseDecodable(of: OpenAICompletionsResponse.self){ response in
                switch response.result {
                case .success (let result):
                    promise (.success (result))
                case .failure(let error):
                    promise(.failure (error))
                }
                
            }
            
        }.eraseToAnyPublisher()
    }
    // Body of what, our httpRequest??
    // the model we're using is the most capable, costs more and takes more tokens.
    // there are others you can use for generating code,
    
    
}
struct OpenAICompletionsBody: Encodable{
    let model: String
    let prompt: String
    let temperature: Float?
    let max_tokens: Int
}
struct OpenAICompletionsResponse : Decodable{
    let id : String
    let choices: [OpenAICompletionsChoice]
}
struct OpenAICompletionsChoice: Decodable {
    let text:String
}

//
//  ApiController.swift
//  randomuser
//
//  Created by 김상우 on 2023/05/06.
//

import Foundation

let TAG = "Black_K > "
let NOT_REACHABLE_ERROR = ErrorDto(error: ">>> 에러 : 네트워크 상태를 확인해 주세요. <<< ")
let JSON_PARSING_FAIL_ERROR = ErrorDto(error: ">>> 에러 : JSON PARSING 에러 <<< ")

class ApiController {
    
    static let shared = ApiController()
    
    private init() {}
    
    func randomUser(gender : String? ,reulsts onSuccess:@escaping(UsersDto) -> Void , onFailure:@escaping(ErrorDto)->Void) {
        
        let url = URL(string: "https://randomuser.me/api/?results=10")
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let request = NSMutableURLRequest(url: url!)
        
        request.httpMethod = "GET"
        request.timeoutInterval = TimeInterval(60)
        request.addValue("Application/json;Charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request as URLRequest) {data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse, let responseData = data else {
                print(">>> error : invalid http response Function : \(#function) <<<")
                onFailure(NOT_REACHABLE_ERROR)
                return
            }
            
            print(TAG, "httpResponse.statusCode > \(httpResponse.statusCode)")
            
            if httpResponse.statusCode < 200 || httpResponse.statusCode >= 500 {
                return
            } else if httpResponse.statusCode == 200 {
                do {
                    
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(UsersDto.self, from: responseData)
                    
                    onSuccess(result)
                    
                } catch let error {
                    print(TAG, #function, " parsing error : \(error)")
                    onFailure(JSON_PARSING_FAIL_ERROR)
                }
            } else {
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(ErrorDto.self, from:  responseData)
                    
                    onFailure(result)
                    
                } catch let error {
                    print(TAG, #function, " parsing error : \(error)")
                    onFailure(JSON_PARSING_FAIL_ERROR)
                }
                
            }
            
        }
        task.resume()
    }
    
}

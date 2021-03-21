//
//  SessionManager.swift
//  SwvlNetworking
//
//  Created by Mohamed Matloub on 6/10/20.
//  Copyright © 2018 Swvl Inc. All rights reserved.
//

import Alamofire

extension SessionManager {
    /// Returns the request session task to allow cancelling the request
    @discardableResult
    func request<V>(_ request: Request<V>, completion: @escaping (Swift.Result<V, NetworkError>) -> Void) -> URLSessionTask? {
        //Fix issue happened (error -999)  
        self.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            var credential: URLCredential?
                   if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                    disposition = URLSession.AuthChallengeDisposition.useCredential
                    credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                   } else {
                       if challenge.previousFailureCount > 0 {
                        disposition = .cancelAuthenticationChallenge
                       } else {
                        credential = self.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                           if credential != nil {
                            disposition = .useCredential
                           }
                       }
                   }
                   return (disposition, credential)
               }
        let dataRequest = self.request(request).validate().responseJSON { response in
            
            var result: Swift.Result<V, NetworkError>
            switch response.result {
            case .success(let value):
                print("Server Response")
                print(value)
                print("==================================================")
                guard let data = response.data,
                    let parsedResponse = request.parse(data) else {
                        result = .failure(.cannotParseResponse)
                        return
                }
                result = .success(parsedResponse)
            case .failure:
                result = .failure(.server)
            }
            completion(result)
        }
        return dataRequest.task
    }
}

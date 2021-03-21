//
//  HomeSceneInteractor.swift
//  The Hitchhiker Prophecy
//
//  Created by Mohamed Matloub on 6/13/20.
//  Copyright © 2020 SWVL. All rights reserved.
//

import Foundation
import CryptoKit

class HomeSceneInteractor: HomeSceneDataStore {
    
    let worker: HomeWorkerType
    let presenter: HomeScenePresentationLogic
    
    var result: Characters.Search.Results?
    
    init(worker: HomeWorkerType, presenter: HomeScenePresentationLogic) {
        self.worker = worker
        self.presenter = presenter
    }
}

extension HomeSceneInteractor: HomeSceneBusinessLogic {
    
    func getMD5(string : String)->String{
        let computed = Insecure.MD5.hash(data: string.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
    func fetchCharacters() {
        
        
        
        let ts = "1"
        let hash = getMD5(string: "\(ts)\(NetworkConstants.privateKey)\(NetworkConstants.publicKey)")
        let limit = HomeScene.Search.Constants.searchPageLimit
        let offset = result?.offset ?? 0
        let input = Characters.Search.Input(timeStamp: ts, apiKey: NetworkConstants.publicKey, hash: hash, offset: offset, limit: limit, orderBy: .modifiedDateDescending)
        
        worker.getCharacters(input) { [weak self] (result) in
            switch result {
            case .success(let value):
                var newData = value
                var oldCharacters = self?.result?.results ?? []
                oldCharacters.append(contentsOf: newData.data.results)
                newData.data.results = oldCharacters
                self?.result = newData.data
            case .failure(let error):
                print(error)
            }
            self?.presenter.presentCharacters(result)
        }
    }
}

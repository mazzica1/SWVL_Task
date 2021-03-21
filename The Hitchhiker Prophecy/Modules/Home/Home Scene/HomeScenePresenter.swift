//
//  HomeScenePresenter.swift
//  The Hitchhiker Prophecy
//
//  Created by Mohamed Matloub on 6/13/20.
//  Copyright © 2020 SWVL. All rights reserved.
//

import Foundation

class HomeScenePresneter: HomeScenePresentationLogic {
    weak var displayView: HomeSceneDisplayView?
    
    init(displayView: HomeSceneDisplayView) {
        self.displayView = displayView
    }
    
    func presentCharacters(_ response: HomeScene.Search.Response) {
        switch response {
        case .success(let characters):
            var viewModelArr: [HomeScene.Search.ViewModel] = []
            for character in characters.data.results {
                
                let imageUrl = "\(character.thumbnail.path)/standard_amazing.\(character.thumbnail.thumbnailExtension)"
                
                let characterVM = HomeScene.Search.ViewModel(name: character.name,
                                                                    desc: character.resultDescription,
                                                                    imageUrl: imageUrl,
                                                                    comics: character.comics.items.reduce(into: String(), { (result, object) in
                                                                        result.append(object.name)
                                                                    }),
                                                                    series: character.series.items.reduce(into: String(), { (result, object) in
                                                                        result.append(object.name)
                                                                    }),
                                                                    stories: character.stories.items.reduce(into: String(), { (result, object) in
                                                                        result.append(object.name)
                                                                    }),
                                                                    events: character.events.items.reduce(into: String(), { (result, object) in
                                                                        result.append(object.name)
                                                                    }))
                viewModelArr.append(characterVM)
            }
            displayView?.didFetchCharacters(viewModel: viewModelArr)
        case .failure(let error):
            displayView?.failedToFetchCharacters(error: error)
        }
    }
}

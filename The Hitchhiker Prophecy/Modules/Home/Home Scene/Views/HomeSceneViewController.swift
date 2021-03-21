//
//  HomeSceneViewController.swift
//  The Hitchhiker Prophecy
//
//  Created by Mohamed Matloub on 6/10/20.
//  Copyright © 2020 SWVL. All rights reserved.
//

import UIKit

class HomeSceneViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    var isHorizontal : Bool = true
    var interactor: HomeSceneBusinessLogic?
    var router: HomeSceneRoutingLogic?
    var viewModelArr: [HomeScene.Search.ViewModel] = []
    var HomeCharacterCollectionViewCellId :String = "HomeCharacterCollectionViewCell"
    var HomeCharacterCollectionViewCellNib :UINib = UINib( nibName: "HomeCharacterCollectionViewCell",bundle: nil)
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.fetchCharacters()
        collectionView.register(HomeCharacterCollectionViewCellNib, forCellWithReuseIdentifier: HomeCharacterCollectionViewCellId)
    }
    @IBAction @objc func changeLayoutTapped(_ sender: UIButton) {
        isHorizontal = !isHorizontal
        if isHorizontal {
            UIView.animate(withDuration: 10.0, delay: 0.0, options: .curveEaseIn, animations: { [self] in
                collectionViewFlowLayout.scrollDirection = .horizontal
            })
        } else {
            UIView.animate(withDuration: 10.0, delay: 0.0, options: .curveEaseIn, animations: { [self] in
                collectionViewFlowLayout.scrollDirection = .vertical
            })
            
        }
        //collectionView.reloadData()
    }
    //Data Source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModelArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCharacterCollectionViewCellId,
                                                      for: indexPath) as! HomeCharacterCollectionViewCell
        cell.configure( with: viewModelArr[indexPath.item])
        return cell
    }
    //Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        router?.routeToCharacterDetailsWithCharacter(at: indexPath.row)
    }
    //FlowLayout Delegate
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isHorizontal{
            return CGSize(width: collectionView.frame.width * (672.0/788.0), height: self.view.frame.size.height * (1200.0/1708.0))
        }else{
            return CGSize(width: collectionView.frame.width * (715.0/788.0), height: self.view.frame.size.height * (368.0/1708.0))
        }
        
    }
}

extension HomeSceneViewController: HomeSceneDisplayView {
    func didFetchCharacters(viewModel: [HomeScene.Search.ViewModel]) {
        // TODO: Implement
        viewModelArr = viewModel
        collectionView.reloadData()
    }
    
    func failedToFetchCharacters(error: Error) {
        // TODO: Implement
        print(error.localizedDescription)
    }
}

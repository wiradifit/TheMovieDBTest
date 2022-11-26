//
//  MovieDashboardViewController.swift
//  GLITechnicalTest
//
//  Created by Prawira Hadi Fitrajaya on 24/11/22.
//

import UIKit
import Foundation

class MovieDashboardViewController: UIViewController {
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    var page = 1
    
    lazy var viewModel: MovieDashboardViewModel = {
        return MovieDashboardViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        initViewModel()
    }
    
    func setupView() {
        navigationItem.title = "Discover Popular Movies"
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: 200, height: 300)
        
        moviesCollectionView.setCollectionViewLayout(layout, animated: true)
        moviesCollectionView.register(UINib(nibName: "MovieDashboardCell", bundle: nil), forCellWithReuseIdentifier: "MovieDashboardCell")
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
    }
    
    func initViewModel() {
        viewModel.getPopularMovies(page: page)
        
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }

        viewModel.reloadCollectionView = { [weak self] () in
            DispatchQueue.main.async {
                self?.moviesCollectionView.reloadData()
            }
        }
    }
    
    func fetchMoreMovieVM() {
        viewModel.getMorePopularMovies(page: page)
        
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        viewModel.reloadCollectionView = { [weak self] () in
            DispatchQueue.main.async {
                self?.moviesCollectionView.reloadData()
            }
        }
    }
    
    func showAlert( _ message: String ) {
        let dialogMessage = UIAlertController(title: "Error", message: message , preferredStyle: .alert)
        dialogMessage.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
}

extension MovieDashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieDashboardCell", for: indexPath) as! MovieDashboardCell
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        
        cell.cellViewModel = cellVM
        cell.clipsToBounds = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieVM = viewModel.getMovieResult(at: indexPath)
        
        let vc = MovieDetailsViewController(movieID: movieVM.id!)
        vc.movieResult = movieVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
        
        return CGSize(width:widthPerItem, height:300)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cellVM = viewModel.numberOfCells
        if indexPath.row == cellVM - 1 {
            page += 1
            fetchMoreMovieVM()
        }
    }
}

//
//  MovieDetailsViewController.swift
//  GLITechnicalTest
//
//  Created by Prawira Hadi Fitrajaya on 25/11/22.
//

import UIKit
import youtube_ios_player_helper
import ReadMoreTextView

class MovieDetailsViewController: UIViewController, YTPlayerViewDelegate {
     
     @IBOutlet weak var scrollView: UIScrollView!
     @IBOutlet weak var youtubePlayer: YTPlayerView!
     @IBOutlet weak var movieTitleLabel: UILabel!
     @IBOutlet weak var relaseDateLanguageLabel: UILabel!
     @IBOutlet weak var ratingVotesLabel: UILabel!
     @IBOutlet weak var overviewTextView: ReadMoreTextView!
     @IBOutlet weak var movieReviewsTable: UITableView!
     @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
     @IBOutlet weak var emptyReviewContainer: UIView!
     
     var movieID = Int()
     var youtubeVideosKey: [String] = []
     
     var movieResult: MovieResult?
     
     lazy var viewModel : MovieDetailsViewModel = {
          return MovieDetailsViewModel()
     }()
     
     convenience init(movieID: Int) {
          self.init()
          self.movieID = movieID
     }
     
     override func viewDidLoad() {
          super.viewDidLoad()
          updateTexts(movieResult)
          setupView()
          initViewModel()
     }
     
     func setupView() {
          navigationItem.title = "Movie Details"
          
          scrollView.delegate = self
          scrollView.bounces = false
          
          youtubePlayer.delegate = self
          
          movieReviewsTable.delegate = self
          movieReviewsTable.dataSource = self
          movieReviewsTable.isScrollEnabled = false
          movieReviewsTable.bounces = true
          movieReviewsTable.register(UINib(nibName: "MovieReviewCell", bundle: nil), forCellReuseIdentifier: "MovieReviewCell")
          movieReviewsTable.rowHeight = UITableView.automaticDimension
          movieReviewsTable.estimatedRowHeight = UITableView.automaticDimension
          
          let summaryFont = UIFont(name: "HelveticaNeue-Bold", size: 14)
          let summaryAttributes : Dictionary = [NSAttributedString.Key.font : summaryFont]
          
          overviewTextView.shouldTrim = true
          overviewTextView.maximumNumberOfLines = 2
          overviewTextView.textAlignment = .justified
          overviewTextView.attributedReadMoreText = NSAttributedString(string: "... Read more", attributes: summaryAttributes as [NSAttributedString.Key : Any])
          overviewTextView.attributedReadLessText = NSAttributedString(string: " Read less", attributes: summaryAttributes as [NSAttributedString.Key : Any])
     }
     
     func initViewModel() {
          viewModel.getYoutubeResult = { [weak self] response in
               DispatchQueue.main.async {
                    for youtubeKey in response {
                         self?.youtubeVideosKey.append(youtubeKey.key ?? "")
                    }
                    
                    if self?.youtubeVideosKey.count == 0{
                         self?.youtubePlayer.load(withVideoId: "")
                    } else {
                         self?.youtubePlayer.load(withVideoId: self?.youtubeVideosKey[0] ?? "")
                    }
               }
          }
          
          viewModel.setEmptyReviewContainer = { [weak self] reviews in
               DispatchQueue.main.async {
                    if reviews == 0 {
                         self?.emptyReviewContainer.isHidden = false
                         self?.movieReviewsTable.isHidden = true
                    }
               }
          }
          
          viewModel.getYoutubeTrailer(movieID: movieID)
          viewModel.getMoviesReview(movieID: movieID)
          viewModel.reloadTableView = { [weak self] in
               DispatchQueue.main.async {
                    self?.movieReviewsTable.reloadData()
               }
          }
     }
     
     private func updateTexts(_ movieResult: MovieResult?) {
          guard let result = movieResult else {
               return
          }
          
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd"
          let date = dateFormatter.date(from: result.releaseDate!)
          dateFormatter.dateFormat = "yyyy"
          let releaseDate = dateFormatter.string(from: date!)
          
          movieTitleLabel.text = result.title!
          self.relaseDateLanguageLabel.text = "\(releaseDate)"
          self.ratingVotesLabel.text = "\(result.voteAverage ?? 0)/10 · ‎" + "\(result.voteCount?.numberSeparator() ?? "") votes"
          self.overviewTextView.text = result.overview!
     }
     
     func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
          playerView.playVideo()
          if !youtubeVideosKey.isEmpty {
               youtubePlayer.loadPlaylist(byVideos: youtubeVideosKey, index: 0, startSeconds: 0)
          }
     }
}

extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return viewModel.movieReviewResults.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieReviewCell", for: indexPath) as? MovieReviewCell else {
               fatalError("xib does not exists") }
          let cellVM = viewModel.getCellViewModel(at: indexPath)
          
          cell.cellViewModel = cellVM
          
          return cell
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return UITableView.automaticDimension
     }
     
     func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
          return UITableView.automaticDimension
     }
     
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
          if scrollView == self.scrollView {
               movieReviewsTable.isScrollEnabled = (self.scrollView.contentOffset.y >= 200)
          }
          
          if scrollView == self.movieReviewsTable {
               self.movieReviewsTable.isScrollEnabled = (movieReviewsTable.contentOffset.y > 0)
          }
     }
}

//
//  MovieReviewCell.swift
//  GLITechnicalTest
//
//  Created by Prawira Hadi Fitrajaya on 26/11/22.
//

import UIKit
import ReadMoreTextView

class MovieReviewCell: UITableViewCell {
    
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorRatingLabel: UILabel!
    @IBOutlet weak var reviewTextView: ReadMoreTextView!
    
    var cellViewModel: MovieDetailsCellViewModel? {
        didSet {
            if cellViewModel?.authorName == "" {
                authorNameLabel.text = "from: Anonymous"
            } else {
                authorNameLabel.text = "from: \(cellViewModel?.authorName ?? "Anonymous") "
            }
            
            authorRatingLabel.text = "\(cellViewModel?.reviewRating ?? 0)/10"
            reviewTextView.text = cellViewModel?.authorReview
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reviewTextView.textAlignment = .justified
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorNameLabel.text =  nil
        authorRatingLabel.text = nil
        reviewTextView.text = nil
    }
    
}

//
//  MovieDashboardCell.swift
//  GLITechnicalTest
//
//  Created by Prawira Hadi Fitrajaya on 25/11/22.
//

import UIKit

class MovieDashboardCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: CustomImageView!
    
    var cellViewModel : MovieDashboardCellViewModel? {
        didSet {
            if let data = URL(string: cellViewModel?.posterImage ?? "") {
                imageView.loadImage(from: data)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    
    func initView() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        contentView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
}

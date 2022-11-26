//
//  CustomImageView.swift
//  GLITechnicalTest
//
//  Created by Prawira Hadi Fitrajaya on 25/11/22.
//
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView{
    
    let viewImage = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLayer = CAGradientLayer()
    var task: URLSessionDataTask!
    
    func loadImage(from url: URL) {
        image = nil
        
        addSpinnner()
        
        if let task = task{
            task.cancel()
        }
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage{
            image = imageFromCache
            removeSpiner()
            return
        }
 
        task = URLSession.shared.dataTask(with: url){ (data, response, error) in
            
            guard
                let data = data,
                let newImage = UIImage(data: data)
            else{
                print("couldn/t load image from url: \(url)")
                return
            }
            
            imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
            
            DispatchQueue.main.async {
                self.image = newImage
                self.removeSpiner()
            }
        }
        task.resume()
    }
    
    func addSpinnner(){
        addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        spinner.startAnimating()
    }
    
    func removeSpiner(){
        spinner.removeFromSuperview()
    }
}

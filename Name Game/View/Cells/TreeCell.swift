//
//  TreeCell.swift
//  Name Game
//
//  Created by Michal Hus on 5/16/20.
//  Copyright © 2020 Michal Hus. All rights reserved.
//

import UIKit

class TreeCell: UICollectionViewCell {
    
    var pictureData: Data?
    var loadingIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var treeImage: UIImageView!
    
    func activityIndicator() {
        loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.center = self.treeImage.center
        self.treeImage.addSubview(loadingIndicator)
    }
    
    func isLoading(_ indicator: Bool) {
        if indicator {
            self.activityIndicator()
            loadingIndicator.startAnimating()
            loadingIndicator.backgroundColor = .white
        } else {
            loadingIndicator.stopAnimating()
            loadingIndicator.hidesWhenStopped = true
        }
    }
    
    func downloadImage(from url: URL, imageSize: CGSize) {
        
        let session = URLSession(configuration: .default)
  
        let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
            if let e = error {
                print("Error downloading a picture: \(e.localizedDescription)")
            } else {
                if let res = response as? HTTPURLResponse {
                    print("Downloaded picture with response code \(res.statusCode)")
                    if let imageData = data {
                        DispatchQueue.main.async() {
                            guard let image = UIImage(data: imageData) else { return }
                            self.imageScalling(imageSize: imageSize, treeImage: image, overlayImage: nil)
                            self.pictureData = data
                        }
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        downloadPicTask.resume()
    }
    
    func updateImageGuess(imageSize: CGSize, correctGuess: Bool = true) {
        
        guard let pictureData = pictureData, let bottomImage = UIImage(data: pictureData) else { return }
        let overlayImage = guessOverlay(correctGuess: correctGuess)
        imageScalling(imageSize: imageSize, treeImage: bottomImage, overlayImage: overlayImage)
    }
    
    func imageScalling(imageSize: CGSize, treeImage: UIImage, overlayImage: UIImage?) {
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        treeImage.draw(in: CGRect(origin: CGPoint.zero, size: imageSize))
        if let overlayImage = overlayImage {
            overlayImage.draw(in: CGRect(origin: CGPoint.zero, size: imageSize ), blendMode: .normal, alpha: 0.5)
        }
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.isLoading(false)
        self.treeImage.image = scaledImage
    }
   
    func guessOverlay(correctGuess: Bool) -> UIImage {
        return correctGuess ? UIImage(named: "Frame 1")! : UIImage(named: "Frame 2")!
    }
}

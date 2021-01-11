//
//  RoundedImageView.swift
//  Upwork Monitor
//
//  Created by Sergei Zorko on 18/12/2019.
//  Copyright © 2019 Banarum. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    
    public func loadImageFromURL(url: String) {
        let imageURL = URL(string: url)!
        URLSession.shared.dataTask(with: imageURL) { (data, _, _) in
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}

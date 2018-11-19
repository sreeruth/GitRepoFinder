//
//  GRFResultCell.swift
//  GitRepoFinder
//
//  Created by EXI-Ruthala, Sreekanth on 11/18/18.
//  Copyright © 2018 SelfOrg. All rights reserved.
//

import Foundation
import UIKit

class GRFResultCell: UITableViewCell {
    
    @IBOutlet weak var repoLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var starsLabel: UILabel!
    
    func loadCell(with edge: Edge) {
        self.repoLabel.text = "repo: \(edge.node.name ?? "" )"
        self.ownerLabel.text = "name: \(edge.node.owner.login ?? "" )"
        self.starsLabel.text = "\(edge.node.stargazers.totalCount ?? 0) Stars"
        self.loadAvatar(with: edge.node.owner.avatarUrl)
    }
    
    func loadAvatar(with urlString: String) {
        guard let url = URL.init(string: urlString) else {
            return
        }
        let request = URLRequest.init(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
            guard let strongSelf = self else { return }
            if let error = error { print(error); return }
            guard let data = data else { print("Data is missing."); return }
            if let image = UIImage.init(data: data) {
                DispatchQueue.main.async {
                    let resizedImage = UIImage.scale(image: image, toSize: strongSelf.avatarView.frame.size)
                    strongSelf.imageView?.image = resizedImage
                    strongSelf.imageView?.clipsToBounds = true
                }
            }
        })        
        task.resume()
    }
}

extension UIImage {
    
    @objc static func scale(image: UIImage, toSize:CGSize) -> UIImage? {
        var newImage: UIImage?
        let scale = toSize.height / image.size.height
        let newWidth = image.size.width * scale
        UIGraphicsBeginImageContext(CGSize.init(width: newWidth, height: toSize.height))
        image.draw(in: CGRect.init(x: 0, y: 0, width: newWidth, height: toSize.height))
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

//
//  CustomImageView.swift
//  TaskOne
//
//  Created by Zulqarnain on 19/02/2022.
//

import Foundation
import UIKit



class CustomImageView: UIImageView
{
    private var counter = 0
    private let imageCache = NSCache<AnyObject, UIImage>()

    func loadImage(fromURL imageURL: URL)
    {
        if let cachedImage = self.imageCache.object(forKey: imageURL as AnyObject)
        {
            debugPrint("image loaded from cache for =\(imageURL)")
            self.image = cachedImage
            return
        }

        DispatchQueue.global().async {
            [weak self] in

            if let imageData = try? Data(contentsOf: imageURL)
            {
                debugPrint("image downloaded from server...")
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
                if let image = UIImage(data: imageData)
                {
                    DispatchQueue.main.async {
                        self!.imageCache.setObject(image, forKey: imageURL as AnyObject)
                        self?.image = image
                    }
                }
            }
        }
    }
}

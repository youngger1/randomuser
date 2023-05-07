//
//  UIImageView+Extension.swift
//  randomuser
//
//  Created by 김상우 on 2023/05/07.
//

import Foundation
import Kingfisher

extension UIImageView {
    
    
    func setProfileImageGET(urlString: String, completionHandler: ((UIImage?) -> Void)?) {
        let processor = ResizingImageProcessor(referenceSize: CGSize(width: 50, height: 50)) |> RoundCornerImageProcessor(cornerRadius: 25)
        let placeholder = UIImage(systemName: "person.circle.fill")
        
        if let encodedPath =
            "\(urlString)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedPath) {
            
            self.kf.indicatorType = .activity
            
            let cache = ImageCache.default
            
            if cache.isCached(forKey: url.cacheKey) {
                cache.retrieveImage(forKey: url.cacheKey, options: [.processor(processor)]) { result in
                    switch result {
                    case .success(let value):
                        if let cacheImage = value.image {
                            self.image = cacheImage
                            completionHandler?(cacheImage)
                        } else {
                            completionHandler?(nil)
                        }
                    case .failure( _):
                        completionHandler?(nil)
                    }
                }
            } else {
                self.kf.setImage(with: url, placeholder: placeholder, options: [.processor(processor), .cacheOriginalImage,.memoryCacheExpiration(.seconds(60)), .diskCacheExpiration(.seconds(60)), .cacheSerializer(FormatIndicatedCacheSerializer.png)], progressBlock: nil) { result in
                    switch result {
                    case .success(let value):
                        completionHandler?(value.image)
                        
                    case .failure( _):
                        completionHandler?(nil)
                    }
                }
            }
        } else {
            completionHandler?(nil)
        }
    }
    
    
}

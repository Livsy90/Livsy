//
//  WebImageView.swift
//  Livsy
//
//  Created by Artem on 21.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

extension UIImage {
    var thumbnail: UIImage? {
    guard let imageData = self.pngData() else { return nil }

    let options = [
        kCGImageSourceCreateThumbnailWithTransform: true,
        kCGImageSourceCreateThumbnailFromImageAlways: true,
        kCGImageSourceThumbnailMaxPixelSize: 200
    ] as CFDictionary

    guard let source = CGImageSourceCreateWithData(imageData as CFData, nil) else { return nil }
    guard let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options) else { return nil }

    return UIImage(cgImage: imageReference)
  }
}

final class WebImageView: UIImageView {
    
    private var currentUrlString: String?
    
    func set(imageURL: String?, isThumbnail: Bool) {
        
        currentUrlString = imageURL
        
        guard let imageURL = imageURL, let url = URL(string: imageURL) else {
            self.image = nil
            return }
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cachedResponse.data)
            return
        }
                
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            DispatchQueue.main.async {
                if let data = data, let response = response {
                    self?.handleLoadedImage(
                        data: data,
                        response: response,
                        isThumbnail: isThumbnail
                    )
                }
            }
        }
        dataTask.resume()
    }
    
    private func handleLoadedImage(
        data: Data,
        response: URLResponse,
        isThumbnail: Bool
    ) {
        guard let responseURL = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
        if responseURL.absoluteString == currentUrlString {
            let image = UIImage(data: data)
            if isThumbnail {
                self.image = image?.thumbnail
            } else {
                self.image = image
            }
        }
    }
    
}


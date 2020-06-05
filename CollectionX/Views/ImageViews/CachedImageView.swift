//
//  CachedImageView.swift
//  CollectionX
//
//  Created by Yevhenii on 15.05.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit

open class CachedImageView: UIImageView {

    static var imageCache = NSCache<NSString, DiscardableImageContent>()

    var urlStringForChecking: String?
    var imagePlaceholder: UIImage?

    public init(cornerRadius: CGFloat = 0, placeholder: UIImage? = nil) {
        super.init(frame: .zero)
        imagePlaceholder = placeholder
        layer.cornerRadius = cornerRadius
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open func downloadImage(stringUrl: String?, completion: (() -> ())? = nil) {

        self.image = imagePlaceholder

        guard let stringUrl = stringUrl else { return }

        urlStringForChecking = stringUrl

        let stringUrlKey = NSString(string: stringUrl)

        if let cachedeImage = CachedImageView.imageCache.object(forKey: stringUrlKey) {
            image = cachedeImage.image
            completion?()
            return
        }

        guard let url = URL(string: stringUrl) else { return }

        self.image = self.imagePlaceholder

        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in

            if error != nil {
                print(error!)
                return
            }

            guard let data = data, let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                CachedImageView.imageCache.setObject(DiscardableImageContent(image: image), forKey: stringUrlKey)
                if stringUrl == self?.urlStringForChecking {
                    self?.image = image
                    completion?()
                }
            }

        }.resume()
    }

}

class DiscardableImageContent: NSObject, NSDiscardableContent {

    private(set) public var image: UIImage?
    var accessCount: UInt = 0

    public init(image: UIImage) {
        self.image = image
    }

    public func beginContentAccess() -> Bool {
        if image == nil {
            return false
        }

        accessCount += 1
        return true
    }

    public func endContentAccess() {
        if accessCount > 0 {
            accessCount -= 1
        }
    }

    public func discardContentIfPossible() {
        if accessCount == 0 {
            image = nil
        }
    }

    public func isContentDiscarded() -> Bool {
        return image == nil
    }
}


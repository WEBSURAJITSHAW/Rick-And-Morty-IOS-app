//
//  Extension + UIImageView.swift
//  Test App
//
//  Created by Surajit Shaw on 01/06/25.
//

import UIKit

extension UIImageView {
    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        // Set a placeholder if provided
        if let placeholder = placeholder {
            self.image = placeholder
        }

        // Validate the URL
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }

        // Perform network request on background thread
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // Ensure there is image data and no error
            guard let self = self, let data = data, error == nil,
                  let image = UIImage(data: data) else {
                print("Failed to load image from URL: \(url)")
                return
            }

            // Update UI on the main thread
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}

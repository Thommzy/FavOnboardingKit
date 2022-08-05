//
//  Slide.swift
//  
//
//  Created by Timothy Obeisun on 7/11/22.
//

import UIKit

public struct Slide {
    public let image: UIImage?
    public let title: String
    
    public init(image: UIImage?,
                title: String) {
        self.image = image
        self.title = title
    }
}

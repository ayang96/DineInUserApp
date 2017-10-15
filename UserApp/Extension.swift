//
//  Extension.swift
//  UserApp
//
//  Created by Alex Yang on 7/16/17.
//  Copyright © 2017 Alex Yang. All rights reserved.
//

import Foundation
import UIKit

func getImageFromURL(imgurl: URL) -> UIImage?{
    var returnimage:UIImage?
    getDataFromUrl(url: imgurl) { (data,response, error) in
        returnimage = UIImage(data: data!)
    }
    return returnimage
}

func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
    URLSession.shared.dataTask(with: url) {
        (data, response, error) in
        completion(data, response, error)
        }.resume()
}

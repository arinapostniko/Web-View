//
//  ViewController + TextField.swift
//  Web View
//
//  Created by Arina Postnikova on 19.11.22.
//

import UIKit

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var link = textField.text ?? ""
        if !link.contains("http") {
            link = "https://\(link)"
        }
        guard let url = URL(string: link) else { return false }
        UserDefaults.standard.set(link, forKey: "lastURL")

        let request = URLRequest(url: url)
        webView.load(request)
        
        return true
    }
}

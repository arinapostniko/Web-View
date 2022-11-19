//
//  ViewController.swift
//  Web View
//
//  Created by Arina Postnikova on 13.11.22.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressView: UIProgressView!
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerKeyboardNotifications()
        
        textField.delegate = self
        
        progressView.isHidden = true
        progressView.setProgress(0, animated: false)
        
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil
        )
        
        openLastURL()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            let progress = Float(webView.estimatedProgress)
            if progress > 0.999 {
                progressView.isHidden = true
                progressView.setProgress(0, animated: false)
            } else {
                progressView.isHidden = false
                progressView.setProgress(progress, animated: true)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private methods
    private func openLastURL() {
        if let lastURL = UserDefaults.standard.string(forKey: "lastURL"),
           let url = URL(string: lastURL) {
            let request = URLRequest(url: url)
            textField.text = lastURL
            webView.load(request)
        }
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    @objc func keyboardWillShow(_ notification: Foundation.Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }

        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size

        bottomConstraint.constant = keyboardSize.height - 35
        view.layoutIfNeeded()
    }

    @objc func keyboardWillHide(_ notification: Foundation.Notification) {
        bottomConstraint.constant = 0
        view.layoutIfNeeded()
    }

    // MARK: - IBActions
    @IBAction func backButton(_ sender: Any) {
        webView.goBack()
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        webView.reload()
    }
    
    @IBAction func forwardButton(_ sender: Any) {
        webView.goForward()
    }
}


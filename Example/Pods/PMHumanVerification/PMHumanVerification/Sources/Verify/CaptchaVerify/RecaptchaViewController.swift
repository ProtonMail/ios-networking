//
//  RecaptchaViewController.swift
//  ProtonMail - Created on 12/17/15.
//
//
//  Copyright (c) 2019 Proton Technologies AG
//
//  This file is part of ProtonMail.
//
//  ProtonMail is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  ProtonMail is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with ProtonMail.  If not, see <https://www.gnu.org/licenses/>.

#if canImport(UIKit)
import UIKit
import PMCommon
import PMUIFoundations
import PMCoreTranslation

class RecaptchaViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var verifyingLabel: UILabel!
    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!

    fileprivate var startVerify: Bool = false
    fileprivate var finalToken: String?

    var viewModel: HumanCheckViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColorManager.BackgroundNorm
        webView.scrollView.isScrollEnabled = false
        stackView.isHidden = true
        loadNewCaptcha()
    }

    func loadNewCaptcha() {
        URLCache.shared.removeAllCachedResponses()
        let requestObj = URLRequest(url: viewModel.getCaptchaURL())
        webView.loadRequest(requestObj)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }

    func checkCaptcha() {
        guard let finalToken = self.finalToken else { return }
        stackView.isHidden = false
        self.viewModel.finalToken(token: finalToken, complete: { (res, error) in
            DispatchQueue.main.async {
                self.stackView.isHidden = true
                if res {
                    self.navigationController?.dismiss(animated: true, completion: nil)
                } else {
                    if let error = error {
                        let banner = PMBanner(message: error.localizedDescription, style: PMBannerNewStyle.error, dismissDuration: Double.infinity)
                        banner.addButton(text: CoreString._hv_ok_button) { _ in
                            banner.dismiss()
                            self.loadNewCaptcha()
                        }
                        banner.show(at: .topCustom(.baner), on: self)
                    }
                }
            }
        })
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        let urlString = request.url?.absoluteString

        if urlString?.contains("https://www.google.com/recaptcha/api2/frame") == true {
            startVerify = true
        }

        if urlString?.contains(".com/fc/api/nojs") == true {
            startVerify = true
        }
        if urlString?.contains("fc/apps/canvas") == true {
            startVerify = true
        }

        if urlString?.contains("about:blank") == true {
            startVerify = true
        }

        if urlString?.contains("https://www.google.com/intl/en/policies/privacy") == true {
            return false
        }

        if urlString?.contains("how-to-solve-") == true {
            return false
        }
        if urlString?.contains("https://www.google.com/intl/en/policies/terms") == true {
            return false
        }

        if urlString?.range(of: "https://secure.protonmail.com/expired_recaptcha_response://") != nil {
            resetWebviewHeight()
            webView.reload()
            return false
        } else if urlString?.range(of: "https://secure.protonmail.com/captcha/recaptcha_response://") != nil {
            if let token = urlString?.replacingOccurrences(of: "https://secure.protonmail.com/captcha/recaptcha_response://", with: "", options: NSString.CompareOptions.widthInsensitive, range: nil) {
                self.finalToken = token
            }
            resetWebviewHeight()
            checkCaptcha()
            return false
        }
        return true
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        if startVerify {
            if webView.stringByEvaluatingJavaScript(from: "document.body.scrollHeight;") != nil {
                let height = CGFloat(500)
                webViewHeightConstraint.constant = height
            }
            startVerify = false
        }
    }

    func resetWebviewHeight() {
        if webView.stringByEvaluatingJavaScript(from: "document.body.scrollHeight;") != nil {
            let height = CGFloat(85)
            webViewHeightConstraint.constant = height
        }
    }

    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {

    }
}

#endif

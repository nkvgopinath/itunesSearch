//
//  SSLPinning.swift
//  itunesapi
//
//  Created by Gopinath Vaiyapuri on 21/11/24.
//

import Foundation

class SSLPinning: NSObject, URLSessionDelegate {

    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        guard let serverCertificate = getServerCertificate(from: serverTrust) else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        let serverCertiData = SecCertificateCopyData(serverCertificate) as Data

        guard let pinnedCertiPath = Bundle.main.path(forResource: "itunes_cert", ofType: "cer"),
              let pinnedCertiData = try? Data(contentsOf: URL(fileURLWithPath: pinnedCertiPath)) else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        if serverCertiData == pinnedCertiData {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }

    func getServerCertificate(from serverTrust: SecTrust) -> SecCertificate? {
        if #available(iOS 15.0, *) {
            guard let certificates = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate] else {
                return nil
            }
            return certificates.first
        } else {
            return SecTrustGetCertificateAtIndex(serverTrust, 0)
        }
    }
    
}

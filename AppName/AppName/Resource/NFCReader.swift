//
//  NFCReader.swift
//  Gari
//
//  Created by hanseoyoung on 10/25/24.
//

import CoreNFC

class NFCReader: NSObject, NFCTagReaderSessionDelegate {
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {

    }

    var session: NFCTagReaderSession?
    var completion: (Result<(String, String), Error>) -> Void

    init(completion: @escaping (Result<(String, String), Error>) -> Void) {
        self.completion = completion
        super.init()
    }

    func beginScanning() {
        session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self, queue: nil)
        session?.alertMessage = "Hold your iPhone near an NFC tag."
        session?.begin()
    }

    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        completion(.failure(error))
    }

    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        guard let firstTag = tags.first else {
            session.invalidate(errorMessage: "No NFC tag found.")
            return
        }

        session.connect(to: firstTag) { error in
            if let error = error {
                self.completion(.failure(error))
                session.invalidate(errorMessage: error.localizedDescription)
                return
            }

            switch firstTag {
            case let .miFare(tag):
                let serialNumber = tag.identifier.map { String(format: "%.2hhx", $0) }.joined()

                let message = "MIFARE"
                self.completion(.success((message, serialNumber)))
                session.invalidate()

            default:
                session.invalidate(errorMessage: "78계단이 아님")
            }
        }
    }
}
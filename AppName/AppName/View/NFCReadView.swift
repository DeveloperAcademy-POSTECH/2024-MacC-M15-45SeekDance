//
//  NFCReadView.swift
//  Gari
//
//  Created by hanseoyoung on 10/24/24.
//

import SwiftUI
import CoreNFC

struct NFCReadView: View {
    @State private var nfcMessage: Int = 0
    @State private var nfcReader: NFCReader?

    var body: some View {
        VStack {
            Text("\(nfcMessage)")
                .padding()
                .font(.headline)

            Button("Read NFC Tag") {
                nfcReader = NFCReader { result in
                    switch result {
                    case .success((let message, let serialNumber)):
                        if serialNumber == "04d1c489230289" {
                            nfcMessage += 1
                        }
                        print(serialNumber)
                    case .failure(let error):
                        nfcMessage = nfcMessage
                    }
                }
                nfcReader?.beginScanning()
            }
            .padding()
        }
    }
}

// MARK: - NFCReader


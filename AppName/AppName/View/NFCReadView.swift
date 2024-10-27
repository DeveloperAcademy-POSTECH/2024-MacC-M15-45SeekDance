//
//  NFCReadView.swift
//  Gari
//
//  Created by hanseoyoung on 10/24/24.
//

import SwiftUI
import CoreNFC

struct NFCReadView: View {
    @State private var nfcCount: Int = 0
    @State private var nfcReader: NFCReader?
    @State private var nfcMessage: String = ""
    @State private var isButtonEnabled: Bool = true

    var body: some View {
        VStack {
            Text("\(nfcMessage)")
                .padding()
                .font(.headline)

            Button("Read NFC Tag") {
                // TODO: - success 시에 시리얼 넘버 비교 이후 유효하면 게임센터에 계단 층수 추가 로직 필요.
                nfcReader = NFCReader { result in
                    switch result {
                    case .success((let message, let serialNumber)):
                        (nfcMessage, nfcCount) = findNFCSerialNuber(serialNumber: serialNumber)
                        print(serialNumber)
                        if nfcCount != 0 {
                            sampleStepModels.append(StairStepModel(stairType: message, stairStepDate: Date()))
                        }
                    case .failure(let error):
                        nfcMessage = nfcMessage
                    }
                }
                nfcReader?.beginScanning()
            }
            .padding()
            .disabled(!isButtonEnabled)
            .onAppear {
                startTimer()
            }
        }
    }

    // MARK: - 타이머
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            updateButtonState()
        }
    }

    // TODO: - 버튼 시간에 따른 업데이트 함수. SwiftData형식으로 변경 필요
    func updateButtonState() {
        if let lastStep = sampleStepModels.last {
            // 임의로 5초 설정
            isButtonEnabled = Date().timeIntervalSince(lastStep.stairStepDate) >= 5
        } else {
            isButtonEnabled = true
        }
    }

    // MARK: - 시리얼 정보를 통해 계단 찾기
    func findNFCSerialNuber(serialNumber: String) -> (String, Int) {
        if gariStairs.contains(where: { $0.serialNumber == serialNumber }) {
            let stair = gariStairs.first(where: { $0.serialNumber == serialNumber })!
            return (stair.name, stair.numberOfStairs)
        } else {
            return ("지원되지 않는 NFC입니다", 0)
        }
    }
}

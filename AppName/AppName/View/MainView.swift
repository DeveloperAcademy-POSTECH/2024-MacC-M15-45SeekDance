//
//  MainView.swift
//  Gari
//
//  Created by heesohee on 10/28/24.
//

import SwiftUI
import CoreNFC

struct MainView: View {
    @State var showSheet2: Bool = false
    @State private var nfcReader: NFCReader?
    @State private var nfcCount: Int = 0
    @State private var nfcMessage: String = ""
    @State private var isButtonEnabled: Bool = true


    var body: some View {
        ZStack {
            // Background
            Color.back.ignoresSafeArea()

            VStack (alignment: .center) { // VStack 전체

                VStack { // 당기면 보이는 값 위치
                    Text("7 회")
                        .fontWeight(.semibold)
                        .font(.subheadline)
                }
                .padding(.bottom, 10)

                VStack (alignment: .center) { // 흰 카드 안 콘텐츠 (텍스트, 이미지, 서클, 버튼 두개)

                    Text("엘리베이터 대신 \n계단 이용하기!")
                        .multilineTextAlignment(.center)
                        .fontWeight(.regular)
                        .font(.title2)
                        .padding(.top, 20)

                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.back)
                        .frame(width: 240, height: 240)
                        .padding(.top, 10)

                    HStack (spacing: 16) { // 서클
                        ZStack {
                            Circle()
                                .frame(width: 52, height: 52)
                                .foregroundColor(.gray)
                            Text("1회")
                                .foregroundColor(.white) // 텍스트 색상 설정
                        }

                        ZStack {
                            Circle()
                                .frame(width: 52, height: 52)
                                .foregroundColor(.gray)
                            Text("2회")
                                .foregroundColor(.white)
                        }

                        ZStack {
                            Circle()
                                .frame(width: 52, height: 52)
                                .foregroundColor(.gray)
                            Text("3회")
                                .foregroundColor(.white)
                        }
                    } // HStack
                    .padding(.top, 30)


                    VStack (alignment: .center) {
                        Button {
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
                        } label: {
                            Text("NFC 태깅하기")
                                .foregroundColor(.white)
                                .font(.body)
                                .fontWeight(.regular)
                                .frame(width: 264, height: 50)
                                .background(Color.indigo)
                                .cornerRadius(12)
                        }
                        .disabled(!isButtonEnabled)
                        .onAppear {
                            startTimer()
                        }

                        Button {
                            showSheet2.toggle()
                        } label: {
                            Image(systemName: "info.square.fill")
                                .foregroundColor(.secondary)
                            Text("NFC 태깅 방법")
                                .foregroundColor(.secondary)
                                .font(.footnote)
                        }
                        .sheet(isPresented: $showSheet2) {
                            ExplainView()
                                .presentationDragIndicator(.visible)
                                .presentationDetents([.large])
                        }
                        .padding(.top, 16) // 아래 버튼

                    } // Vstack 버튼 두개 만
                    .padding(.top, 24)
                    .padding(.bottom, 20)

                } // VStack // 흰 카드
                .frame(width: 320, height: 580)
                .background(Color.white)
                .cornerRadius(20)

                // HStack 버튼
                HStack {
                    Button {
                        // action
                    } label: {
                        Image(systemName: "figure.stairs")
                        Text("달성 뱃지")

                    }
                    .frame(height: 50)
                    .frame(width: 152)
                    .foregroundColor(Color.blue)
                    .background(Color.buttons)
                    .cornerRadius(12)

                    Spacer()

                    Button {
                        // action
                    } label: {
                        Image(systemName: "figure.stairs")
                        Text("나의 순위")
                    }
                    .frame(height: 50)
                    .frame(width: 152)
                    .foregroundColor(Color.blue)
                    .background(Color.buttons)
                    .cornerRadius(12)
                } // HStack // 아래 두개 버튼
                .padding(.top, 20)


            } // VStack 전체
            .padding(.horizontal, 40)
            .padding(.top, 90)
            .padding(.bottom, 70)
        } // ZStack // 배경색
    } // View

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
            isButtonEnabled = Date().timeIntervalSince(lastStep.stairStepDate) >= 10
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



#Preview {
    MainView()
}

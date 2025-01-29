//
//  NewBirdView.swift
//  StepSquad
//
//  Created by Groo on 1/21/25.
//

import SwiftUI
import EffectsLibrary
import RiveRuntime

struct ShowNewBirdView: View {
    @State var timeCount = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var opacity1 = 1.0
    @State var opacity2 = 0.0
    @State var opacity3 = 0.0
    var body: some View {
        ZStack {
            ItemsConfettiView()
                .opacity(opacity1)
                .animation(.linear(duration: 1), value: opacity1)
            EmptyNestView()
                .opacity(opacity2)
                .animation(.linear(duration: 1), value: opacity2)
            NewBirdView()
                .opacity(opacity3)
                .animation(.linear(duration: 1), value: opacity3)
        }
        .onReceive(timer) { _ in
            timeCount += 1
            if timeCount == 1 {
                opacity1 = 0.0
                opacity2 = 1.0
            } else if timeCount == 8 {
                opacity2 = 0.0
                opacity3 = 1.0
            }
        }
    }
}

#Preview {
    ShowNewBirdView()
}

extension View {
    // This function changes our View to UIView, then calls another function
    // to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        // Set the background to be transparent incase the image is a PNG, WebP or (Static) GIF
        controller.view.backgroundColor = .clear
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
        // here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
    // This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

struct ItemsConfettiView: View {
    var body: some View {
        ZStack {
            ConfettiView(config:
                            ConfettiConfig(
                                content: [
                                    .image(Image("1_Gamcho").asUIImage(), .white, 0.02),
                                    .image(Image("2_Daechu").asUIImage(), .white, 0.02),
                                    .image(Image("3_Saenggang").asUIImage(), .white, 0.02),
                                    .image(Image("4_Doraji").asUIImage(), .white, 0.02),
                                    .image(Image("8_Chik").asUIImage(), .white, 0.02),
                                    .image(Image("9_Oksususuyeom").asUIImage(), .white, 0.02),
                                    .image(Image("10_Insam").asUIImage(), .white, 0.02),
                                    .image(Image("12_Gugija").asUIImage(), .white, 0.02),
                                    .image(Image("13_Sansuyu").asUIImage(), .white, 0.02),
                                ]
                            )
            )
            VStack {
                Spacer()
                VStack {
                    HStack(spacing: 0) {
                        Text("\(123)")
                            .foregroundStyle(Color(hex: 0x7EB55D))
                        Text("일 동안")
                        Text(" \(1449)")
                            .foregroundStyle(Color(hex: 0x7EB55D))
                        Text("층을")
                    }
                    Text("함께 오른 틈새가")
                    Text("하산을 했어요!")
                }
                .multilineTextAlignment(.center)
                .font(.title)
                .fontWeight(.bold)
                Image("Down1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 256)
                Spacer()
            }
        }
    }
}

struct EmptyNestView: View {
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                VStack {
                    Text("틈새가 떠나")
                    Text("빈 둥지가 되었어요")
                }
                .font(.title)
                .fontWeight(.bold)
                Text("앗 뭐지??")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(hex: 0x638D48))
            }
            RiveViewModel(fileName: "reset").view()
        }
    }
}

struct NewBirdView: View {
    var body: some View {
        VStack {
            VStack {
                Text("하산한 틈새가 떠나고")
                HStack(spacing: 0) {
                    Text("새로운 틈새")
                        .foregroundStyle(Color(hex: 0x7EB55D))
                    Text("가 왔어요!")
                }
            }
            .font(.title)
            .fontWeight(.bold)
            Text("같은 틈새 아닌가 하는 마음이 든다면 그건 착각이에요")
                .frame(width: 256)
            Image("ResultIMG")
                .resizable()
                .scaledToFit()
                .frame(width: 256)
        }
        .multilineTextAlignment(.center)
    }
}

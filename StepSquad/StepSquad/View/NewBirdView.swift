//
//  NewBirdView.swift
//  StepSquad
//
//  Created by Groo on 1/21/25.
//

import SwiftUI
import EffectsLibrary

struct NewBirdView: View {
    @State var timeCount = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var opacity1 = 1.0
    @State var opacity2 = 0.0
    var body: some View {
        ZStack {
            ItemsConfettiView()
                .opacity(opacity1)
                .animation(.linear(duration: 1), value: opacity1)
            EmptyNestView()
                .opacity(opacity2)
                .animation(.linear(duration: 1), value: opacity2)
        }
        .onReceive(timer) { _ in
            timeCount += 1
            if timeCount == 5 {
                opacity1 = 0.0
                opacity2 = 1.0
            }
        }
    }
}

#Preview {
    NewBirdView()
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
        Text("Empty Nest")
    }
}

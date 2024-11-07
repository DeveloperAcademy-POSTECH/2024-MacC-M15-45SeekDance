//
//  MessagesViewController.swift
//  StepSquadStickers
//
//  Created by hanseoyoung on 11/7/24.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let stickers = ["bearSticker0", "bearSticker1", "bearSticker2", "bearSticker3"]
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: UICollectionViewFlowLayout 설정
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        // MARK: UICollectionView 설정
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")

        // MARK: 컬렉션 뷰 추가
        view.addSubview(collectionView)
    }

    // MARK: UICollectionViewDataSource 메서드
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stickers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let stickerName = stickers[indexPath.item]

        // MARK: UIImageView로 스티커 이미지 설정
        let imageView = UIImageView(image: UIImage(named: stickerName))
        imageView.contentMode = .scaleAspectFit
        cell.contentView.addSubview(imageView)
        imageView.frame = cell.contentView.bounds

        return cell
    }

    // MARK: UICollectionViewDelegate 메서드
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let stickerName = stickers[indexPath.item]
        if let stickerImage = UIImage(named: stickerName) {
            addStickerToConversation(stickerImage)
        }
    }

    func addStickerToConversation(_ image: UIImage) {
        guard let conversation = activeConversation else { return }

        do {
            let sticker = try MSSticker(contentsOfFileURL: saveImageToFile(image), localizedDescription: "Sticker")
            let message = MSMessage()
            message.layout = MSMessageTemplateLayout()
            (message.layout as! MSMessageTemplateLayout).image = image

            conversation.insert(sticker, completionHandler: nil)
        } catch {
            print("Failed to create sticker: \(error)")
        }
    }

    // MARK: - UIImage를 임시 파일에 저장하는 함수
    func saveImageToFile(_ image: UIImage) -> URL {
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("png")
        if let data = image.pngData() {
            try? data.write(to: fileURL)
        }
        return fileURL
    }
}

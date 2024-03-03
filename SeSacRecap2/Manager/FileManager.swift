//
//  FileManager.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/28/24.
//

import UIKit

enum FileInfoManagerError: Error {
    case documentsError
    case noData
    case canMakeImage
    
    var message: String {
        switch self {
        case .canMakeImage:
            return "이미지를 생성하지 못했어요!"
        case .documentsError:
            return "파일경로를 찾지 못했어요!"
        case .noData:
            return "파일을 찾지 못했어요!"
        }
    }
}

final class FileInfoManager {
    private init() {}
    static let shared = FileInfoManager()
    
    private let defaults = FileManager.default
    // 도큐먼트 위치
    lazy var documents = defaults.urls(for: .documentDirectory, in: .userDomainMask).first
    
    func saveImage(imageData: Data?, imageName: String) -> Result<Void, FileInfoManagerError> {
        guard let documents else {return .failure(.documentsError)}
        let file = "\(imageName).jpeg"
        let fileUrl = documents.appendingPathComponent(file)
        guard let imageData else {return .failure(.noData)}
        do{
            try imageData.write(to: fileUrl)
            return .success(())
        } catch {
            return .failure(.canMakeImage)
        }
    }
    
    
    func loadImageToDocuments(fileNameOfID: String) -> UIImage?{
        let file = "\(fileNameOfID).jpeg"
        let fileUrl = documents?.appendingPathComponent(file)
        guard let fileUrl else {return nil}
        if defaults.fileExists(atPath: fileUrl.path) {
            return UIImage(contentsOfFile: fileUrl.path)
        }else {
            return nil
        }
    }
    
}

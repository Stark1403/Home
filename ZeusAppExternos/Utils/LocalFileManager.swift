//
//  LocalFileManager.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 30/11/23.
//

import Foundation
import UIKit
import ZeusSessionInfo

enum LocalFileManagerFolder: String {
    case profilePhoto = "profilePhoto"
}

enum LocalFileManagerFileNames: String {
  case profilePhoto = "profile.jpeg"
}

public final class LocalFileManager{
    
    public static var shared = LocalFileManager()
    public var mainDirectory = URL(string: "")
    
    private init(){
        setURLDirectory()
    }
    
    func setURLDirectory(){
        mainDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("userData")
            .appendingPathComponent(SessionInfo.shared.user?.zeusId ?? "guest")
    }
   

    func downloadFile(urlString: String, subDirectory: LocalFileManagerFolder, fileName: LocalFileManagerFileNames, completion: @escaping (UIImage?, Error?) -> Void) {
        
        guard let url = URL(string: urlString) else{ return }
        
        guard let directory = mainDirectory?.appendingPathComponent(subDirectory.rawValue) else{
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, nil)
                return
            }

            do {
                try FileManager.default.createDirectory(atPath: directory.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                completion(nil, error)
            }
            
            do {
              let fileURL = directory.appendingPathComponent(fileName.rawValue)
                try data!.write(to: fileURL)
                DispatchQueue.main.async {
                    if let data = data{
                        completion(UIImage(data: data), nil)
                    }
                }
            } catch  {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func storeFile(data: Data, subDirectory: LocalFileManagerFolder, fileName: String){
        
        guard let directory = mainDirectory?.appendingPathComponent(subDirectory.rawValue) else{
            return
        }

        do {
            try FileManager.default.createDirectory(atPath: directory.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            debugPrint(error)
        }
        
        do {
            let fileURL = directory.appendingPathComponent(fileName)
            try data.write(to: fileURL)
        } catch  {
            
        }
    }
  
  func deleteFile(subDirectory: LocalFileManagerFolder, fileName: LocalFileManagerFileNames){
    guard let directory = mainDirectory?.appendingPathComponent(subDirectory.rawValue) else {
      return
    }
    
    do {
      let fileURL = directory.appendingPathComponent(fileName.rawValue)
      try FileManager.default.removeItem(at: fileURL)
    } catch let error as NSError {
      debugPrint(error)
    }
  }
    
    private func getUrlFileInsideDirectory(directory: URL) -> URL? {
        let files: [String]? = try? FileManager.default.contentsOfDirectory(atPath: directory.relativePath)
        guard let file = files?.first else { return nil}
        guard let fileClean = file.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil}
        guard let url = URL(string: fileClean) else { return nil}
        return directory.appendingPathComponent(url.absoluteString)
    }
    
    func imageFromFile(subDirectory: LocalFileManagerFolder) -> UIImage?{
        
        guard let directory = mainDirectory?.appendingPathComponent(subDirectory.rawValue) else {
            return nil
        }
        
        guard let directoryFile = getUrlFileInsideDirectory(directory: directory) else {
            return nil
        }
        
        do{
            let data = try Data(contentsOf: directoryFile)
            if let image =  UIImage(data: data){
                return image
            }
        }
        catch{
            debugPrint(error)
        }
        return nil
    }
}

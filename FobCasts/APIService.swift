//
//  APIService.swift
//  FobCasts
//
//  Created by Le Doan Anh Khoa on 15/11/18.
//  Copyright © 2018 Le Doan Anh Khoa. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

class APIService {
    
    typealias EpisodeDownloadCompleteTuple = (fileUrl: String, episodeTitle: String)
    let baseItunesSearchUrl = "https://itunes.apple.com/search"
    
    // singleton
    static let shared = APIService()
    
    func downloadEpisode(episode: Episode) {
        print("Downloading episode at stream url: \(episode.streamUrl)")
        
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
        
        Alamofire.download(episode.streamUrl, to: downloadRequest).downloadProgress { (progress) in
           
            print(progress.fractionCompleted)

            // notify downloadsController abound download progress
            
            NotificationCenter.default.post(name: .downloadProgress, object: nil, userInfo: ["title": episode.title, "progress": progress.fractionCompleted])
            
            
            
            }.response { (response) in
                
                print(response.destinationURL?.absoluteString ?? "")
                let episodeDownloadComplete = EpisodeDownloadCompleteTuple(response.destinationURL?.absoluteString ?? "", episode.title)
                NotificationCenter.default.post(name: .downloadComplete, object: episodeDownloadComplete, userInfo: nil)
                
                // update UserDefaults downloaded episodes with this temp file
                var downloadedEpisodes = UserDefaults.standard.downloadedEpisodes()
                
                guard let index = downloadedEpisodes.index(where: { (e) -> Bool in
                    return e.title == episode.title && e.author == episode.author
                }) else {
                    return
                }
                
                downloadedEpisodes[index].fileUrl = response.destinationURL?.absoluteString ?? ""
                
                do {
                    let data = try JSONEncoder().encode(downloadedEpisodes)
                    UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
                } catch let err {
                    print("failed to encode downloaded episodes with file url update: \(err)")
                }
                
        }
        

    }
    
    func fetchEpisodes(feedUrl: String, completion: @escaping([Episode]) -> Void) {
        
        // use FeedKit to parse RSS

        guard let url = URL(string: feedUrl.toSecureHTTPS()) else { return }
        
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            parser.parseAsync { (result) in
                
                if let err = result.error {
                    print("Failed to parse XML feed: \(err)")
                }
                
                guard let feed = result.rssFeed else { return }
                
                let episodes = feed.toEpisodes()
                completion(episodes)
                
            }
        }
        
    }
    
    func fetchFodcasts(searchText: String, completion: @escaping([Fodcast]) -> Void) {

        let parameters = ["term": searchText]

        Alamofire.request(baseItunesSearchUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).response { (dataResponse) in
            if let error = dataResponse.error {
                print("Failed error\(error)")
                return
            }
            
            guard let data = dataResponse.data else { return }
            
            do {
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                completion(searchResult.results)
            } catch let decodeErr {
                print("Failed to decode: \(decodeErr)")
            }
        }
        
    }

    struct SearchResults: Decodable {
        let resultCount: Int
        let results: [Fodcast]
    }
    
    
}

extension Notification.Name {
    
    static let downloadProgress = NSNotification.Name("downloadProgress")
    static let downloadComplete = NSNotification.Name("downloadComplete")
    
}

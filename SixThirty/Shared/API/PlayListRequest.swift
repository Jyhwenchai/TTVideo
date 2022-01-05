//
//  PlayListRequest.swift
//  SixThirty (iOS)
//
//  Created by 蔡志文 on 2022/1/5.
//

import Foundation

class PlayListRequest: Request {
    
    func fetchVideos(by timeInterval: Int64 = 0) async throws -> ([Video], Next) {
        let path = getVideoServerPath(with: timeInterval)
        let data = try await requestData(with: path)
        let dict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
        
        guard let data = dict else {
            throw "request failed."
        }
        
        guard let list = data["data"] as? [[String: Any]] else {
            throw "Not exist video list"
        }
        
        return await (try extractVideos(in: list), try extractNextInfo(in: data))
    }
    
    private func extractNextInfo(in data: [String: Any]) async throws -> Next {
        
        guard let hasMore = data["has_more"] as? Bool else {
            throw "request faild"
        }
        
        guard let next = data["next"] as? [String: Any], let maxBehotTime = next["max_behot_time"] as? Int64 else {
            throw "request faild"
        }
        
        return Next(hasMore: hasMore, maxBehotTime: maxBehotTime)
    }
    
    private func extractVideos(in data: [[String: Any]]) async throws -> [Video] {
        
        var videos: [Video] = []
        for item in data {
            
            guard let cellType = item["cell_type"] as? Int, cellType == 0 else {
                continue
            }
            
            guard let id = item["id"] as? String else {
                throw "Not exist item"
            }
            
            guard let publishTime = item["publish_time"] as? Int64 else {
                throw "Not exist `publish_time` property"
            }
            
            guard let title = item["title"] as? String else {
                throw "Not exist `title` property"
            }
            
            guard let coverList = item["large_image_list"] as? [[String: Any]],
                  let coverInfo = coverList.first,
                  let cover = coverInfo["url"] as? String else {
                      throw "Not exist video cover"
                  }
            
            guard let video = item["video"] as? [String: Any] else {
                throw "Not exist `video` property"
            }
            
            guard let playAddrList = video["play_addr_list"] as? [[String: Any]], !playAddrList.isEmpty else {
                throw "Not exist play address list"
            }
            
            guard let playURLList = playAddrList.first!["play_url_list"] as? [String], let url = playURLList.first else {
                throw "Not exist play url list"
            }
            
            let videoInfo = Video(id: id, title: title, publishTime: publishTime, cover: cover, url: url)
            videos.append(videoInfo)
        }

        return videos
    }
    
    private func getVideoServerPath(with timeInterval: Int64) -> String {
       return "https://www.toutiao.com/api/pc/list/user/feed?category=profile_all&token=MS4wLjABAAAA5KspI8da6GIIrXpXnnwhe8ruyILAb_lOh2Wf0fjtEM4&max_behot_time=\(timeInterval)&aid=24&app_name=toutiao_web&_signature=_02B4Z6wo00901Isl.AQAAIDDH.OnCZZ51MCLAfiAAENoeorjilKgDt8LpGbIH1oSUQ2fSMjw-tpAIbaablA8nodxsSf5m6wTp89bmlRHxZ6KnxURoGLGhwwJOxVh0SmOoQmiPk9J3nMdxTeO76"
    }
    
}

//
//  VideoModel.swift
//  SixThirty (iOS)
//
//  Created by 蔡志文 on 2021/12/24.
//

import Foundation

struct Video: Codable, Identifiable, Equatable {
    var id: String
    var title: String
    var publishTime: Int64
    var cover: String
    var url: String
    
    static func == (lhs: Video, rhs: Video) -> Bool {
        return lhs.id == rhs.id
    }
}

//{'title': '一场游戏一场梦', 'publish_time': 1626861408, 'url': 'http://v9-default.ixigua.com/486823728cdcb243d3680a930288575e/61c53508/video/tos/cn/tos-cn-ve-4/3ccef8c159e04a9f8fdf3472d5beb689/?a=24&br=3307&bt=3307&cd=0%7C0%7C0&ch=0&cr=0&cs=0&cv=1&dr=0&ds=4&er=&ft=teqIn88-oCdDpvnh7TQ_plXxuhsdJkSRHqY&l=20211224094709010212150049172EDF82&lr=no_logo&mime_type=video_mp4&net=5&pl=0&qs=0&rc=anB3eWc6ZjR4NjMzNDczM0ApOjk6PDo8NGQ2Nzw7ZDU4NGc1NG01cjQwZ29gLS1kLWFzczVjXjReYzMxYmMuMWJeLTU6Yw%3D%3D&vl=&vr=', 'type': 'mp4'}

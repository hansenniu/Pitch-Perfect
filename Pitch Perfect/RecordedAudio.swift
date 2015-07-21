//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Hansen Niu on 15/07/2015.
//  Copyright (c) 2015 Taika. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}


//
//  MediaTypes.swift
//  AppleMediaDisplayer
//
//  Created by me on 10/18/18.
//  Copyright © 2018 me. All rights reserved.
//

let appleMusic =  MediaType(title: "Apple Music",
                            feedTypes: [//FeedType("Coming Soon"),
                                        FeedType("Hot Tracks"),
//                                        FeedType("New Releases"),
//                                        FeedType("Top Albums"),
                                        FeedType("Top Songs")
                            ]
)
let iTunesMusic = MediaType(title: "iTunes Music",
                            feedTypes: [FeedType("Hot Tracks"),
//                                        FeedType("New Music"),
//                                        FeedType("Recent Releases"),
//                                        FeedType("Top Albums"),
                                        FeedType("Top Songs")
                            ]
)
let audiobooks =  MediaType(title: "Audiobooks",
                            feedTypes: [FeedType("Top Audiobooks")]
)
//let books =       MediaType(title: "Books",
//                            feedTypes: [FeedType("Top Free"), FeedType("Top Paid")]
//)
let tvShows =     MediaType(title: "TV Shows",
                            feedTypes: [FeedType("Top TV Episodes")]//, FeedType("Top TV Seasons")]
)
let movies =      MediaType(title: "Movies",
                            feedTypes: [FeedType("Top Movies")]
)
//let iTunesU =     MediaType(title: "iTunes U",
//                            feedTypes: [FeedType("Top iTunes U Courses")]
//)
//let podcasts =    MediaType(title: "Podcasts",
//                            feedTypes: [FeedType("Top Podcasts")]
//)
let musicVideos = MediaType(title: "Music Videos",
                            feedTypes: [FeedType("Top Music Videos")]
)

let mediaTypes = [appleMusic, iTunesMusic, audiobooks, tvShows, movies, musicVideos]

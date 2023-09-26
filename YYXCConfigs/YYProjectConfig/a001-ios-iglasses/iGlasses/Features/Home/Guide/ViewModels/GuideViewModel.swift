//
//  GuideViewModel.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/23.
//
import Foundation
import RxSwift

struct GuideNews {
    let type: Int
    let image: URL
    let title: String
    let link: URL
    let summary: String?
}

struct GuideRootViewModel {
    
    enum UIPath {
        case browser(url: URL)
    }
    
    let remoteService: GlassesRemoteService
    let navigateSubject = PublishSubject<GuideRootViewModel.UIPath>()
    
    class GuideListParam {
        var skipNum = 0
        var length = 10
        lazy var language: String = {
            return "cn"
        }()
        
        func nextPage() {
            skipNum += length
        }
    }
    
    let param = GuideListParam()
    let newsSubject = PublishSubject<[[GuideNews]]>()
    let errorSubject = PublishSubject<Error>()
    var language: String {
        let languages = NSLocale.preferredLanguages
        if !languages.isEmpty {
            guard let currentLanguage = languages.first else {
                return "cn"
            }
            if currentLanguage.hasPrefix("en") {
                return "en"
            }
            if currentLanguage.hasPrefix("zh") {
                return "cn"
            }
        }
        return "cn"
    }
    
    private let dispose = DisposeBag()
    
    func refreshGuideList() {
        self.param.skipNum = 0
        fetchGuideList(skipNum: 0)
    }
    
    func loadMoreGuideList() {
        self.param.nextPage()
        fetchGuideList(skipNum: self.param.skipNum)
    }
    
    private func fetchGuideList(skipNum: Int) {
        self.remoteService
            .fetchGuideList(language: self.language, skipNum: skipNum, length: param.length)
            .map({ sections in
                var newsGroup = [[GuideNews]]()
                guard let sections = sections else {
                    return newsGroup
                }
                sections.forEach { section in
                    var group = [GuideNews]()
                    group.append(GuideNews(type: 0, image: section.sectionImage, title: section.title, link: section.link, summary: nil))
                    section.items?.forEach({ item in
                        group.append(GuideNews(type: 1, image: item.image, title: item.title, link: item.link, summary: item.summary))
                    })
                    newsGroup.append(group)
                }
                return newsGroup
            })
            .subscribe(onSuccess: { newsGroup in
                newsSubject.onNext(newsGroup)
            }, onFailure: { error in
                print(error)
                self.errorSubject.onNext(error)
            }, onDisposed: {
                
            }).disposed(by: self.dispose)
    }
    
}

extension GuideRootViewModel: NavigateToBrowserProtocol {
    
    func navigateToBrowser(url: URL) {
        navigateSubject.onNext(.browser(url: url))
    }
}

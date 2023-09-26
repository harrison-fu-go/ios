//
//  NewsRemoteApiImpl.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/23.
//

import Foundation
import RxSwift

struct NewsRemoteApiImpl: NewsRemoteApi {
    
    static let `default` = NewsRemoteApiImpl()
    
    func fetchLastestNews() -> Single<News> {
        return Observable.create { _ -> Disposable in
            return Disposables.create()
        }.asSingle()
    }
    
}

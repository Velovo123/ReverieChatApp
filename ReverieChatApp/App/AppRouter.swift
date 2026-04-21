//
//  AppRouter.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 20.04.2026.
//

import SwiftUI

enum Route: Hashable {
    case conversationList
    case chat(conversation: Conversation)
    case profile(userId: String, conversation: Conversation?)
}

@Observable
final class AppRouter {
    static let shared = AppRouter()
    private init() {}
    
    var path = NavigationPath()
    var isAuthenticated: Bool = false
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func replace(with route: Route) {
        popToRoot()
        push(route)
    }
}

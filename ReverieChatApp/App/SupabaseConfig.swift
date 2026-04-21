//
//  SupabaseConfig.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 20.04.2026.
//

import Supabase
import Foundation

import Supabase

let supabase: SupabaseClient = {
    let info = Bundle.main.infoDictionary
    let urlString = info?["SUPABASE_URL"] as? String ?? ""
    let anonKey = info?["SUPABASE_ANON_KEY"] as? String ?? ""

    guard !urlString.isEmpty, let url = URL(string: urlString) else {
        fatalError("SUPABASE_URL is missing or invalid in Secrets.xcconfig")
    }

    guard !anonKey.isEmpty else {
        fatalError("SUPABASE_ANON_KEY is missing in Secrets.xcconfig")
    }

    return SupabaseClient(
        supabaseURL: url,
        supabaseKey: anonKey,
    )
}()

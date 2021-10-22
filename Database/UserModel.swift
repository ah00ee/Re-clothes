//
//  UserModel.swift
//  reclothes
//
//  Created by 노아영 on 2021/10/01.
//

import Foundation
import RealmSwift
import KakaoSDKUser

// 닉네임, 이메일(수집), 성별, 생일
class UserInfo: Object{
    @objc dynamic var nickname = ""
    @objc dynamic var email = ""
    @objc dynamic var gender = ""  // added
    @objc dynamic var bday = ""
}

//
//  UserDto.swift
//  randomuser
//
//  Created by 김상우 on 2023/05/06.
//

import Foundation

struct UserDto : Codable {
    
    let gender : String
    let name : NameDto
    let email : String?
    let phone : String?
    let picture : PictureDto?
    let nat : String
    
}

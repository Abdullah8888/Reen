//
//  HomeViewModel.swift
//  Reen
//
//  Created by Jimoh Babatunde Olalekan on 28/12/2020.
//  Copyright © 2020 Jimoh Babatunde Olalekan. All rights reserved.
//

import Foundation

enum HomeViewModelState {
    case dd
    case ddd
}

protocol HomeViewModelDelegate: class {
    func HomeViewModelDidChanngeState(state: HomeViewModelState)
}

class HomeViewModel: NSObject {
    var dd: String?
}

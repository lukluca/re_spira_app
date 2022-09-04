//
//  CreditsViewModel.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 03/09/22.
//

import UIKit

struct PoemCellViewModel {
    let title: String
    let subtitle: String
    
    init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = "\n" + subtitle
    }
}

class CreditsViewModel {
    
    enum Section: Int {
        case poem
        case thanks
    }
    
    var poem: PoemCellViewModel?
    
    init() {
        poem = nil
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else {
            return 0
        }
        switch section {
        case .poem:
            return UITableView.automaticDimension
        case .thanks:
            return 44
        }
    }
    
    func estimatedHeightForRow(at indexPath: IndexPath) -> CGFloat {
        heightForRow(at: indexPath)
    }
}

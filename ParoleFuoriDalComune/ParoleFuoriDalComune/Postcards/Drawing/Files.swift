//
//  Files.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 04/09/22.
//

import Foundation
import UIKit

enum FilesError: Error {
    case outOfRange
    case fileNotFound
    case imageNotFound
}

typealias PoemAndImage = (poem: String, image: UIImage)

struct Files {
    
    func getPoemAndImage(at position: Int) throws -> PoemAndImage  {
        
        let url: URL?
        let image: UIImage?
        
        switch position {
        case 1:
            url = R.file.page1Txt()
            image = R.image.visual_1()
        case 2:
            url = R.file.page2Txt()
            image = R.image.visual_2()
        case 3:
            url = R.file.page3Txt()
            image = R.image.visual_3()
        case 4:
            url = R.file.page4Txt()
            image = R.image.visual_4()
        case 5:
            url = R.file.page5Txt()
            image = R.image.visual_5()
        case 6:
            url = R.file.page6Txt()
            image = R.image.patternPoemMazeJpg()
        case 7:
            url = R.file.page7Txt()
            image = R.image.visual_7()
        case 8:
            url = R.file.page8Txt()
            image = R.image.visual_8()
        case 9:
            url = R.file.page9Txt()
            image = R.image.visual_9()
        case 10:
            url = R.file.page10Txt()
            image = R.image.visual_10()
        case 11:
            url = R.file.page11Txt()
            image = R.image.visual_11()
        case 12:
            url = R.file.page12Txt()
            image = R.image.visual_12()
        case 13:
            url = R.file.page13Txt()
            image = R.image.patternPoemMazeJpg()
        case 14:
            url = R.file.page14Txt()
            image = R.image.visual_14()
        case 15:
            url = R.file.page15Txt()
            image = R.image.patternPoemMazeJpg()
        default:
            throw FilesError.outOfRange
        }
        
        guard let url = url else {
            throw FilesError.fileNotFound
        }
        guard let image = image else {
            throw FilesError.imageNotFound
        }

        return (try String(contentsOf: url, encoding: .utf8), image)
    }
}

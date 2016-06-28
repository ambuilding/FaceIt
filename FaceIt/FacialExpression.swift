//
//  FacialExpression.swift
//  FaceIt
//
//  Created by WangQi on 16/5/21.
//  Copyright © 2016年 WangQi. All rights reserved.
//

import Foundation

// UI-independent representation of a facial expression

struct FacialExpression {
    
    enum Eyes: Int {
        case Open
        case Closed
        case Squinting // 眯着眼睛
    }
    
    enum EyeBrows: Int {
        case Relaxed
        case Normal
        case Furrowed
        
        func moreRelaxedBrow() -> EyeBrows {
            return EyeBrows(rawValue: rawValue - 1) ?? .Relaxed
        }
        func moreFurrowedBrow() -> EyeBrows {
            return EyeBrows(rawValue: rawValue + 1) ?? .Furrowed
        }
    }
    
    enum Mouth: Int {
        case Frown // 不悦
        case Smirk // 傻笑
        case Neutral // 面无表情
        case Grin   // 露齿笑
        case Smile
        
        func sadderMouth() -> Mouth {
            return Mouth(rawValue: rawValue - 1) ?? .Frown
        }
        func happierMouth() -> Mouth {
            return Mouth(rawValue: rawValue + 1) ?? .Smile
        }
    }
    
    var eyes: Eyes
    var eyeBrows: EyeBrows
    var mouth: Mouth
}

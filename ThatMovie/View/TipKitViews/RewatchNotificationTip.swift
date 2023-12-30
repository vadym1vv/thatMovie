//
//  RewatchNotificationTip.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 23.12.2023.
//

import Foundation
import TipKit

struct RewatchNotificationTip: Tip {
    
    @Parameter static var displayTip: Bool = false
    
    var rules: [Rule] {
        [
            #Rule(Self.$displayTip) {
                $0 == true
            }
        ]
    }
    
    var title: Text {
        Text("Memories")
    }
    
    var message: Text? {
        Text("After a specified time, you'll receive notifications about movies you haven't seen in a while.")
    }
    
    
    
    
}

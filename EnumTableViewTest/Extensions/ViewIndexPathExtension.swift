/*
* Copyright (C) 2015 47 Degrees, LLC http://47deg.com hello@47deg.com
*
* Licensed under the Apache License, Version 2.0 (the "License"); you may
* not use this file except in compliance with the License. You may obtain
* a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import UIKit

let kSectionTag = 1000

func indexPathFromTag(tag: Int) -> NSIndexPath? {
    if tag > 0 {
        let section = ((tag / kSectionTag) - 1)
        let row = tag % kSectionTag
        return NSIndexPath(forRow: row, inSection: section)
    }
    return nil
}

func tagFromIndexPath(indexPath: NSIndexPath?) -> Int {
    if let _indexPath = indexPath {
        return ((_indexPath.section + 1) * kSectionTag) + _indexPath.row
    } else {
        return 0
    }
}

extension UIView {
    var indexPath : NSIndexPath? {
        get {
            return indexPathFromTag(self.tag)
        }
        set {
            self.tag = tagFromIndexPath(newValue)
        }
    }
}
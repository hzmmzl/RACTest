//
//  Header.h
//  RACTest
//
//  Created by mzl on 2020/2/27.
//  Copyright © 2020 Hillary Min. All rights reserved.
//

#ifndef Header_h
#define Header_h

//  屏幕高度
#define SCREENHEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)

//  屏幕屏幕宽度
#define SCREENWITH CGRectGetWidth([UIScreen mainScreen].bounds)
//  RGB颜色
#define RGBCOLOR(_red, _green, _blue) [UIColor colorWithRed:(_red)/255.0f green:(_green)/255.0f blue:(_blue)/255.0f alpha:1]

#endif /* Header_h */

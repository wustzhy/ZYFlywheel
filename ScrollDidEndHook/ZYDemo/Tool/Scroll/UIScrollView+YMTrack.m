//
//  UIScrollView+YMTrack.m
//  StartPineapple
//
//  Created by yestinZhao on 2022/3/29.
//

#import "UIScrollView+YMTrack.h"
#import "NSObject+zy_swizzle.h"
#import <objc/runtime.h>

@implementation UIScrollView (YMTrack)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      [self.class zy_swizzleSEL:@selector(setDelegate:)
                        withSEL:@selector(zy_swizzled_setDelegate:)];
    });
}

//- (void)beginTracker; {
//  static dispatch_once_t onceToken;
//  dispatch_once(&onceToken, ^{
//    [self.class zy_swizzleSEL:@selector(setDelegate:)
//                      withSEL:@selector(zy_swizzled_setDelegate:)];
//  });
//}

- (void)zy_swizzled_setDelegate:(id<UICollectionViewDelegate>)delegate {
    
    [self _swizzleForDelegate:delegate];//解决方案
    
    [self zy_swizzled_setDelegate:delegate];
}

//解决方案
- (void)_swizzleForDelegate:(id<UICollectionViewDelegate>)delegate {
    if ([delegate isKindOfClass:[NSObject class]]) {
      //[delegate.class resolveInstanceMethod:@selector(scrollViewDidEndDragging:willDecelerate:)];
      if (![delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        //BOOL addOK =
        class_addMethod([delegate class],
                        @selector(scrollViewDidEndDragging:willDecelerate:),
                        (IMP)twoParamsMethod,
                        method_getTypeEncoding(class_getInstanceMethod(delegate.class, @selector(zy_swizzled_scrollViewDidEndDragging:willDecelerate:))));
        //NSLog(@" %@ ------- addOK:%@", delegate, @(addOK));
      }
      [self swizzleForClass:delegate.class
                        sel:@selector(scrollViewDidEndDragging:willDecelerate:)
                     newSel:@selector(zy_swizzled_scrollViewDidEndDragging:willDecelerate:)
                     newIMP:(IMP)zy_swizzled_scrollViewDidEndDragging];
      
      if (![delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        class_addMethod([delegate class],
                        @selector(scrollViewDidEndDecelerating:),
                        (IMP)oneParamMethod,
                        method_getTypeEncoding(class_getInstanceMethod(delegate.class, @selector(zy_swizzled_scrollViewDidEndDecelerating:))));
      }
      [self swizzleForClass:delegate.class
                        sel:@selector(scrollViewDidEndDecelerating:)
                     newSel:@selector(zy_swizzled_scrollViewDidEndDecelerating:)
                     newIMP:(IMP)zy_swizzled_scrollViewDidEndDecelerating];
    }
}


void oneParamMethod(id self, SEL _cmd, UIScrollView *scrollView) {
  NSLog(@" ------- oneParamMethod: %@, \nscrollView: %@", self, scrollView);
}
void twoParamsMethod(id self, SEL _cmd, UIScrollView *scrollView, BOOL willDecelerate) {
  NSLog(@" ------- twoParamsMethod: %@, \nscrollView: %@", self, scrollView);
}


- (void)swizzleForClass:(Class)class sel:(SEL)sel newSel:(SEL)newSel newIMP:(IMP)newIMP {
  Method originMethod = class_getInstanceMethod(class, sel);
  IMP originIMP = method_getImplementation(originMethod);
  if (originMethod
      && !(originIMP==newIMP)) {
    class_addMethod(class, newSel,newIMP, method_getTypeEncoding(originMethod));
    [class zy_swizzleSEL:sel withSEL:newSel];
  } else {
    NSLog(@"%s \n ------- %@ \n ------- %@", __func__, self, NSStringFromSelector(sel));
  }
}

void zy_swizzled_scrollViewDidEndDragging(id self, SEL _cmd, UIScrollView *scrollView, BOOL willDecelerate) {
    
  //Do tracker something
  NSLog(@"zy_swizzled_scrollViewDidEndDragging call");
  
  if (!willDecelerate) {
    BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (dragToDragStop) {
      [scrollView scrollViewDidEndScroll]; //注意 self 是scrollView.delegate
    }
  }
  
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  SEL sel = @selector(zy_swizzled_scrollViewDidEndDragging:willDecelerate:);
  if ([self respondsToSelector:sel]) {
    [self performSelector:sel
               withObject:scrollView
               withObject:@(willDecelerate)];
  }
#pragma clang diagnostic pop
  
  NSLog(@"zy_swizzled_scrollViewDidEndDragging called");
}

void zy_swizzled_scrollViewDidEndDecelerating(id self, SEL _cmd, UIScrollView *scrollView) {
  
  NSLog(@"日志: tracker _cmd %@",NSStringFromSelector(_cmd));
  
  BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
  if (scrollToScrollStop) {
    [scrollView scrollViewDidEndScroll];
  }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  SEL sel = @selector(zy_swizzled_scrollViewDidEndDecelerating:);
  [self performSelector:sel
             withObject:scrollView];
#pragma clang diagnostic pop
  
  NSLog(@"日志: tracker _cmd %@ called",NSStringFromSelector(_cmd));
}


- (void)scrollViewDidEndScroll {
   //在这里写监听滑动停止要做的事
  if (self.scrollDidEndBlocks.count) {
    [self.scrollDidEndBlocks enumerateObjectsUsingBlock:^(void (^ _Nonnull obj)(void), NSUInteger idx, BOOL * _Nonnull stop) {
      obj();
    }];
  }
}



- (void)setScrollDidEnd:(void(^)(void))scrollDidEnd; {
  if (scrollDidEnd) {  
    [[self scrollDidEndBlocks] addObject:scrollDidEnd];
  }
}

static const void *kScrollDidEndBlocksKey = @"kScrollDidEndBlocksKey"; //scrollDidEndBlocks
- (NSMutableArray <void(^)(void)>*)scrollDidEndBlocks {
  NSMutableArray *mArr = objc_getAssociatedObject(self, kScrollDidEndBlocksKey) ;
  if (!mArr) {
    mArr = [NSMutableArray array];
    objc_setAssociatedObject(self, kScrollDidEndBlocksKey, mArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return mArr;
}


@end

//
//  ViewController.m
//  NavigationAnimation
//
//  Created by jiang on 2019/7/24.
//  Copyright © 2019 jarvis. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIViewControllerPreviewingDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:_btn];
    }
    // Do any additional setup after loading the view.
}

- (IBAction)click:(UIButton *)sender {
    
}
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    ViewController *vc = [[UIStoryboard  storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"666"];
    vc.preferredContentSize = CGSizeMake(414, 174);
    previewingContext.sourceRect = CGRectMake(0, -10, _btn.frame.size.width, 50);
    return vc;
}
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self.navigationController pushViewController:viewControllerToCommit animated:YES];
}

@end

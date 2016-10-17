//
//  ViewController.m
//  AutoExpandInputBar
//
//  Created by Louis Liu on 28/09/2016.
//  Copyright © 2016 Louis Liu. All rights reserved.
//

#import "ViewController.h"
#import "FlexibleInputView.h"

@interface ViewController ()<UITabBarDelegate, UITableViewDataSource, FlexibleInputViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<NSString *> *comments;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _comments = [[NSMutableArray alloc]init];
    
    for (int i=0;i<20; i++) {
        [_comments addObject:@"test"];
    }
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    FlexibleInputView *bar = [[FlexibleInputView alloc]initWithOrigin:CGPointMake(0, [UIScreen mainScreen].bounds.size.height-44) height:44];
    [bar setDelegate:self];
    [bar setBackgroundColor:defaultBGColor];
    [self.view addSubview:bar];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = _comments[indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_comments count];
}

-(void)onKeyboardHeightChanging:(CGFloat)height isShowing:(BOOL)isShowing{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _tableView.frame;

        frame.origin.y-=height;
        
        [_tableView setFrame:frame];
    }];
    
}

-(void)onSendBtnTapped:(UITextView *)textView text:(NSString *)text{
    [_comments addObject:text];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


@end

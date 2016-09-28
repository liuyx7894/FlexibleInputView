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

-(void)onKeyboardRectChanging:(CGRect)rect isShowing:(BOOL)isShowing{
    
    [UIView animateWithDuration:0.3 animations:^{
        if(isShowing){
            [_tableView setContentOffset:CGPointMake(0, _tableView.contentOffset.y + rect.size.height)];
        }else{
            [_tableView setContentOffset:CGPointMake(0, _tableView.contentOffset.y - rect.size.height)];
        }
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

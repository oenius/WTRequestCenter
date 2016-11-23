//
//  JSONModelDemoVC.m
//  WTRequestCenter
//
//  Created by SongWentong on 23/11/2016.
//  Copyright © 2016 song. All rights reserved.
//

#import "JSONModelDemoVC.h"
#import "NSDictionary+JSONModel.h"
@interface JSONModelDemoVC () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextView *jsonTextView;
@property (nonatomic,strong) NSString *className;
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (nonatomic,strong) UIAlertController *alertController;
@end

@implementation JSONModelDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSString *path = [n]
    self.className = @"XXX";
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JSONData" ofType:nil]];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    _jsonTextView.text = string;
}
- (IBAction)print:(id)sender {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[_jsonTextView.text dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    NSLog(@"%@",[dict WTModelString]);
}
- (IBAction)writeToFile:(id)sender {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[_jsonTextView.text dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    NSString *printModel = [dict WTModelString];
#if TARGET_OS_SIMULATOR
    //模拟器写到桌面
    NSString *homePath = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)[0];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    __block NSURL *url = nil;
    [[defaultManager contentsOfDirectoryAtURL:[NSURL URLWithString:@"/Users"] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants error:nil] enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@",obj);
        if ([homePath containsString:[[obj absoluteString] substringFromIndex:7]]) {
            url = [obj URLByAppendingPathComponent:@"Desktop"];
            NSLog(@"%@",url);
        }
    }];
    if (url) {
        NSLog(@"writefile to:%@",homePath);
//        NSString *filePath = [NSString stringWithFormat:@"%@/XXX.h",NSHomeDirectory()];
        [printModel writeToURL:[url URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.h",_className]] atomically:YES encoding:NSUTF8StringEncoding error:nil];
//        [printModel writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//        NSString *path2 = [NSString stringWithFormat:@"%@/XXX.m",NSHomeDirectory()];
        NSString *implementationString = [NSString stringWithFormat:@"@implementation %@\n-(id)WTJSONModelProtocolInstanceForKey:(NSString*)key{\n    return nil;\n}\n@end",_className];
        [implementationString writeToURL:[url URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.m",_className]] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
#else
    NSLog(@"请用模拟器运行,这样可以把文件写到桌面");
    return;
#endif
    
    
}
- (IBAction)changeClassName:(id)sender {
    self.alertController = [UIAlertController alertControllerWithTitle:@"hello" message:@"修改类名" preferredStyle:UIAlertControllerStyleAlert];
    __weak JSONModelDemoVC *weakSelf = self;
    [_alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = weakSelf.className;
        textField.placeholder = @"请输入类名";
        
    }];
    [_alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.className = [_alertController textFields][0].text;
        weakSelf.classNameLabel.text = [NSString stringWithFormat:@"类名:%@",weakSelf.className];
        [_alertController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }]];
    [_alertController addAction:[UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [_alertController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }]];
    [[_alertController textFields][0] addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self presentViewController:_alertController animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textFieldChanged:(UITextField*)sender{
    
    if (sender.text.length == 0) {
        _alertController.actions[0].enabled = NO;
    }else{
        _alertController.actions[0].enabled = YES;
    }
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

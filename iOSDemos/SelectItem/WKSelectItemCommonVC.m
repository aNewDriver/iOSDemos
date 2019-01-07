//
//  WKSelectItemCommonVC.m
//  SampleAppObjC
//
//  Created by Ke Wang on 2018/9/17.
//  Copyright © 2018年 Bankorus. All rights reserved.
//

#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define KNAVHeight KIsiPhoneX ? 88 : 64
#define KRGBHexAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]
#define KScreenWidth [UIScreen mainScreen].bounds.size.width


#import "WKSelectItemCommonVC.h"
#import "NSString+PinYin.h"

typedef NS_ENUM(NSUInteger, MyDataSourceParamsType) {
    MyDataSourceParamsType_Default = 0, //!< 字典
    MyDataSourceParamsType_String = 1, //!< 字符串
    MyDataSourceParamsType_Other
};


@interface WKSelectCell ()

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIView *sepL;

@end


@implementation WKSelectCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self configureUI];
    }
    return self;
}

- (void)configureUI {
    [self.contentView addSubview:self.titleL];
    [self.contentView addSubview:self.sepL];
}

- (void)configuireCellWithString:(NSString *)string {
    if (!string) {
        return;
    }
    self.titleL.text = string;
}



#pragma mark - get

- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(30, 15, KScreenWidth - 90.0f, 20.0f)];
        _titleL.textColor = KRGBHexAlpha(0x424242, 1);
        _titleL.textAlignment = NSTextAlignmentLeft;
        _titleL.font = [UIFont systemFontOfSize:14.0f];
    }
    return _titleL;
}

- (UIView *)sepL {
    if (!_sepL) {
        _sepL = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleL.frame), CGRectGetMaxY(self.titleL.frame) + 14, KScreenWidth -CGRectGetMinX(self.titleL.frame), 1.0f)];
        _sepL.backgroundColor = KRGBHexAlpha(0xF2F2F2, 1);
    }
    return _sepL;
}

@end



@interface WKSelectItemCommonVC ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *mainTV;
@property (nonatomic, strong) NSArray *indexArray;
@property (nonatomic, assign) BOOL searchActive; //!< 搜索激活
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) UISearchBar *mSearchBar;
@property (nonatomic, assign) MyDataSourceParamsType myDataSourceParamsType;



@end

@implementation WKSelectItemCommonVC

- (instancetype)init {
    if (self = [super init]) {
        self.myDataSourceParamsType = MyDataSourceParamsType_Default; //!< 设置默认为default
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
    
}


#pragma mark - method

- (void)configureUI {
    self.title = @"Level2";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mSearchBar];
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"goBackIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goBackAction)];
    self.navigationItem.leftBarButtonItem = bar;
    bar.tintColor = [UIColor whiteColor];
}

- (void)goBackAction {
    if (self.WKselectModelCallBack) {
        if (self.myDataSourceParamsType == MyDataSourceParamsType_Default) {
            self.WKselectModelCallBack(@{@"modelName" : @""});
        } else if (self.myDataSourceParamsType == MyDataSourceParamsType_String) {
            self.WKselectModelCallBack(@"");
        } else {
            
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setDataSource:(NSArray *)dataSource {
    
    if (_dataSource == dataSource) {
        return;
    }
    _dataSource = dataSource;
    
    __block NSMutableArray *modelNameArray = @[].mutableCopy;

    if (_dataSource.count > 0) {
        
        [dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                self.myDataSourceParamsType = MyDataSourceParamsType_Default;
                if (obj[@"modelName"]) {
                    [modelNameArray addObject:obj[@"modelName"]];
                }
            } else if ([obj isKindOfClass:[NSString class]]) {
                self.myDataSourceParamsType = MyDataSourceParamsType_String;
                if (obj) {
                    [modelNameArray addObject:obj];
                }
            } else {
                self.myDataSourceParamsType = MyDataSourceParamsType_Other;
            }
            
        }];
    }
    
    self.indexArray = [modelNameArray arrayWithPinYinFirstLetterFormat];

    [self.mainTV reloadData];
}

#pragma mark - searchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    searchBar.showsCancelButton = YES;
    if (searchText.length == 0) {
        self.searchActive = NO;
        self.searchArray = @[].mutableCopy;
        [searchBar resignFirstResponder];
        [searchBar endEditing:YES];
        searchBar.showsCancelButton = NO;
        [self.mainTV reloadData];
        return;
    }
    
    self.searchActive = YES;
    [self.searchArray removeAllObjects];
    
    for (int i = 0; i < self.indexArray.count; i++) {
        
        NSDictionary *dict = self.indexArray[i];
        NSMutableArray *array = dict[@"content"];
        NSArray *newA = @[].mutableCopy;
        NSMutableDictionary *newD = @{}.mutableCopy;
        
        if (array.count > 0) {
            // 谓词搜索
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchText]; //!< 不区分大小写
            newA = [array filteredArrayUsingPredicate:predicate];
            if (newA.count > 0) {
                [newD setObject:dict[@"firstLetter"] forKey:@"firstLetter"];
                [newD setObject:newA forKey:@"content"];
            }
        }
        if (newD.count > 0) {
            [self.searchArray addObject:newD];
        }
    }
     [self.mainTV reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchActive = NO;
    self.searchArray = @[].mutableCopy;
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [searchBar endEditing:YES];
    searchBar.showsCancelButton = NO;
    [self.mainTV reloadData];
    searchBar.showsCancelButton = NO;
}


#pragma mark - delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.searchActive) {
        return self.searchArray.count;
    }
    return [self.indexArray count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchActive) {
        NSDictionary *dict = self.searchArray[section];
        NSMutableArray *array = dict[@"content"];
        return [array count];
    } else {
        NSDictionary *dict = self.indexArray[section];
        NSMutableArray *array = dict[@"content"];
        return [array count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WKSelectCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[WKSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    NSDictionary *dict = self.indexArray[indexPath.section];
    if (self.searchActive) {
        dict = self.searchArray[indexPath.section];
    }
    NSMutableArray *array = dict[@"content"];
    [cell configuireCellWithString:array[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //!< 自定义Header标题
    UIView* myView = [[UIView alloc] init];
    myView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 90, 20)];
    titleLabel.textColor= KRGBHexAlpha(0x424242, 1);
    
    UIView *sepL = [[UIView alloc] initWithFrame:CGRectMake(30, 29, KScreenWidth - 30, 1.0f)];
    sepL.backgroundColor = KRGBHexAlpha(0xF2F2F2, 1);
    [myView addSubview:sepL];
    
    NSString *title = self.indexArray[section][@"firstLetter"];
    if (self.searchActive) {
        title = self.searchArray[section][@"firstLetter"];
    }
    titleLabel.text = title;
    [myView  addSubview:titleLabel];
    
    return myView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    WKSelectModel *model = [[WKSelectModel alloc] init];
    
    NSDictionary *dict = self.indexArray[indexPath.section];
    if (self.searchActive) {
        dict = self.searchArray[indexPath.section];
    }
    NSMutableArray *array = dict[@"content"];
    
    
    if (self.WKselectModelCallBack) {
        if (self.myDataSourceParamsType == MyDataSourceParamsType_Default) {
            self.WKselectModelCallBack(@{@"modelName" : array[indexPath.row]});
        } else if (self.myDataSourceParamsType == MyDataSourceParamsType_String) {
            self.WKselectModelCallBack(array[indexPath.row]);
        } else {
            
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    for (UIView *view in [tableView subviews]) {
        if ([view isKindOfClass:[NSClassFromString(@"UITableViewIndex") class]]) {
            // 设置字体大小
            [view setValue:[UIFont systemFontOfSize:11.0f] forKey:@"_font"];
            //设置view的大小
            view.bounds = CGRectMake(0, 0, 30, self.mainTV.frame.size.height);
            [view setBackgroundColor:[UIColor clearColor]];
            //单单设置其中一个是无效的
        }
    }
}


#pragma mark---tableView索引相关设置----

//!< 添加TableView头视图标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.searchActive) {
        NSDictionary *dict = self.searchArray[section];
        NSString *title = dict[@"firstLetter"];
        return title;
    }
    NSDictionary *dict = self.indexArray[section];
    NSString *title = dict[@"firstLetter"];
    return title;
}


//!< 添加索引栏标题数组

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *resultArray =[NSMutableArray arrayWithObject:UITableViewIndexSearch];
    NSArray *array = self.indexArray;
    if (self.searchActive) {
        array = self.searchArray;
    }
    for (NSDictionary *dict in array) {
        NSString *title = dict[@"firstLetter"];
        [resultArray addObject:title];
    }
    return resultArray;
}

//!< 点击索引栏标题时执行
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //!< 这里是为了指定索引index对应的是哪个section的，默认的话直接返回index就好。其他需要定制的就针对性处理
    if ([title isEqualToString:UITableViewIndexSearch])
    {
        [tableView setContentOffset:CGPointZero animated:NO];//!< tabview移至顶部
        return NSNotFound;
    }
    else
    {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] - 1; //!<  -1 添加了搜索标识
    }
}

#pragma mark - 生成图片

- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark - get

- (UISearchBar *)mSearchBar {
    if (!_mSearchBar) {
        _mSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(15, KNAVHeight, KScreenWidth - 30, 35)];
        _mSearchBar.delegate = self;
//        _mSearchBar.placeholder = @"搜索";
        [_mSearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_mSearchBar sizeToFit];
        _mSearchBar.backgroundColor = [UIColor clearColor];
        UIImage *searchBarBg = [self GetImageWithColor:[UIColor clearColor] andHeight:35];
        [_mSearchBar setBackgroundImage:searchBarBg];
        
        UITextField *textF = [_mSearchBar valueForKey:@"searchField"];
        textF.backgroundColor = KRGBHexAlpha(0xF2F2F2, 1);
//        textF.layer.borderWidth = 1.0f;
//        textF.layer.borderColor = KRGBHexAlpha(0xF2F2F2, 1).CGColor;
        textF.layer.cornerRadius = 4.0f;
        
    }
    return _mSearchBar;
}

- (UITableView *)mainTV {
    if (!_mainTV) {
        _mainTV = [[UITableView  alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.mSearchBar.frame),self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.mSearchBar.frame)) style:UITableViewStyleGrouped];
        _mainTV.delegate = self;
        _mainTV.dataSource = self;
        _mainTV.sectionIndexColor = KRGBHexAlpha(0x00A7FF, 1);
        _mainTV.sectionIndexBackgroundColor=[UIColor clearColor];
        _mainTV.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_mainTV];
    }
    return _mainTV;
}

- (NSMutableArray *)searchArray {
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}



@end

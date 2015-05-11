//
//  ViewController.m
//  chess
//
//  Created by Мариам Б. on 02.05.15.
//  Copyright (c) 2015 Мариам Б. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()
@property (strong, nonatomic) UIView * chessBoard;
@property (strong, nonatomic) UIView * chessCell;
@property (strong, nonatomic) UIView * someView;
@property (strong, nonatomic) UIView * figureViewFirst;
@property (strong, nonatomic) UIView * figureViewSecond;
@property (assign, nonatomic) CGPoint differencePoint;
@property (strong, nonatomic) NSMutableArray * imagesWhiteFigures;
@property (strong, nonatomic) NSMutableArray * imagesBlackFigures;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeBoard];
    [self makeFigureView];
    [self addFigures_To_Board : self.imagesWhiteFigures koefficient: 7];
    [self addFigures_To_Board : self.imagesBlackFigures koefficient: 0];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) makeBoard {
    _chessBoard = [[UIView alloc]initWithFrame:CGRectMake(24, 120, CHESSBOARD_SIZE, CHESSBOARD_SIZE)];
    _chessBoard.layer.borderWidth = 0.5f;
    _chessBoard.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:self.chessBoard];
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
           _chessCell = [[UIView alloc]initWithFrame:CGRectMake(j * CELL_SIZE, i * CELL_SIZE, CELL_SIZE, CELL_SIZE)];
            if ((i - j) % 2 != 0) {
                _chessCell.backgroundColor = [UIColor colorWithRed:0.5 green:0.2 blue:0.0 alpha:1.0];
            }
            _chessCell.userInteractionEnabled = NO;
            [self.chessBoard addSubview:self.chessCell];

        };
    };

}

- (void) makeFigureView {
    self.imagesWhiteFigures = [NSMutableArray array];
    self.imagesBlackFigures = [NSMutableArray array];
    NSMutableArray * namesWhiteFigures = [[NSMutableArray alloc]initWithObjects:@"rook_white",@"knight_white",@"bishop_white",@"queen_white",@"king_white",@"pawn_white", nil];
    NSMutableArray * namesBlackFigures = [[NSMutableArray alloc]initWithObjects:@"rook_black",@"knight_black",@"bishop_black",@"queen_black",@"king_black",@"pawn_black", nil];
    
    for (NSString * imageName in namesWhiteFigures) {
        
        UIImage * image = [UIImage imageNamed:imageName];
        [self.imagesWhiteFigures addObject:image];
    }
    
    for (NSString * imageName in namesBlackFigures) {
        UIImage * image = [UIImage imageNamed:imageName];
        [self.imagesBlackFigures addObject:image];
    }

    
}

- (void) addFigures_To_Board : (NSMutableArray*) figureImageArray koefficient : (int) koef {
    
    for (int i = 0; i < figureImageArray.count; i++) {
        if (i < 3) {
            //добавляем ладью, коня и слона
            _figureViewFirst = [[UIView alloc] initWithFrame:CGRectMake(CELL_SIZE*i, koef*CELL_SIZE, CELL_SIZE, CELL_SIZE)];
            UIImageView * imageViewFirst = [[UIImageView alloc] initWithFrame:_figureViewFirst.bounds];
            imageViewFirst.image = [figureImageArray objectAtIndex:i];
            [self.figureViewFirst addSubview:imageViewFirst];
            [self.chessBoard addSubview:self.figureViewFirst];
            
            //добавляем вторых ладью, коня и слона
            _figureViewSecond = [[UIView alloc] initWithFrame:CGRectMake(CELL_SIZE*7 - CELL_SIZE*i, koef*CELL_SIZE, CELL_SIZE, CELL_SIZE)];
            UIImageView * imageViewSecond = [[UIImageView alloc] initWithFrame:_figureViewSecond.bounds];
            imageViewSecond.image = [figureImageArray objectAtIndex:i];
            [self.figureViewSecond addSubview:imageViewSecond];
            [self.chessBoard addSubview:self.figureViewSecond];
            
        } else if (i==4||i==3) {
            //добавляем короля и королеву
            _figureViewFirst = [[UIView alloc] initWithFrame:CGRectMake(CELL_SIZE*i, koef*CELL_SIZE, CELL_SIZE, CELL_SIZE)];
            UIImageView * imageViewFirst = [[UIImageView alloc] initWithFrame:_figureViewFirst.bounds];
            imageViewFirst.image = [figureImageArray objectAtIndex:i];
            [self.figureViewFirst addSubview:imageViewFirst];
            [self.chessBoard addSubview:self.figureViewFirst];
            
        } else {
        //добавляем пешки
            for (int j=0; j<8; j++) {
                _figureViewFirst = [[UIView alloc] initWithFrame:CGRectMake(CELL_SIZE*j, abs(1-koef)*CELL_SIZE, CELL_SIZE, CELL_SIZE)];
                UIImageView * imageViewFirst = [[UIImageView alloc] initWithFrame:_figureViewFirst.bounds];
                imageViewFirst.image = [figureImageArray objectAtIndex:i];
                [self.figureViewFirst addSubview:imageViewFirst];
                [self.chessBoard addSubview:self.figureViewFirst];
            }
        }
    };
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView: self.chessBoard];
    UIView * movedView = [self.chessBoard hitTest:point withEvent:event];
    if (![movedView isEqual: self.chessBoard]) {
        self.someView = movedView;
        [self.chessBoard bringSubviewToFront: movedView];
        UITouch * touch = [touches anyObject];
        point = [touch locationInView: self.someView];
        self.differencePoint = CGPointMake(CGRectGetMidX(self.someView.bounds)-point.x, CGRectGetMidY(self.someView.bounds)-point.y);
//        NSLog(@"touchpoint %@", NSStringFromCGPoint(point));
//        NSLog(@"difpoint %@", NSStringFromCGPoint(self.differencePoint));
    } else {
        self.someView = nil;
    }
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.someView) {
        UITouch * touch = [touches anyObject];
        CGPoint point = [touch locationInView: self.chessBoard];
        CGPoint mainPoint = CGPointMake (point.x + self.differencePoint.x, point.y + self.differencePoint.y);
        self.someView.center = mainPoint;
//        NSLog(@"mainpoint %@", NSStringFromCGPoint(mainPoint));
    }

}
                                                        

@end

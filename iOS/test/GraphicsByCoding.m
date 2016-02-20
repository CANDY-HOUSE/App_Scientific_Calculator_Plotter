

#import "GraphicsByCoding.h"

@implementation GraphicsByCoding

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        self.iconBango=0;
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
/*
 Only override drawRect: if you perform custom drawing.
 An empty implementation adversely affects performance during animation.
*/
    if(self.iconBango==1.0f){
        [self drawEllipse1:[UIColor whiteColor]];
    }else if(self.iconBango==1.1f){
        [self drawEllipse1:[UIColor blackColor]];
    }else if(self.iconBango==2.0f){
        [self drawHyperbola1:[UIColor whiteColor]];
    }else if(self.iconBango==2.1f){
        [self drawHyperbola1:[UIColor blackColor]];
    }else if(self.iconBango==3.0f){
        [self drawVhyperbola1:[UIColor whiteColor]];
    }else if(self.iconBango==3.1f){
        [self drawVhyperbola1:[UIColor blackColor]];
    }
}


-(void)drawEllipse1:(UIColor*)strokeColor{
    [strokeColor setStroke];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 25)];[path addLineToPoint:CGPointMake(70, 25)];
    [path moveToPoint:CGPointMake(35, 0)];[path addLineToPoint:CGPointMake(35, 50)];
    [path moveToPoint:CGPointMake(65, 22)];[path addLineToPoint:CGPointMake(70, 25)];[path addLineToPoint:CGPointMake(65, 28)];
    [path moveToPoint:CGPointMake(32, 5)];[path addLineToPoint:CGPointMake(35, 0)];[path addLineToPoint:CGPointMake(38, 5)];
    UIBezierPath *path2 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(15, 12.5, 40, 25)];
    [path setLineWidth:0.3];
    [path2 setLineWidth:0.5];
    [path stroke];
    [path2 stroke];
}
-(void)drawHyperbola1:(UIColor*)strokeColor{
    [strokeColor setStroke];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 25)];[path addLineToPoint:CGPointMake(70, 25)];
    [path moveToPoint:CGPointMake(35, 0)];[path addLineToPoint:CGPointMake(35, 50)];
    [path moveToPoint:CGPointMake(65, 22)];[path addLineToPoint:CGPointMake(70, 25)];[path addLineToPoint:CGPointMake(65, 28)];
    [path moveToPoint:CGPointMake(32, 5)];[path addLineToPoint:CGPointMake(35, 0)];[path addLineToPoint:CGPointMake(38, 5)];
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(11, 6)];
    [path2 addCurveToPoint:CGPointMake(11, 44) controlPoint1:CGPointMake(34, 25) controlPoint2:CGPointMake(34, 25)];
    [path2 moveToPoint:CGPointMake(59, 6)];
    [path2 addCurveToPoint:CGPointMake(59, 44) controlPoint1:CGPointMake(36, 25) controlPoint2:CGPointMake(36, 25)];
    [path setLineWidth:0.3];
    [path2 setLineWidth:0.5];
    [path stroke];
    [path2 stroke];
}
-(void)drawVhyperbola1:(UIColor*)strokeColor{
    [strokeColor setStroke];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 25)];[path addLineToPoint:CGPointMake(70, 25)];
    [path moveToPoint:CGPointMake(35, 0)];[path addLineToPoint:CGPointMake(35, 50)];
    [path moveToPoint:CGPointMake(65, 22)];[path addLineToPoint:CGPointMake(70, 25)];[path addLineToPoint:CGPointMake(65, 28)];
    [path moveToPoint:CGPointMake(32, 5)];[path addLineToPoint:CGPointMake(35, 0)];[path addLineToPoint:CGPointMake(38, 5)];
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(13, 5)];
    [path2 addCurveToPoint:CGPointMake(57, 5) controlPoint1:CGPointMake(35, 25) controlPoint2:CGPointMake(35, 25)];
    [path2 moveToPoint:CGPointMake(13, 45)];
    [path2 addCurveToPoint:CGPointMake(57, 45) controlPoint1:CGPointMake(35, 25) controlPoint2:CGPointMake(35, 25)];
    [path setLineWidth:0.3];
    [path2 setLineWidth:0.5];
    [path stroke];
    [path2 stroke];
}
@end

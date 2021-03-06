//
//  XDPlanLocalDefault.h
//  XDPlans
//
//  Created by xieyajie on 13-9-2.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#ifndef XDPlans_XDPlanLocalDefault_h
#define XDPlans_XDPlanLocalDefault_h

#define KPLAN_MAXEVENTCOUNT 20
#define KPLAN_CONTENT_MAXLENGHT 100

//Notification
#define KNOTIFICATION_LOGIN @"notification_login"
#define KNOTIFICATION_CUTFINISH @"notification_cutImageFinish"
#define KNOTIFICATION_MOVE @"notification_move"
#define KNOTIFICATION_PLANCHOOSECOLORFINISH @"notification_planChooseColorFinish"
#define KNOTIFICATION_PLANNEWFINISH @"notification_newPlanFinish"
#define KNOTIFICATION_PLANEDITFINISH @"notification_editPlanFinish"

//user header
#define KUSER_HEADERIMAGE_WIDTH 80.0
#define KUSER_HEADERIMAGE_HEIGHT 80.0

//all plans
#define toRadians(x) ((x)*M_PI / 180.0)
#define toDegrees(x) ((x)*180.0 / M_PI)

//today
#define KTODAY_CELL_HEIGHT_NORMAL 80.0
#define KTODAY_CELL_HEIGHT_CONTENT 150.0

//database

#define KDATABASE_NAME @"XDPlans_1.sqlite"



#endif

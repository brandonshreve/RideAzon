#import "bb_EventTableViewCell.h"
#import "bb_EventEntity.h"

@implementation bb_EventTableViewCell

-(void)awakeFromNib {
    // Initialization code
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)didSelectRemindMe:(id)sender {
    if ([_lbl_Reminder.text isEqualToString:kReminderRemindMe]) {
        _lbl_Reminder.text = kReminderCancelReminder;
    }
    else if (([_lbl_Reminder.text isEqualToString:kReminderCancelReminder])) {
        _lbl_Reminder.text = kReminderRemindMe;
    }
}

@end

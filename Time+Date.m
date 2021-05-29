NSDateFormatter *timeFormatter;
NSDateFormatter *dateFormatter;

BOOL is24Hour;

static BOOL timeIs24HourFormat() { // Thank you Michael Waterfall from StackOverflow
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    BOOL is24Hour = amRange.location == NSNotFound && pmRange.location == NSNotFound;
    [formatter release];
    return is24Hour;
}

static void initializeDateFormatters() {
  is24Hour = timeIs24HourFormat();

  timeFormatter = [[NSDateFormatter alloc] init];
	timeFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
  if(is24Hour) {
    [timeFormatter setLocalizedDateFormatFromTemplate:@"HH:mm"];
  }
  else {
    [timeFormatter setLocalizedDateFormatFromTemplate:@"h:mm"];
  }

	dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
	[dateFormatter setLocalizedDateFormatFromTemplate:@"MMM dd"];
}

static NSString *getTimeString() {
  NSString *timeString = [timeFormatter stringFromDate:[NSDate date]];
  if(!is24Hour) {
    timeString = [timeString substringToIndex: [timeString length]-3];
  }
  return timeString;
}

static NSString *getDateString() {
  return [dateFormatter stringFromDate:[NSDate date]];
}

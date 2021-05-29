WorldClockManager *worldClockManager = [NSClassFromString(@"WorldClockManager") sharedManager];
NSDateFormatter *worldClockDateFormatter;

static void initializeWorldClockDateFormatter() {
  worldClockDateFormatter = [[NSDateFormatter alloc] init];
	worldClockDateFormatter.dateStyle = NSDateFormatterNoStyle;
	worldClockDateFormatter.timeStyle = NSDateFormatterShortStyle;
}

static NSString *getWorldClockString() {
  [worldClockManager loadCities];
  WorldClockCity *city = [worldClockManager.cities objectAtIndex:0];
  worldClockDateFormatter.timeZone = [NSTimeZone timeZoneWithName:city.timeZone];
  NSString *timeString = [worldClockDateFormatter stringFromDate:[NSDate date]];
  if(!is24Hour) {
    char symbol = tolower([timeString characterAtIndex:[timeString length]-2]);
    timeString = [timeString substringToIndex: [timeString length]-3];
    timeString = [NSString stringWithFormat:@"%@%c", timeString, symbol];
  }
  return [NSString stringWithFormat:@"%@ %@", city.countryCode, timeString];
}

CLLocationManager *locationManager = [NSClassFromString(@"CLLocationManager") sharedManager];

static NSString *getCompassString() {
  [locationManager startUpdatingHeading];
  CLHeading *heading = locationManager.heading;
  CGFloat magneticHeading = heading.magneticHeading;
  if(magneticHeading > 337.5 || magneticHeading < 22.5) {
    return @"North";
  }
  else if((magneticHeading > 22.5) && (magneticHeading < 67.5)) {
    return @"Northeast";
  }
  else if((magneticHeading > 67.5) && (magneticHeading < 112.5)) {
    return @"East";
  }
  else if((magneticHeading > 112.5) && (magneticHeading < 157.5)) {
    return @"Southeast";
  }
  else if((magneticHeading > 157.5) && (magneticHeading < 202.5)) {
    return @"South";
  }
  else if((magneticHeading > 202.5) && (magneticHeading < 247.5)) {
    return @"Southwest";
  }
  else if((magneticHeading > 247.5) && (magneticHeading < 292.5)) {
    return @"West";
  }
  else if((magneticHeading > 292.5) && (magneticHeading < 337.5)) {
    return @"Northwest";
  }
  else {
    return @"Error";
  }
}
